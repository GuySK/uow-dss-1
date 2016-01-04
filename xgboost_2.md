### xgboost linear regression with one-hot encoding

### Set up




```r
# change Google drive path depending on the machine the script is running on.
GDP     = gdl      # running on linux 
# GDP     = gdw      # running on windows 
```

# set up


```r
PATH = paste(GDP, path, sep = '/')
setwd(PATH)
source('./code/auxFuncts.R')
```

### Transform features 

```r
print(getwd())
```

```
## [1] "/home/guye/Google Drive/Training/uow-dss-spec/prog-assgn/assignment6/prudential/code"
```

```r
source('data_trf_lasso.R')
```

```
## ==> Running data transformation scriptMedical_History_10 78388 0.99 
## Medical_History_32 77688 0.982 
## Medical_History_24 74165 0.937 
## Medical_History_15 59460 0.751 
## Family_Hist_5 55435 0.7 
## Family_Hist_3 45305 0.572 
## Family_Hist_2 38536 0.487 
## Insurance_History_5 33501 0.423 
## Family_Hist_4 25861 0.327 
## Employment_Info_6 14641 0.185 
## Medical_History_1 11861 0.15 
## Employment_Info_4 8916 0.113 
## Employment_Info_1 22 0 
## Data transformed ok
```


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

# now that we have all features one-hot encoded, we can try xgboost again
library(xgboost)
dtrain = sp_matrix[1:dims[1],]
cv.bst = xgb.cv(data = dtrain,
                label = Target,
                objective = 'reg:linear',
                metrics = list('rmse'),
                nrounds = 100,
                nfold   = 10,
                verbose = 0
                )
(best_nr = which.min(cv.bst$test.rmse.mean))
```

```
## [1] 53
```

```r
bst.fit = xgboost(data = dtrain, 
                  label = Target,
                  objective = 'reg:linear',
                  verbose = 0,
                  nrounds = best_nr)
```

### Get predictions


```r
dtest = sp_matrix[(dims[1]+1):nrow(sp_matrix),]
preds = round(predict(bst.fit, newdata = dtest))
preds[preds < 1] = 1
preds[preds > 8] = 8

### write submission file
create_sub(ids = test_Id, preds = preds, fn = 'xgboost_2.csv')
```

```
## submission file created Ok
```

### Submission results

* Score:    0.57027 
* Up/down:  +0.06412 
* Position: up 137 to 723 


```r
save_mdl(bst.fit)
```
