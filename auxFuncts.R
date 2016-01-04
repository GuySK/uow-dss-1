#
# auxFuncts.R
#

get_pcs = function(data, varexp){
  # converts data to n principal components 
  # with a minimum of variance explained
  data = apply(data, 2, as.integer)    # convert to binary matrix 
  data_pc = prcomp(data)               # get principal components
  summ_pc = summary(data_pc)           # use summ to get tot variance explained
  totvar = summ_pc$importance[3,]      # total variance explained
  npc = min(which(totvar >= varexp))   # find min nr of pcs to explain var
  data %*% data_pc$rotation[, 1:npc]   # return data projected onto pcs
}

truth = function(target, preds, class, table = FALSE){
  # library(Metrics)
  
  # convert to binary
  target[target != class] = 0 
  target[target == class] = 1
  preds[preds != class]   = 0
  preds[preds == class]   = 1
  
  # create contingency table and compute metrics
  tab = table(Target = target, Preds = preds)
  precision  = tab[2,2] / sum(tab[,2])    # TP / (TP + FP)
  recall     = tab[2,2] / sum(tab[2,])    # TP / (TP + FN)
  class_err = 1 - (sum(!xor(target, preds)) / length(target)) 
  # class_err2 = ce(actual = target, predicted = preds)
  
  # output
  if (table) {
    cat('Truth table for class = ', class, '\n')
    cat('Precision', precision, '/ Recall', recall)
    cat(' / Cl err.', class_err, '\n')
    tab
  } else {
    c(cl_err = class_err, prec = precision, recall = recall)
  }
}

classes <- function(preds){
  preds = round(preds)
  preds[preds < 1] = 1
  preds[preds > 8] = 8
  preds
}

increasing_err = function(errs, k){
  # stops run if k runs with increasing errors  
  if (length(errs) <= k)
    return(FALSE)  
  for (i in 1:k){
    if (errs[length(errs)] < errs[length(errs) - i])
      return(FALSE)
  }
  return(TRUE)
}

split_val = function(data, test = 0.4, seed = 123){
  # creates cross validation train and test data sets
  set.seed(seed)
  test_prop = test
  sample(1:nrow(data), size = nrow(data) * (1 - test_prop), replace = F)
}

create_cv = split_val    # synonym for old scripts support

create_sub = function(ids, preds, fn){
  # creates a submission file 
  ds = data.frame(Id = ids, Response = as.integer(preds))
  fo = write_sub(ds, fn)
  cat('submission file created Ok \n')
}

write_sub = function(df, fn){
  # writes a submission file in proper format
  fileout = paste(PATH, 'output', fn, sep = '/')
  write.table(x = df, 
              file = fileout, 
              col.names = T, 
              row.names = F, 
              sep = ','
  )
  fileout
}

save_mdl = function(mdl, ...){
    # saves a model for further use
    fileout = paste(PATH, 'output', deparse(substitute(mdl)), sep = '/')
    save(mdl, file = fileout, ...)
}

set_path = function(os = 'Win', path = NULL) {
    # returns the right path depending on operating system
    if (is.null(path)) {
        path = 'Training/uow-dss-spec/prog-assgn/assignment6/prudential'        
    } 
    
    if (substr('windows', 1, nchar(os)) == tolower(os)){
        gd = 'C:/Users/AAB330/Google Drive 2'
    }
    if (substr('linux', 1, nchar(os)) == tolower(os)){
        gd = '~/Google Drive'
    }
    
    paste(gd, path, sep = '/')
}

