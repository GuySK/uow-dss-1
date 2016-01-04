
## XGBOOST - cross validation of several parameters

### Set up



```r
# change Google drive path depending on the machine the script is running on.
GDP     = gdl      # running on linux 
# GDP     = gdw      # running on windows 

PATH = paste(GDP, path, sep = '/')
setwd(PATH)
source('./code/auxFuncts.R')
```

### transform features 



```r
source('./code/data_trf_lasso.R')
```

```
## Warning in file(filename, "r", encoding = encoding): cannot open file './
## code/data_trf_lasso.R': No such file or directory
```

```
## Error in file(filename, "r", encoding = encoding): cannot open the connection
```

### convert to sparse matrix format


```r
library(Matrix)
sp_matrix = sparse.model.matrix(~ . -1, data = data[, 2:ncol(data)])
dim(sp_matrix)
```

```
## [1] 79146   881
```

```r
feature_names = dimnames(sp_matrix)[[2]]
```

### create cross validation train and test data sets 

We now create the train and validation data sets as well as the folders for cross validation.


```r
tr_data = sp_matrix[1:dims[1],]
idx = create_cv(tr_data)
train = tr_data[idx,]
test  = tr_data[-idx,]
Target_trn = Target[idx]
Target_tst = Target[-idx]

# create cv folders
set.seed(456)
nfolders = 10
folder   = sample(rep(1:nfolders, length = nrow(train)))
```

### error functions


```r
# root mean square error
rmse = function(y, y_hat){
  sqrt(sum((y - y_hat) ** 2) / length(y))
}
# mean absolute error
mae = function(y, y_hat){
  sum(abs(y - y_hat)) / length(y)
}

# set error evaluation function
eval_err =  rmse     
eval_err_name = 'Root Mean Square Error'
```

### Cross validation of Max.Depth parameter


```r
# model parameters
NROUNDS     = 500
ETA         = 0.3            # we use the defautl value here
MAX.DEPTH_P = 1:10           # cross-validation parameter
EVAL.METRIC = 'rmse'
SUB.SAMPLE  = 1
param_name  = 'max.depth'    # name of parameter being cross validated
nruns_up    = 3              # number of runs with increasing errors to stop

# Begin run
library(xgboost)
cat('Cross validation of param J in ', MAX.DEPTH_P, '- ' )
```

```
## Cross validation of param J in  1 2 3 4 5 6 7 8 9 10 -
```

```r
cat('Error function:', eval_err_name, '\n')
```

```
## Error function: Root Mean Square Error
```

```r
cv_err = matrix(rep(NA, length(MAX.DEPTH_P) * nfolders), nrow = nfolders)
err_param = rep(NA, length(MAX.DEPTH_P)) 
  
# Main cv loop 
for (i in 1:length(MAX.DEPTH_P)){
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
```

```
## Training model with parameter J =  1 .......... Root Mean Square Error 1.946146 
## Training model with parameter J =  2 .......... Root Mean Square Error 1.910263 
## Training model with parameter J =  3 .......... Root Mean Square Error 1.910584 
## Training model with parameter J =  4 .......... Root Mean Square Error 1.926745 
## Training model with parameter J =  5 .......... Root Mean Square Error 1.945141 
## Run stopped due to  3 increasing errors.
```

### Plot mean error rate vs MAX.DEPTH


```r
merr = apply(cv_err, 2, mean)
plot(MAX.DEPTH_P, merr, type = 'l', main = eval_err_name)
```

![plot of chunk ch8](figure/ch8-1.png) 

```r
best_J = which.min(merr)
cat ('==> choose', param_name, '=', MAX.DEPTH_P[best_J], '\n')
```

```
## ==> choose max.depth = 2
```

### Cross validation of ETA parameter


```r
NROUNDS     = 500
ETA_P       = seq(from = 0.05, to = 0.5, by = 0.05)    # cv parameter
MAX.DEPTH   = MAX.DEPTH_P[best_J]
EVAL.METRIC = 'rmse'    
SUB.SAMPLE  = 1
NFOLDS      = 10

# Begin run
library(xgboost)
cat('Cross validation of eta in ', ETA_P, '- ' )
```

```
## Cross validation of eta in  0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 -
```

```r
cat('Error function:', eval_err_name, '\n')
```

```
## Error function: Root Mean Square Error
```

```r
cv_err = matrix(rep(NA, length(ETA_P) * nfolders), nrow = nfolders)
err_param = rep(NA, length(ETA_P)) 

# Main cv loop 
for (i in 1:length(ETA_P)){
  # inform purpose of cross validation
  cat('Training model with ETA = ', ETA_P[i], '')
  
  # set up run parameters
  params = list(objective = 'reg:linear',
                eta       = ETA_P[i],
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
```

```
## Training model with ETA =  0.05 .......... Root Mean Square Error 1.925059 
## Training model with ETA =  0.1 .......... Root Mean Square Error 1.912482 
## Training model with ETA =  0.15 .......... Root Mean Square Error 1.909931 
## Training model with ETA =  0.2 .......... Root Mean Square Error 1.910179 
## Training model with ETA =  0.25 .......... Root Mean Square Error 1.909939 
## Training model with ETA =  0.3 .......... Root Mean Square Error 1.910263 
## Run stopped due to  3 increasing errors.
```

```r
param_name = 'eta'
merr = apply(cv_err, 2, mean)
best_eta = which.min(merr)
cat ('==> choose', param_name, '=', ETA_P[best_eta], '\n')
```

