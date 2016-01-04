
#
# xgboost - a first attempt to use pcs for medical keywords
#

# set up
# setwd("C:/Users/AAB330/Google Drive 2/Training/uow-dss-spec/prog-assgn/assignment6/prudential")
setwd("~/Google Drive/Training/uow-dss-spec/prog-assgn/assignment6/prudential")
GDP = '~/Google Drive'

source('./code/auxFuncts.R')

# transform features 
source('./code/data_trf_lasso.R')

# convert to sparse matrix format
library(Matrix)
sp_matrix = sparse.model.matrix(~ . -1, data = data[, 2:ncol(data)])
feature_names = dimnames(sp_matrix)[[2]]

# convert medical keywords
medk = sp_matrix[, 68:115]    
new_medk = get_pcs(data = medk, varexp = 0.8)
sp_matrix_2 = sp_matrix[, -(68:115)]
sp_matrix_2 = cbind(sp_matrix_2, new_medk)
cat('New matrix has dimensions', dim(sp_matrix_2), '\n')

# separate train and test data sets
train_data = sp_matrix_2[1:dims[1],]
test_data  = sp_matrix_2[(dims[1]+1):nrow(sp_matrix_2),]

# let's fit a model with the parameters we learned with all med keywords

# split train and validation data sets
idx = split_val(data = train_data)
train = train_data[idx,]
test  = train_data[-idx,]
Target_trn = Target[idx]
Target_tst = Target[-idx]

# train model with optimal parameters and evaluate on test data set

# error functions
# root mean square error
rmse = function(y, y_hat){
  sqrt(sum((y - y_hat) ** 2) / length(y))
}
# mean absolute error
mae = function(y, y_hat){
  sum(abs(y - y_hat)) / length(y)
}

# set error evaluation function
eval_err =  mae     
eval_err_name = 'Mean Absolute Error'

# parameters
NROUNDS     = 104
ETA         = 0.15
MAX.DEPTH   = 8
EVAL.METRIC = 'rmse'    # this should be 'mae' instead
SUB.SAMPLE  = 1

params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              #nfold     = NFOLDS,
              silent    = 1)  
library(xgboost)
bst.fit = xgboost(data = train, 
                  label = Target_trn,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 1,
                  early.stop.run = 10,
                  params = params)
preds = predict(bst.fit, newdata = test)
(eval_err(y = Target_tst, y_hat = preds))   # mae = [1] 1.440115 now 1.445906
pred_cls = classes(preds)                   # get classes

library(Metrics)
(ScoreQuadraticWeightedKappa(pred_cls, Target_tst)) # [1] 0.561778 now [1] 0.5580591
# variation is -0.0037189 ... - 0.66%... 
# What if we cross validate parameters again?

# create cv folders
set.seed(456)
nfolders = 10
folder   = sample(rep(1:nfolders, length = nrow(train)))

# error functions
# root mean square error
rmse = function(y, y_hat){
  sqrt(sum((y - y_hat) ** 2) / length(y))
}
# mean absolute error
mae = function(y, y_hat){
  sum(abs(y - y_hat)) / length(y)
}

# set error evaluation function
eval_err =  mae     
eval_err_name = 'Mean Absolute Error'

# global parameters
NROUNDS     = 300
ETA         = 0.1
MAX.DEPTH_P = 1:10
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1
param_name  = 'max.depth'    # name of parameter being cross validated
nruns_up    = 3              # number of runs with increasing errors to stop

# Begin run
library(xgboost)
cat('Cross validation of param J in ', MAX.DEPTH_P, '- ' )
cat('Error function:', eval_err_name, '\n')
cv_err = matrix(rep(NA, length(MAX.DEPTH_P) * nfolders), nrow = nfolders)
err_param = rep(NA, length(MAX.DEPTH_P)) 

