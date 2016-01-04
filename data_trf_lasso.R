#
# Data transformation for lasso regression model
# 

#path    = 'Training/uow-dss-spec/prog-assgn/assignment6/prudential'
if (!exists('GDP'))
  stop('Google Drive path not defined.')

cat('==> Running data transformation script')

# read data
#PATH     = paste(GDP, path, sep = '/')                   
train    = read.table(file = paste(PATH, 'input', 'train.csv', sep = '/'), 
                      header = T, sep = ',')
test    = read.table(file = paste(PATH, 'input', 'test.csv', sep = '/'), 
                      header = T, sep = ',')
dims    = c(nrow(train), nrow(test))
Target  = train$Response
test_Id = test$Id
data = rbind(train[, -128], test)

# format conversions
# convert categorical variables to factor
cats = c('Product_Info_1', 'Product_Info_2', 'Product_Info_3', 'Product_Info_5', 
         'Product_Info_6', 'Product_Info_7', 'Employment_Info_2', 'Employment_Info_3',
         'Employment_Info_5', 'InsuredInfo_1', 'InsuredInfo_2', 'InsuredInfo_3',
         'InsuredInfo_4', 'InsuredInfo_5', 'InsuredInfo_6', 'InsuredInfo_7',
         'Insurance_History_1', 'Insurance_History_2', 'Insurance_History_3',
         'Insurance_History_4', 'Insurance_History_7', 'Insurance_History_8',
         'Insurance_History_9', 'Family_Hist_1', 'Medical_History_2', 'Medical_History_3',
         'Medical_History_4', 'Medical_History_5', 'Medical_History_6', 'Medical_History_7',
         'Medical_History_8', 'Medical_History_9', 'Medical_History_10', 'Medical_History_11',
         'Medical_History_12', 'Medical_History_13', 'Medical_History_14', 
         'Medical_History_16', 'Medical_History_17', 'Medical_History_18', 
         'Medical_History_19', 'Medical_History_20', 'Medical_History_21', 
         'Medical_History_22', 'Medical_History_23', 'Medical_History_25', 
         'Medical_History_26', 'Medical_History_27', 'Medical_History_28', 
         'Medical_History_29', 'Medical_History_30', 'Medical_History_31', 
         'Medical_History_33', 'Medical_History_34', 'Medical_History_35', 
         'Medical_History_36', 'Medical_History_37', 'Medical_History_38', 
         'Medical_History_39', 'Medical_History_40', 'Medical_History_41')

data[, cats] = lapply(data[, cats], factor)

# dummy variables
# Medical_Keyword_1-48 are dummy variables.
dummies = paste0(rep('Medical_Keyword_', 48), 1:48)
data[, dummies] = lapply(data[, dummies], factor)
rm(cats, dummies)

# let's see what features to keep and rows to drop 
sum(complete.cases(data))
nas = sapply(data[, 2:127], function(x){sum(is.na(x))})
nas = nas[order(-nas)]
for (i in 1:length(nas)){
  if (nas[i] > 0) {
    cat(names(nas)[i], nas[i], round(nas[i] / nrow(data), 3), '\n')
  }
}

# 
# Data transformation. Second part
#

# we'll remove any feature with more 10% of data points unavailable
# or just keep the one with MIN NAs...

na_idx = which(is.na(data$Employment_Info_1))
length(na_idx)                                  # 22 rows with Empl Info 1 = NA  
sum(na_idx > dims[1])                           #  3 of them in test data set
na_idx[na_idx > dims[1]]                        # these ones

MIN_NAs = 22
remove_features = names(nas[nas > MIN_NAs])
data = data[, !(names(data) %in% remove_features)]
sum(complete.cases(data))

# We've got MIN cases due to Employment_Info_1
summary(data$Employment_Info_1)
data$Employment_Info_1[is.na(data$Employment_Info_1)] = mean(data$Employment_Info_1, na.rm = T)
if (sum(complete.cases(data)) == nrow(data))
  cat('Data transformed ok \n')
rm(train, test)

