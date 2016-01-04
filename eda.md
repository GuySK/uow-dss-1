---
title: "eda"
author: "gsk"
date: "16/12/2015"
output: html_document
---

Prudential Competition at Kaggle
---

## Exploratory Data Analysis

### Set up



```r
setwd(PATH)
train = read.table(file = './input/train.csv', header = T, sep = ',')
test = read.table(file = './input/test.csv', header = T, sep = ',')
all_data = rbind(train[, -128], test)
```

### Exploring the data set



#### Product_Info_1-7  A set of normalized variables relating to the product applied for

Structure of this group of data


```
## 'data.frame':	79146 obs. of  6 variables:
##  $ Product_Info_1: int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Product_Info_2: Factor w/ 19 levels "A1","A2","A3",..: 17 1 19 18 16 16 8 16 17 19 ...
##  $ Product_Info_3: int  10 26 26 10 26 26 10 26 26 21 ...
##  $ Product_Info_4: num  0.0769 0.0769 0.0769 0.4872 0.2308 ...
##  $ Product_Info_5: int  2 2 2 2 2 3 2 2 2 2 ...
##  $ Product_Info_6: int  1 3 3 3 3 1 3 3 3 3 ...
```


```
## 
## --- Product_Info_1 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.026   1.000   2.000 
## Table
##     1     2 
## 77087  2059
```

a two class unbalanced variable (1 or 2). It should be converted to factor.


```
## 
## --- Product_Info_2 ---
## factor 
## Table
##    A1    A2    A3    A4    A5    A6    A7    A8    B1    B2    C1    C2 
##  3219  3072  1564   263  1009  2733  1823  9140    85  1446   377   197 
##    C3    C4    D1    D2    D3    D4    E1 
##   437   291  8611  8344 18753 14071  3711
```

a factor of several unbalanced classes.


```
## 
## --- Product_Info_3 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1.00   26.00   26.00   24.39   26.00   38.00 
## Table
##     1     2     3     4     5     6     7     8     9    10    11    12 
##     1    11     2    75     1     5     2    60    13  8123    63     2 
##    13    14    15    16    17    18    19    20    21    22    23    24 
##     1     1   331     1     4     1     2     1    19     1    12     4 
##    25    26    27    28    29    30    31    32    33    34    35    36 
##     1 67711     1    51  1757    91   567     2    11     3     1    31 
##    37    38 
##   182     1
```

integers from 1 to 38 with some gaps. It should be converted to factor.


```
## 
## --- Product_Info_4 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 0.00000 0.07692 0.23080 0.32780 0.48720 1.00000
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-1.png) ![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-2.png) ![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8-3.png) 

a numeric variable in the range [0,1]


```
## 
## --- Product_Info_5 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   2.000   2.000   2.000   2.007   2.000   3.000 
## Table
##     2     3 
## 78604   542
```

a two class unbalanced variable (2, 3). It should be converted to factor.


```
## 
## --- Product_Info_6 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.669   3.000   3.000 
## Table
##     1     3 
## 13093 66053
```

a two class unbalanced variable with values (1, 3). It should be converted to factor.


```
## 
## --- Product_Info_7 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.044   1.000   3.000 
## Table
##     1     2     3 
## 77422     2  1722
```

a three class very unbalanced variabes of values (1, 2, 3). 
There are only two data points with value = 2. Should these data points be removed
fron the data set?. It should be converted to factor.

#### Ins_Age  
Normalized age of applicant


```
## 
## --- Ins_Age ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.2388  0.4179  0.4079  0.5672  1.0000
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png) ![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-2.png) ![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-3.png) 

```
## 372 zero values
```

why so many zeroes? Are they valid data points (babies?)
note that these are normalized variables. Zeros mean minimum values.

#### Ht  
Normalized height of applicant


```
## 
## --- Ht ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.6545  0.7091  0.7069  0.7636  1.0000
```

![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-1.png) ![plot of chunk unnamed-chunk-13](figure/unnamed-chunk-13-2.png) 

#### Wt  
Normalized weight of applicant