# Main cv loop 
for (i in MAX.DEPTH_P){
  # inform purpose of cross validation
  cat('Training model with parameter J = ', MAX.DEPTH_P[i], '')
  
  # set up run parameters
  params = list(objective = 'reg:linear',
                eta       = ETA,
                max_depth = MAX.DEPTH_P[i],
                subsample = SUB.SAMPLE,
                eval_metric = EVAL.METRIC,
                nrounds    = NROUNDS,
                silent    = 1
  )  
  
  # fit model for each folder
  for (k in 1:nfolders){
    cat('.')
    bst.fit = xgboost(data = train[folder != k,], 
                      label = Target_trn[folder != k],
                      nrounds = params$nrounds,
                      silent = params$silent,
                      verbose = 0,
                      early.stop.run = 10,
                      params = params)
    resp = Target_trn[folder == k]
    pred = predict(bst.fit, newdata = train[folder == k,])
    
    # compute run error 
    cv_err[k,i] = eval_err(resp, pred)
  }
  
  # inform mean error rate for Parameter 
  err_param[i] =  mean(cv_err[,i])
  cat('', eval_err_name, err_param[i], '\n')
  
  # check if run must be stopped
  if (increasing_err(err_param[1:i], nruns_up)){
    cat('Run stopped due to ', nruns_up, 'increasing errors. \n')
    break
  }
}

# plot mean error rate vs MAX.DEPTH
merr = apply(cv_err, 2, mean)
plot(MAX.DEPTH_P, merr, type = 'l', main = eval_err_name)
abline(v = 8)
abline(h = min(merr))
text(1.1, min(merr), label = round(min(merr), 3))
best_J = which.min(merr)
cat ('==> choose', param_name, '=', best_J, '\n')

# now, let's cross validate ETA
# global parameters
NROUNDS     = 300
ETA_P       = seq(from = 0.05, to = 1, by = 0.05)
MAX.DEPTH   = best_j    # 8
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1
nruns_up    = 3              # number of runs with increasing errors to stop
cv_param    = ETA_P          # Param to be cross validated 
param_name  = 'eta'          # name of parameter being cross validated

# Begin run
library(xgboost)
cat('Cross validation of', param_name, 'in ', cv_param, '- ' )
cat('Error function:', eval_err_name, '\n')
cv_err = matrix(rep(NA, length(cv_param) * nfolders), nrow = nfolders)
err_param = rep(NA, length(cv_param)) 

# Main cv loop 
for (i in 1:length(cv_param)){
  # inform purpose of cross validation
  cat('Training model with ', param_name, ' = ', cv_param[i], '')
  
  # set up run parameters
  params = list(objective = 'reg:linear',
                eta       = cv_param[i],
                max_depth = MAX.DEPTH,
                subsample = SUB.SAMPLE,
                eval_metric = EVAL.METRIC,
                nrounds    = NROUNDS,
                silent    = 1
  )  
  
  # fit model for each folder
  for (k in 1:nfolders){
    cat('.')
    bst.fit = xgboost(data = train[folder != k,], 
                      label = Target_trn[folder != k],
                      nrounds = params$nrounds,
                      silent = params$silent,
                      verbose = 0,
                      early.stop.run = 10,
                      params = params)
    resp = Target_trn[folder == k]
    pred = predict(bst.fit, newdata = train[folder == k,])
    
    # compute run error 
    cv_err[k,i] = eval_err(resp, pred)
  }
  
  # inform mean error rate for Parameter 
  err_param[i] =  mean(cv_err[,i])
  cat('', eval_err_name, err_param[i], '\n')
  
  # check if run must be stopped
  if (increasing_err(err_param[1:i], nruns_up)){
    cat('Run stopped due to ', nruns_up, 'increasing errors. \n')
    break
  }
}

# plot mean error rate vs cv_param 
merr = apply(cv_err, 2, mean)
merr = merr[!is.na(merr)]
best_param = cv_param[which.min(merr)]
cat ('==> choose', param_name, '=', best_param, '\n')

plot(cv_param[1:length(merr)], merr, type = 'l', 
     main = eval_err_name, xlab = param_name)
abline(v = best_param)
abline(h = min(merr))
text(cv_param[1], min(merr), label = round(min(merr), 3))
# from now on we will use this value of eta
best_eta = best_param

# and now we cross validate nrounds
# we use xgb.cv function for that
# global parameters
NROUNDS     = 300
ETA         = best_eta,    # 0.1
MAX.DEPTH   = best_j       # 8
EVAL.METRIC = 'rmse'
NFOLDS      = 10
SUB.SAMPLE  = 1
nruns_up    = 3              # number of runs with increasing errors to stop

