#
# Lasso regression
#

# Note. this script must be run after 'data_trf_lasso'

gdw     = 'C:/Users/AAB330/Google Drive 2'
gdl     = '~/Google Drive'
path    = 'Training/uow-dss-spec/prog-assgn/assignment6/prudential'

# change Google drive path depending on the machine the script is running on.
GDP     = gdl      # running on linux 

# set up
PATH = paste(GDP, path, sep = '/')
setwd(PATH)

# create data matrix
library(glmnet)
x = model.matrix(Response ~ .-Id, 
                 data = cbind(data[1:dims[1],], Response = Target))
xtest = model.matrix(Response ~ .-Id, 
                     data = cbind(data[dims[1]+1:dims[2],], Response = 1))
rm(data)

# cross validate train data to choose lambda
cv.lasso = cv.glmnet(x = x[1:dims[1],],    # train data 
                     y = Target,           # response
                     alpha = 1,            # lasso
                     nfolds = 10           # number of folders in cv
                     )

# let's take a look at the optimum lambda
(cv.lasso$lambda.min)
(cv.lasso$lambda.1se)
with(cv.lasso, plot(cv.lasso$cvm, type = 'l', ylab = name))
lines(cv.lasso$cvup, lt = 2)
lines(cv.lasso$cvlo, lt = 2)
(idx = which(cv.lasso$lambda == cv.lasso$lambda.1se))
with(cv.lasso, abline(h = cvm[idx]))
with(cv.lasso, abline(v = idx))

# Ok, so let's make predictions on the test data set
source(paste(PATH, 'code', 'auxFuncts.R', sep = '/'))
preds = round(predict(cv.lasso, newx = xtest, s = 'lambda.1se'))
preds[preds < 1] = 1
preds[preds > 8] = 8
subm_ds = data.frame(Id = test_Id, Response = as.integer(preds), row.names = NULL)
write_sub(df = subm_ds, fn = 'lasso.csv')

#
# submission result         0.50615
# best result so far        same
# Improvement from bst lr   0.05057 and moved up 47 positions
#
#

# let's save the model just in case...
save_mdl(cv.lasso, compress = T)