```
## 
## --- Wt ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.2259  0.2887  0.2926  0.3452  1.0000
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-1.png) ![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14-2.png) 

#### BMI  
Normalized BMI of applicant


```
## 
## --- BMI ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.3853  0.4525  0.4698  0.5337  1.0000
```

![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15-1.png) ![plot of chunk unnamed-chunk-15](figure/unnamed-chunk-15-2.png) 


```r
pairs(all_data[, 9:12], pch = 21)
```

![plot of chunk unnamed-chunk-16](figure/unnamed-chunk-16-1.png) 

#### Employment_Info_1-6  A set of normalized variables relating to the employment history of the applicant.


```
## 
## --- Employment_Info_1 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## 0.00000 0.03500 0.06000 0.07793 0.10000 1.00000      22
```

![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17-1.png) ![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17-2.png) 

```
## 
## --- Employment_Info_2 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   9.000   9.000   8.592   9.000  38.000 
## Table
##     1     2     3     4     5     6     7     8     9    10    11    12 
## 12151    36  2275    12     2    21     8     1 46307   218   579 10079 
##    13    14    15    16    17    18    19    20    21    22    23    24 
##    27  6262   608    25     1     4     6    18     7     2     5     1 
##    25    26    27    28    29    30    31    32    33    34    35    36 
##     4     7    53     1     1     3     1   257     4     8     2    81 
##    37    38 
##    67     2
```

this variable has also 38 values, like Product_Info_3. 


```r
length(unique(all_data[, var])) == length(unique(all_data[, 'Product_Info_3']))
```

```
## [1] TRUE
```

And the same values. Are both the same thing? 


```r
sum(all_data[, var] == all_data[, 'Product_Info_3']) / nrow(all_data)
```

```
## [1] 0.0001263488
```

Nop.

this variable should be converted to factor.


```
## 
## --- Employment_Info_3 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.307   1.000   3.000 
## Table
##     1     3 
## 66995 12151
```

a binary unbalanced variable. It should be converted to factor.


```
## 
## --- Employment_Info_4 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   0.000   0.000   0.006   0.000   1.000    8916
```

![plot of chunk unnamed-chunk-21](figure/unnamed-chunk-21-1.png) ![plot of chunk unnamed-chunk-21](figure/unnamed-chunk-21-2.png) 

```
## 59616 Zeros
## 8916 NAs
```

numeric in the range [0,1] with a great proportion of NAs and lots of zeroes.
there are 10614 non-zero data points.


```
## 
## --- Employment_Info_5 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   2.000   2.000   2.000   2.144   2.000   3.000 
## Table
##     2     3 
## 67711 11435
```

a binary unbalanced variable (2,3). It should be converted to factor. 


```
## 
## --- Employment_Info_6 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   0.060   0.250   0.363   0.580   1.000   14641
```

![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23-1.png) ![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23-2.png) ![plot of chunk unnamed-chunk-23](figure/unnamed-chunk-23-3.png) 

#### InsuredInfo_1-6  
A set of normalized variables providing information about the applicant.


```
## 
## --- InsuredInfo_1 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.208   1.000   3.000 
## Table
##     1     2     3 
## 63045 15738   363 
## 
## --- InsuredInfo_2 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   2.000   2.000   2.000   2.007   2.000   3.000 
## Table
##     2     3 
## 78559   587 
## 
## --- InsuredInfo_3 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   6.000   5.801   8.000  11.000 
## Table
##     1     2     3     4     5     6     7     8     9    10    11 
##  1127  7254 21704  1231   273 12821   398 27969    23  1402  4944 
## 
## --- InsuredInfo_4 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   2.000   3.000   3.000   2.886   3.000   3.000 
## Table
##     2     3 
##  9030 70116 
## 
## --- InsuredInfo_5 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.028   1.000   3.000 
## Table
##     1     3 
## 78042  1104 
## 
## --- InsuredInfo_6 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.412   2.000   2.000 
## Table
##     1     2 
## 46528 32618
```

all InsuredInfo variables are discrete variables of just a few values and should be converted to factor.

#### Insurance_History_1-9  
A set of normalized variables relating to the insurance history of the applicant.


```
## 
## --- Insurance_History_1 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   2.000   1.722   2.000   2.000 
## Table
##     1     2 
## 21980 57166 
## 
## --- Insurance_History_2 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.054   1.000   3.000 
## Table
##     1     2     3 
## 77001     1  2144 
## 
## --- Insurance_History_3 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   3.000   2.156   3.000   3.000 
## Table
##     1     2     3 
## 33396     1 45749 
## 
## --- Insurance_History_4 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   2.000   1.948   3.000   3.000 
## Table
##     1     2     3 
## 37568  8109 33469 
## 
## --- Insurance_History_5 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       0       0       0       0       0       1   33501
```

![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25-1.png) ![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25-2.png) 

```
## 
## --- Insurance_History_7 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.899   3.000   3.000 
## Table
##     1     2     3 
## 41438  4236 33472 
## 
## --- Insurance_History_8 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   2.000   2.046   3.000   3.000 
## Table
##     1     2     3 
## 21030 33467 24649 
## 
## --- Insurance_History_9 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   2.414   3.000   3.000 
## Table
##     1     2     3 
##   692 44982 33472
```

![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25-3.png) ![plot of chunk unnamed-chunk-25](figure/unnamed-chunk-25-4.png) 

Insurance_History_5 seens to have a few outliers with values close to 1. All other variables in the group should be converted to factor.

#### Family_Hist_1-5  
A set of normalized variables relating to the family history of the applicant.


```
## 
## --- Family_Hist_1 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   3.000   2.687   3.000   3.000 
## Table
##     1     2     3 
##   714 23376 55056 
## 
## --- Family_Hist_2 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    0.36    0.46    0.47    0.58    1.00   38536
```

![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-1.png) ![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-2.png) 

```
## 
## --- Family_Hist_3 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    0.41    0.52    0.50    0.61    1.00   45305
```

![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-3.png) ![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-4.png) 

```
## 
## --- Family_Hist_4 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   0.324   0.437   0.445   0.563   1.000   25861
```

![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-5.png) ![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-6.png) 

```
## 
## --- Family_Hist_5 ---
## numeric 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    0.41    0.51    0.49    0.58    1.00   55435
```

![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-7.png) ![plot of chunk unnamed-chunk-26](figure/unnamed-chunk-26-8.png) 

convert Family Hist 1 to factor. Watch out with NAs in the rest of the group.

#### Medical_History_1-41  
A set of normalized variables relating to the medical history of the applicant.


```
## 
## --- Medical_History_1 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.000   2.000   4.000   7.929   9.000 240.000   11861 
## Table
##     0     1     2     3     4     5     6     7     8     9    10    11 
##  6336 10111  7583  6361  4912  4321  3983  2816  2224  1975  1749  1577 
##    12    13    14    15    16    17    18    19    20    21    22    23 
##  2317  1133   948   753   688   617   602   445   361   342   341   333 
##    24    25    26    27    28    29    30    31    32    33    34    35 
##   445   250   239   242   188   196   188   155   118   126   108   111 
##    36    37    38    39    40    41    42    43    44    45    46    47 
##   131    85    86    92    73    54    63    66    56    44    41    42 
##    48    49    50    51    52    53    54    55    56    57    58    59 
##    56    38    57    37    48    39    47    50    43    41    23    33 
##    60    61    62    63    64    65    66    67    68    69    70    71 
##    46    18    23    24    30    22    16    15    16    18    15    13 
##    72    73    74    75    76    77    78    79    80    81    82    83 
##    15    10     7    11    19     9    14    12     7    10    13     9 
##    84    85    86    87    88    89    90    91    92    93    94    95 
##     9    11     9     9    11     5    13     8    10     7     8     9 
##    96    97    98    99   100   101   102   103   104   105   106   107 
##     9     7     5     6     7     5     2     3     3     2     2     3 
##   108   109   110   111   112   113   114   115   116   117   118   119 
##     6     5     8     4     5     3     4     5     6     6     3     3 
##   120   121   122   123   124   125   126   127   128   130   131   132 
##    13     4     7     7     2     3     3     2     3     1     2     1 
##   134   136   137   138   141   143   145   146   147   148   150   153 
##     6     2     1     2     1     1     3     4     3     3     2     1 
##   154   155   156   158   159   160   161   162   163   169   171   172 
##     2     2     1     2     2     2     1     1     1     3     2     1 
##   173   174   175   176   178   179   180   182   185   187   189   191 
##     5     1     1     2     1     2     4     4     1     1     1     1 
##   193   201   223   225   228   229   233   235   239   240 
##     1     1     1     1     1     1     1     1     1     3 
## 
## --- Medical_History_2 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     1.0   112.0   162.0   252.9   413.0   648.0 
## Table
##     1     2     3     4     5     6     7     8     9    10    11    12 
##    33    14  1931     1     8     1    88     7     6    10     2     5 
##    13    14    15    16    17    18    19    20    21    22    23    24 
##     9   338     8  3904     1     2     7    62    23    52     1     1 
##    25    26    27    28    29    30    31    32    33    34    35    36 
##     1     4     9    35     4     5     1     7   251    19    77    17 
##    37    38    39    40    41    42    43    44    45    46    47    48 
##     3     3     2     2    30   109   121     6     1     1    15   281 
##    49    50    51    52    53    54    55    56    57    58    59    60 
##     1     4     1   349     2     1     8    14   353    29     5     4 
##    61    62    63    64    65    66    67    68    69    70    71    72 
##    10     3     7     1     1     1    12    16     3    40     4    21 
##    73    74    75    76    77    78    79    81    82    83    84    85 
##     3    23     1     9     8     5    20    60   121     1    21     2 
##    86    87    88    89    90    91    92    93    94    95    96    97 
##     1    15    17     3    21     5     1     2     5     5    18     1 
##    98    99   100   101   102   103   104   105   106   107   108   109 
##    19     2     5     1     1     3     2     2     2     2    66    40 
##   110   111   112   113   114   115   116   117   119   120   121   122 
##     3    15 14849     9     3     7     2     1     1     8    18    84 
##   123   124   125   126   127   128   129   131   132   133   134   135 
##    42     3   270     1     5     4    10     7   670     1     8     1 
##   136   137   138   139   140   141   142   143   144   145   146   147 
##     1     1     3     9   220     3     2     3    18  1244     1     7 
##   148   149   150   151   152   153   154   155   156   157   158   159 
##     1     1     2    59    36    18     5  1292   654     3     1     2 
##   160   161   162   163   164   165   166   167   169   170   171   172 
##   185  3946 11082     9    26     2    33    22    12     3    24     2 
##   173   174   175   176   177   178   179   180   181   182   183   184 
##     3     4     3     1    36     1     3    48   497    10     8     1 
##   185   186   187   188   189   190   191   192   193   194   195   196 
##    10     6     3    19     1    13     9   190     3     1     5     8 
##   197   198   199   200   201   202   203   204   205   207   208   209 
##     2     5     2     3     1   343     6     2    16     1    16     1 
##   210   211   212   213   214   215   216   217   218   219   220   221 
##     1     1    21    28    30     1     1   389     7     5     1     1 
##   222   223   224   225   226   227   228   229   230   231   232   233 
##    16    43    15     3     6     1   268     2    80     1    16     3 
##   234   235   236   237   238   239   240   241   242   243   244   245 
##    12     1     2     2    11    30     2     1     1     1     1    90 
##   246   247   248   249   250   251   252   253   255   256   257   258 
##     1     1     1    17     1    16     1    11    91     2    12    25 
##   259   260   261   262   264   265   266   267   268   269   270   271 
##     4   222  3044     4   168    87     6     5    24     1     1     1 
##   272   273   274   275   276   277   278   279   280   281   282   283 
##    41     1    50    12   382    17   272     3   119    14    40     3 
##   285   286   287   288   289   290   291   292   293   294   295   296 
##     2     7    26     6     3    36     1     1     6     9     5     3 
##   297   298   299   301   302   303   304   305   306   307   310   311 
##     2    90    20    12    12    13     1     8    32    42     5     7 
##   312   313   314   315   316   317   318   319   320   321   322   323 
##     1    16    18     1     1    71    20     1    58     2     1    30 
##   324   326   327   328   329   330   331   332   333   334   335   336 
##    77     5     5     1    16    52     4     3     2     1  4017     2 
##   337   338   339   340   341   342   343   344   345   346   347   348 
##     1    14     1     2     1     1     1     2     1     4     2     9 
##   349   350   351   352   353   354   355   356   357   358   360   361 
##    46   209    23     3     6   164    16     1    37    10     2     3 
##   362   363   364   366   367   368   369   370   371   372   373   374 
##     6     2    14   887     1     9     6    23     1     8   192     1 
##   375   376   377   378   379   380   381   382   383   384   385   386 
##     1     4     2    19   102     2     2    11    12     1     2    16 
##   387   388   389   390   391   392   393   394   395   396   397   398 
##   849     4     1    62    59     1     3     1     5     7     2     2 
##   399   400   401   402   403   404   405   406   407   408   409   410 
##     6     1     1     1   156    55     2     1   241     4     6     1 
##   411   412   413   414   415   416   417   418   419   420   421   422 
##    29   182   106     5    63    10     9   185     1     3    36     1 
##   423   424   425   426   427   428   429   430   431   432   433   434 
##     2     1     2     1     1    21     1     1    21     3     1   580 
##   435   436   437   438   439   440   441   442   443   444   445   446 
##     4     3    57     4     1     4    83     1     6    47     1    76 
##   447   448   449   450   451   452   453   454   455   456   457   458 
##     7     2     2     1     8     4   549     1     1     2     4     7 
##   459   461   462   463   464   465   466   467   468   469   470   471 
##    94    10     7     1     1     1     5     1    19     1     3     1 
##   472   473   474   475   476   477   478   479   480   481   482   483 
##    38     7     1     1     6    49  2596     1     8     8     3    33 
##   484   485   486   487   488   489   490   491   492   493   494   495 
##    60     1     6    17     2    31     3  7675     1     3     2     1 
##   496   497   498   499   501   502   503   504   505   506   507   508 
##     5    56     1     3    32     2     5    29     2    10    15     1 
##   509   510   511   512   513   514   515   516   517   518   519   520 
##    36     8    18     1     2    33   173     2     1    30     8     1 
##   521   522   523   524   525   526   527   528   529   530   531   532 
##     4    24     2     1     3    53    38   424     8     2     1    49 
##   533   534   536   537   538   539   540   541   542   543   544   545 
##     1    37     1     5     1     1     4     4     1     3     5     2 
##   546   547   548   549   550   551   552   553   554   555   557   558 
##     1     1    30     3     4     2    16     2    12     1     1     2 
##   559   560   561   562   563   564   565   566   567   568   569   570 
##     9     5   169     1     8   163  1333    19     2     8     5    85 
##   571   572   573   574   575   576   577   578   579   580   581   582 
##    60     1     2     1   178     1     6     1    90     1     7     1 
##   583   584   586   587   588   589   590   591   592   593   594   595 
##     4     1     3     4     3    11     2     1     1     1     1     2 
##   596   597   598   599   600   601   602   603   605   606   607   608 
##     9     1     1    20   325     2     1     3     4     1     8     6 
##   609   610   611   612   613   614   615   616   617   618   619   620 
##    58   251     3     1  1013     2    28     1    46     2     5     2 
##   621   622   623   624   625   626   627   628   629   630   631   632 
##     6     5     2    14     1    19   129  1551    42    12    91    61 
##   633   634   635   636   637   638   639   640   641   642   643   644 
##    67     6     4     2     3     3     2     4     5     6     3     2 
##   645   646   647   648 
##     1     1     2     1 
## 
## --- Medical_History_3 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   2.113   2.000   3.000 
## Table
##     1     2     3 
##     4 70159  8983 
## 
## --- Medical_History_4 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   2.000   1.656   2.000   2.000 
## Table
##     1     2 
## 27239 51907 
## 
## --- Medical_History_5 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.007   1.000   3.000 
## Table
##     1     2     3 
## 78563   581     2 
## 
## --- Medical_History_6 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.889   3.000   3.000 
## Table
##     1     2     3 
##  4383     2 74761 
## 
## --- Medical_History_7 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   2.012   2.000   3.000 
## Table
##     1     2     3 
##   690 76788  1668 
## 
## --- Medical_History_8 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   2.044   2.000   3.000 
## Table
##     1     2     3 
##  1690 72276  5180 
## 
## --- Medical_History_9 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   1.771   2.000   3.000 
## Table
##     1     2     3 
## 18096 61046     4 
## 
## --- Medical_History_10 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    9.25  225.00  143.40  240.00  240.00   78388 
## Table
##   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  19 
##  97  26  16   8   5  12   6   9   8   3   3   2   5   5   3   2   3   4 
##  20  21  22  24  26  27  28  32  35  39  40  42  43  44  47  48  49  50 
##   2   1   3   4   2   3   4   2   1   1   3   2   2   1   1   2   1   1 
##  51  52  54  55  56  57  58  59  61  62  63  64  66  69  71  75  76  77 
##   1   3   1   2   1   3   1   4   1   1   1   1   1   1   1   3   1   2 
##  79  80  83  84  85  86  87  91  92  97  98 102 104 111 112 113 115 116 
##   1   1   2   3   1   1   1   2   1   2   1   1   1   4   2   2   2   3 
## 117 119 120 121 122 125 126 127 131 133 136 137 139 142 146 147 148 150 
##   1   1   4   1   1   1   1   1   1   1   2   1   1   2   1   1   1   1 
## 156 158 160 162 167 170 171 175 176 180 181 182 183 185 190 191 196 199 
##   2   1   1   1   1   1   1   2   6   2   3   1   3   2   1   1   3   1 
## 201 207 216 218 219 220 221 223 225 229 230 231 234 235 236 237 238 240 
##   1   1   1   1   1   1   1   2   2   2   1   1   3   4   2   1   1 363 
## 
## --- Medical_History_11 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.994   3.000   3.000 
## Table
##     1     2     3 
##   114   253 78779 
## 
## --- Medical_History_12 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   2.056   2.000   3.000 
## Table
##     1     2     3 
##     1 74722  4423 
## 
## --- Medical_History_13 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.768   3.000   3.000 
## Table
##     1     2     3 
##  9188     4 69954 
## 
## --- Medical_History_14 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.969   3.000   3.000 
## Table
##     1     2     3 
##   329  1803 77014 
## 
## --- Medical_History_15 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##     0.0    18.0   117.0   124.2   240.0   240.0   59460 
## Table
##    0    1    2    3    4    5    6    7    8    9   10   11   12   13   14 
## 2864  313  163  133   95   85   99   80   77   53   45   64  160  140  156 
##   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29 
##  139  115  100  116   86   60   57   45   61  108   58   79   65   75   67 
##   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44 
##   71   57   55   44   52   44   77   68   64   61   48   51   49   52   43 
##   45   46   47   48   49   50   51   52   53   54   55   56   57   58   59 
##   34   35   45   53   41   47   57   47   57   62   50   41   46   44   59 
##   60   61   62   63   64   65   66   67   68   69   70   71   72   73   74 
##   87   60   49   62   63   55   64   53   53   43   42   52   50   46   46 
##   75   76   77   78   79   80   81   82   83   84   85   86   87   88   89 
##   37   49   60   39   33   51   38   32   39   54   49   36   52   41   51 
##   90   91   92   93   94   95   96   97   98   99  100  101  102  103  104 
##   40   51   31   23   35   30   39   28   24   33   24   37   35   26   24 
##  105  106  107  108  109  110  111  112  113  114  115  116  117  118  119 
##   28   35   22   24   38   34   49   53   60   68   57   62   57   42   56 
##  120  121  122  123  124  125  126  127  128  129  130  131  132  133  134 
##   71   52   49   51   38   31   38   26   30   30   22   28   33   30   30 
##  135  136  137  138  139  140  141  142  143  144  145  146  147  148  149 
##   27   30   35   17   30   20   30   17   27   26   32   33   21   25   33 
##  150  151  152  153  154  155  156  157  158  159  160  161  162  163  164 
##   23   18   19   24   20   21   28   30   30   36   31   30   39   29   20 
##  165  166  167  168  169  170  171  172  173  174  175  176  177  178  179 
##   19   24   19   29   39   34   44   51   46   69   60   58   40   51   45 
##  180  181  182  183  184  185  186  187  188  189  190  191  192  193  194 
##   43   33   58   36   51   39   40   30   21   21   28   23   18   25   26 
##  195  196  197  198  199  200  201  202  203  204  205  206  207  208  209 
##   25   27   18   18   24   19   18   18   11   29   12   11   16   26   21 
##  210  211  212  213  214  215  216  217  218  219  220  221  222  223  224 
##   23   17   14   22   13   24   17   17   16   21   21   18   25   24   12 
##  225  226  227  228  229  230  231  232  233  234  235  236  237  238  239 
##   13   19   15   21   25   33   46   41   46   50   42   53   40   44   38 
##  240 
## 6140 
## 
## --- Medical_History_16 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.327   1.000   3.000 
## Table
##     1     2     3 
## 66222     1 12923 
## 
## --- Medical_History_17 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.978   3.000   3.000 
## Table
##     1     2     3 
##     1  1744 77401 
## 
## --- Medical_History_18 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.054   1.000   3.000 
## Table
##     1     2     3 
## 74923  4209    14 
## 
## --- Medical_History_19 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.034   1.000   3.000 
## Table
##     1     2     3 
## 76427  2713     6 
## 
## --- Medical_History_20 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   1.985   2.000   3.000 
## Table
##     1     2     3 
##  1170 77974     2 
## 
## --- Medical_History_21 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.109   1.000   3.000 
## Table
##     1     2     3 
## 70553  8588     5 
## 
## --- Medical_History_22 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   1.982   2.000   2.000 
## Table
##     1     2 
##  1398 77748 
## 
## --- Medical_History_23 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.517   3.000   3.000 
## Table
##     1     2     3 
## 19096     1 60049 
## 
## --- Medical_History_24 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    1.00    8.00   50.45   63.00  240.00   74165 
## Table
##    0    1    2    3    4    5    6    7    8    9   10   11   12   13   14 
## 1010  551  239  199  125  117  124   81   76   57   47   44  112   48   31 
##   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29 
##   30   38   36   27   35   27   25   24   32   36   19   23   27   15   17 
##   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44 
##   17   25   16   17   12   20   15   18   14   11   11   10   18   12   14 
##   45   46   47   48   49   50   51   52   53   54   55   56   57   58   59 
##    9    7    9    8   10    5   11   17   19   21   18   18   12   12   12 
##   60   61   62   63   64   65   66   67   68   69   70   71   72   73   74 
##   19   11    9   10   10    6    8   12    7    8    8    9    6   15    5 
##   75   76   77   78   79   80   81   82   83   84   85   86   87   88   89 
##    9    5   10    5   11    3    3    1   11    8    6    3    6    4    4 
##   90   91   92   93   94   95   96   97   98   99  100  101  102  103  104 
##    4    9    5    2    8    8    6    8    2    8    4    4    5    3    3 
##  105  106  107  108  109  110  111  112  113  114  115  116  117  118  119 
##    8    1    2    3    6    8   12   14   10   14    8   10    9   15    7 
##  120  121  122  123  124  125  126  127  128  129  130  131  132  133  134 
##   16    5    7    4    3    8    1    7    5    3    4    4    6    3    2 
##  135  136  137  138  139  140  141  142  143  144  145  146  147  148  149 
##    2    3    3    7    2   12    1    3    3    3    3    4    2    3    2 
##  150  151  152  153  154  155  156  157  158  159  160  161  162  163  164 
##    2    1    1    1    4    2    5    1    2    4    7    2    2    4    1 
##  165  166  167  168  169  170  171  172  173  174  175  176  177  178  179 
##    4    1    1    3    4    6    5    8    7   12    9    8    8   10    6 
##  180  181  182  183  184  185  186  188  189  190  191  192  193  194  196 
##    2    3    7    1    3    6    4    1    3    2    1    4    3    3    4 
##  197  198  199  200  202  204  205  206  207  208  209  210  213  215  216 
##    2    2    1    4    2    1    2    2    3    1    3    3    1    2    1 
##  217  218  219  220  221  222  223  225  226  227  228  229  230  231  232 
##    1    1    1    2    1    1    2    1    4    4    1    9    2    4    7 
##  233  234  235  236  237  238  239  240 
##    7    7    9    6    3    5    4  432 
## 
## --- Medical_History_25 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.195   1.000   3.000 
## Table
##     1     2     3 
## 63994 14844   308 
## 
## --- Medical_History_26 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.808   3.000   3.000 
## Table
##     1     2     3 
##     6 15146 63994 
## 
## --- Medical_History_27 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1.00    3.00    3.00    2.98    3.00    3.00 
## Table
##     1     2     3 
##   770     9 78367 
## 
## --- Medical_History_28 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.068   1.000   3.000 
## Table
##     1     2     3 
## 73807  5333     6 
## 
## --- Medical_History_29 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.546   3.000   3.000 
## Table
##     1     2     3 
## 17946     4 61196 
## 
## --- Medical_History_30 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   2.041   2.000   3.000 
## Table
##     1     2     3 
##     6 75876  3264 
## 
## --- Medical_History_31 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.986   3.000   3.000 
## Table
##     1     2     3 
##   573     1 78572 
## 
## --- Medical_History_32 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    0.00    0.00   11.72    2.00  240.00   77688 
## Table
##   0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17 
## 979 101  42  27  14  19  17   4   6   7  12  10  12  15   5   9   4   5 
##  18  19  20  21  22  23  24  25  26  27  28  29  30  31  34  35  36  37 
##   6   2   6   3   2   3   6   1   3   2   2   3   2   2   2   2   3   1 
##  39  40  42  43  44  45  47  48  49  50  51  52  54  56  57  58  59  61 
##   1   1   2   2   3   2   3   4   1   1   2   3   2   2   2   1   1   1 
##  62  63  66  67  68  70  76  80  82  83  87  91  94  96  97 100 101 102 
##   1   1   4   1   2   1   2   1   2   3   2   1   2   2   1   2   1   1 
## 105 109 110 111 112 113 115 116 119 128 129 132 133 135 140 141 145 156 
##   1   2   1   1   1   1   1   1   1   1   1   2   1   1   1   1   1   1 
## 157 158 166 170 174 177 180 181 184 206 208 218 219 227 232 240 
##   1   1   1   1   1   1   1   2   1   1   1   1   1   1   1  19 
## 
## --- Medical_History_33 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.803   3.000   3.000 
## Table
##     1     2     3 
##  7802     1 71343 
## 
## --- Medical_History_34 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.693   3.000   3.000 
## Table
##     1     2     3 
## 12160     5 66981 
## 
## --- Medical_History_35 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.002   1.000   3.000 
## Table
##     1     2     3 
## 79060     3    83 
## 
## --- Medical_History_36 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1.00    2.00    2.00    2.18    2.00    3.00 
## Table
##     1     2     3 
##   911 63082 15153 
## 
## --- Medical_History_37 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   1.938   2.000   3.000 
## Table
##     1     2     3 
##  4944 74200     2 
## 
## --- Medical_History_38 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.005   1.000   3.000 
## Table
##     1     2     3 
## 78757   388     1 
## 
## --- Medical_History_39 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1.00    3.00    3.00    2.83    3.00    3.00 
## Table
##     1     2     3 
##  6743     4 72399 
## 
## --- Medical_History_40 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   3.000   3.000   2.968   3.000   3.000 
## Table
##     1     2     3 
##  1263     4 77879 
## 
## --- Medical_History_41 ---
## integer 
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   1.000   1.000   1.644   3.000   3.000 
## Table
##     1     2     3 
## 53663     1 25482
```

According to the data documentation, Medical_History_1, Medical_History_15, Medical_History_24, Medical_History_32 are discrete variables.

![plot of chunk unnamed-chunk-28](figure/unnamed-chunk-28-1.png) ![plot of chunk unnamed-chunk-28](figure/unnamed-chunk-28-2.png) ![plot of chunk unnamed-chunk-28](figure/unnamed-chunk-28-3.png) ![plot of chunk unnamed-chunk-28](figure/unnamed-chunk-28-4.png) 

#### Medical_Keyword_1-48  
A set of dummy variables relating to the presence of/absence of a medical keyword being associated with the application.

![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-1.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-2.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-3.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-4.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-5.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-6.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-7.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-8.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-9.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-10.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-11.png) ![plot of chunk unnamed-chunk-29](figure/unnamed-chunk-29-12.png) 

#### Response  
This is the target variable, an ordinal variable relating to the final decision associated with an application.


```r
par(mfcol = c(1,1))
barplot(table(train[, 'Response']), main = 'Response')
```

![plot of chunk unnamed-chunk-30](figure/unnamed-chunk-30-1.png) 

What is the null rate for this variable?

```r
round(table(all_data$Response)/nrow(all_data),3)
```

```
## numeric(0)
```

So if we classified every unknown data point as 8 we should expect an accuracy of about 32%.