```
## ==> choose eta = 0.15
```

### Plot mean error rate vs eta


```r
plot(ETA_P, merr, type = 'l', main = eval_err_name)
abline(v = ETA_P[best_eta])
text(ETA_P[best_eta] +0.01, merr[best_eta] +0.005, labels = ETA_P[best_eta])
abline(h = merr[best_eta])
text(0.075, merr[best_eta] + 0.001, labels = merr[best_eta])
```

![plot of chunk ch10](figure/ch10-1.png) 

### Cross validation of NROUNDS parameter


```r
NROUNDS     = 500
ETA         = ETA_P[best_eta]
MAX.DEPTH   = MAX.DEPTH_P[best_J]
EVAL.METRIC = 'rmse'    # should this be 'mae' instead?
SUB.SAMPLE  = 1
NFOLDS      = 10

params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              nfold     = NFOLDS,
              silent    = 1)  

bst_nr = xgb.cv(params = params, 
                data           = train,
                label          = Target_trn,
                nfold          = NFOLDS,
                nrounds        = NROUNDS,
                verbose        = 0,
                early.stop.run = 10)

best_nr = which.min(bst_nr$test.rmse.mean)
```

### Plot error rate vs nrounds


```r
plot(bst_nr$test.rmse.mean, type = 'l', main = 'rmse', xlab = 'nrounds')
abline(v = best_nr)
text(best_nr +5, bst_nr$test.rmse.mean[best_nr] +0.10, labels = best_nr)
abline(h = bst_nr$test.rmse.mean[best_nr])
text(10, bst_nr$test.rmse.mean[best_nr] +0.10, labels = bst_nr$test.rmse.mean[best_nr])
```

![plot of chunk ch12](figure/ch12-1.png) 

### Evaluating results on our validation set


```r
# use optimized parameters
NROUNDS     = best_nr
ETA         = ETA_P[best_eta]
MAX.DEPTH   = MAX.DEPTH_P[best_J]
EVAL.METRIC = 'rmse'    
SUB.SAMPLE  = 1

params = list(objective = 'reg:linear',
              eta       = ETA,
              max_depth = MAX.DEPTH,
              subsample = SUB.SAMPLE,
              eval_metric = EVAL.METRIC,
              nrounds    = NROUNDS,
              nfold     = NFOLDS,
              silent    = 1)

# train model on training set
bst.fit = xgboost(data = train, 
                  label = Target_trn,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 0,
                  early.stop.run = 10,
                  params = params)

# evaluate with validation data set
preds = predict(bst.fit, newdata = test)
test_err = eval_err(y = Target_tst, y_hat = preds)
preds_cl = classes(preds)
con_table = table(Target = Target_tst, Preds = preds_cl)
(round(con_table / length(Target_tst) * 100, 2))
```

```
##       Preds
## Target     1     2     3     4     5     6     7     8
##      1  0.75  1.09  1.55  2.08  2.38  1.79  0.94  0.08
##      2  0.48  1.07  1.85  2.33  2.56  1.90  0.81  0.05
##      3  0.01  0.05  0.17  0.59  0.56  0.28  0.06  0.00
##      4  0.00  0.00  0.03  0.17  0.79  1.12  0.27  0.01
##      5  0.09  0.29  1.11  2.91  3.06  1.36  0.53  0.03
##      6  0.04  0.16  0.70  2.26  5.75  7.00  2.61  0.18
##      7  0.00  0.02  0.04  0.51  2.61  5.51  4.14  0.44
##      8  0.00  0.00  0.04  0.32  1.47  7.35 18.27  5.38
```

```r
# plots 
plot(density(Target_tst), 
     main = 'Distribution of Target Classes', xlab = 'Test cases')
```

![plot of chunk ch13](figure/ch13-1.png) 

```r
metrics = matrix(rep(0, 24), nrow = 8)
for (k in 1:8){
  metrics[k,] = truth(Target_tst, preds_cl, k)
}

dimnames(metrics)[[2]] = names(truth(Target_tst, preds_cl, 1))
for (k in 1:3){
  plot(metrics[, k], type = 'l', ylim = c(0,1), main = dimnames(metrics)[[2]][k])    
}
```

![plot of chunk ch13](figure/ch13-2.png) ![plot of chunk ch13](figure/ch13-3.png) ![plot of chunk ch13](figure/ch13-4.png) 

```r
# get a score in competition's metrics (quadratic Kappa) for out validation set
library("Metrics")
```

```
## 
## Attaching package: 'Metrics'
## 
## The following objects are masked _by_ '.GlobalEnv':
## 
##     mae, rmse
```

```r
(ScoreQuadraticWeightedKappa(preds_cl, Target_tst))  # [1] 0.5454393
```

```
## [1] 0.5455101
```

### Make a submission


```r
# first we train our whole train data
bst.fit = xgboost(data = tr_data, 
                  label = Target,
                  nrounds = params$nrounds,
                  silent = params$silent,
                  verbose = 0,
                  early.stop.run = 10,
                  params = params)

tst_data = sp_matrix[(dims[1]+1):nrow(sp_matrix),]
preds = predict(bst.fit, newdata = tst_data)
pred_cl_sub = classes(preds)
create_sub(ids = test_Id, preds = pred_cl_sub, fn = 'xgboost_111.csv')
```

```
## submission file created Ok
```

Submission score: 0.55907