library(xgboost)
bst_nr = xgb.cv(params = params, 
                data           = train,
                label          = Target_trn,
                nfold          = NFOLDS,
                nrounds        = NROUNDS,
                early.stop.run = 10)

best_nr = which.min(bst_nr$test.rmse.mean)
plot(bst_nr$test.rmse.mean, type = 'l', main = 'rmse', xlab = 'nrounds')
abline(v = best_nr)
text(best_nr +5, bst_nr$test.rmse.mean[best_nr] +0.10, labels = best_nr)
abline(h = bst_nr$test.rmse.mean[best_nr])
text(10, bst_nr$test.rmse.mean[best_nr] +0.10, labels = bst_nr$test.rmse.mean[best_nr])

# let's train our model in the whole train data set with the 
# optimal parameters and test it with our validation data set

NROUNDS     = best_nr      # 22
ETA         = best_eta     # 0.1
MAX.DEPTH   = best_J       # 8
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1

params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              silent    = 1) 

bst.fit_22 = xgboost(data = train, 
                  label = Target_trn,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 1,
                  early.stop.run = 10,
                  params = params)

preds   = predict(bst.fit_22, newdata = test)
(mae_val = eval_err(Target_tst, preds))                 # [1] 1.735178
pred_cls = classes(preds)
library(Metrics)
(ScoreQuadraticWeightedKappa(pred_cls, Target_tst))     # [1] 0.4840268
# Note. this metric is substantially worse than the previous one.
# since J and nrounds should be inversely proportional... this is not 
# surprising... What if I retrain the model with a much bigger nround value?

NROUNDS     = 300
ETA         = best_eta     # 0.1
MAX.DEPTH   = best_J       # 8
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1

params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              silent    = 1) 

bst.fit_300 = xgboost(data = train, 
                  label = Target_trn,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 1,
                  early.stop.run = 10,
                  params = params)

preds   = predict(bst.fit_300, newdata = test)
(mae_val = eval_err(Target_tst, preds))                 # [1] 1.440939
pred_cls = classes(preds)
library(Metrics)
(ScoreQuadraticWeightedKappa(pred_cls, Target_tst))     # [1] 0.5643255

# What if we increase nround still 
NROUNDS     = 500
ETA         = best_eta     # 0.1
MAX.DEPTH   = best_J       # 8
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1

params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              silent    = 1) 

bst.fit_500 = xgboost(data = train, 
                  label = Target_trn,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 1,
                  early.stop.run = 10,
                  params = params)

preds   = predict(bst.fit_500, newdata = test)
(mae_val = eval_err(Target_tst, preds))                 # [1] 1.442272
pred_cls = classes(preds)
library(Metrics)
(ScoreQuadraticWeightedKappa(pred_cls, Target_tst))     # [1] 0.5653467

# Just a bit better...
# Conclusion: our cross validation of nrounds was wrong...!
# What if we make a submission with both models (nrounds 22 and 500)

NROUNDS     = 22
ETA         = best_eta     # 0.1
MAX.DEPTH   = best_J       # 8
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1
params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              silent    = 1) 

bst.022 = xgboost(data = train_data, 
                  label = Target,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 1,
                  early.stop.run = 10,
                  params = params)

preds = predict(bst.022, newdata = test_data)
pred_cl_sub = classes(preds)
create_sub(ids = test_Id, preds = pred_cl_sub, fn = 'xgboost_8_022.csv')

# and now with nround = 500
NROUNDS     = 500
ETA         = best_eta     # 0.1
MAX.DEPTH   = best_J       # 8
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1
params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              silent    = 1) 

bst.500 = xgboost(data = train_data, 
                  label = Target,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 1,
                  early.stop.run = 10,
                  params = params)

preds = predict(bst.500, newdata = test_data)
pred_cl_sub = classes(preds)
create_sub(ids = test_Id, preds = pred_cl_sub, fn = 'xgboost_8_500.csv')
#
# xgboost_8_022 = 0.48550, 
#
# xgboost_8_500 = 0.58208 best entry up 0.00254
# 

# things to change, improve, research, study, etc...
# 1. cross validation of nrounds parameter
# 2. evaluation metric parameter
# 3. simplify model still further by using pcs for other features




