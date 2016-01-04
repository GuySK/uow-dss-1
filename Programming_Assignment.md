---
title: "Practical Predictive Analytics: Models and Methods"
author: "gsk"
date: "02/01/2016"
output: html_document
---

Kaggle Competition Peer Review
---

## Problem Description

### Objectives

For this assignment, I chose the Prudential Life Insurance Assessment competition at Kaggle. Prudential, one of the largest issuers of life insurance in the USA, has established this competition to make the life insurance application process quicker and less labor intensive for new and existing customers to get a quote while maintaining privacy.  

The goal of the competition is to develop a predictive model that accurately classifies risk. The results will help Prudential better understand the predictive power of the data points in the existing assessment, enabling them to significantly streamline the process.

### Data set description

In this dataset, you are provided over a hundred variables describing attributes of life insurance applicants. The task is to predict the "Response" variable for each Id in the test set. "Response" is an ordinal measure of risk that has 8 levels. The participant gets access to the following data sets.

* train.csv - the training set, contains the Response values
* test.csv - the test set, you must predict the Response variable for all rows in this file
* sample_submission.csv - a sample submission file in the correct format

#### Data fields

| Variable |  Description |
| -------- | ------------ |
| Id |	A unique identifier associated with an application. | 
| Product_Info_1-7 |	A set of normalized variables relating to the product applied for |
| Ins_Age	| Normalized age of applicant |
| Ht	| Normalized height of applicant |
| Wt	| Normalized weight of applicant |
| BMI	| Normalized BMI of applicant |
| Employment_Info_1-6	| A set of normalized variables relating to the employment history of the applicant. |
| InsuredInfo_1-6	 | A set of normalized variables providing information about the applicant. |
| Insurance_History_1-9	 | A set of normalized variables relating to the insurance history of the applicant. |
| Family_Hist_1-5	 | A set of normalized variables relating to the family history of the applicant. |
| Medical_History_1-41	| A set of normalized variables relating to the medical history of the applicant. |
| Medical_Keyword_1-48	 | A set of dummy variables relating to the presence of/absence of a medical keyword being associated with the application. |
| Response | This is the target variable, an ordinal variable relating to the final decision associated with an application |

### Evaluation

Submissions are scored based on the quadratic weighted kappa, which measures the agreement between two ratings. This metric typically varies from 0 (random agreement) to 1 (complete agreement). In the event that there is less agreement between the raters than expected by chance, this metric may go below 0. [For more information on this metric...](https://en.wikipedia.org/wiki/Cohen%27s_kappa)

## Analysis Approach

### Exploratory Data Analysis

My first steps were to conduct an exploratory data analysis on the whole data set. This first encounter with the data is mainly focused in getting to know the basic characteristics of the different features that compose the data set.

We can highlight several issues from this analysis.

* There are several variables with a great proportion of missing values (NAs in R terminology). 

* Independent variables have been 'anonymized' and standardized. For instance, we have no way of knowing which are the medical keywords represented by binary values 'Medical_Keyword_1' to 'Medical_Keyword_48'. In the same way, we have no way of knowing what particular entities are represented by the following groups of variables.

  1. Product Info 1-7
  1. Employment Info 1-6
  1. Insured Info 1-6
  1. Insurence History 1-9
  1. Family History 1-5
  1. Medical History 1-41
  1. Medical Keywords 1-48

To these variables, we should add those related to personal information, such as:

  * Age
  * Height
  * Weight
  * BMI
  
<br>* The target variable ('Response') is an ordinal variable that is unbalanced in the number of cases present in the training data set.

A detailed description of the findings in the exploratory analysis of all these features can be found in these document [EDA](https://github.com/GuySK/uow-dss-1/blob/master/eda.md). 

### Initial approach

#### Algorithm selection

Since the response variable is of type ordinal, I decided to approach the problem as a regression problem instead of a classification one. A second important decision regarding the model was to define the algorithm to use as a first approach.

Since there is a considerable number of features and we cannot rule out an important number cases of correlated variables, and since explicability is one of the objectives of the problem solution, I decided to use an algorithm with the following characteristics,

* It provides a way to rank the importance of the independent variables.

* It provides a way to reduce the dimensionality of the problem.

* It provides enough performance to manage the problem's data volume with my limited computational resources.

Following these initial definitions I tried fitting a 'lasso' model, since it allows for reducing the weights of the linear regression coefficients to zero and adjusting the remaining coefficients according to the importance of the features.

Unfortunately, the *LASSO* proved to be too slow in this case, so I decided to switch to a tree-based boosting method implemented by the *xgboost* package in R, well-known for its high performance, parallel processing characteristics.

The script used to train the LASSO model can be found [here](https://github.com/GuySK/uow-dss-1/blob/master/lasso_2.R). It is worth mentioning that on top of being slow, the LASSO scored just 0.50, far below the first results I obtained with my first boosting approaches. 

#### Data pre-processing

In order to fit a linear regression model it is important to take into account two important issues.

1. Missing values should be eliminated from the training and testing sets.
1. Independent variables must be encoded as either numeric or categorical variables to be handled efficiently by the training algorithm.

In summary, I decided to suppress from the training data set variables that presented a significant number of missing values. A second important decision was to use the one-hot encoding format for factor variables, to allow for a better management of possible interactions by the algorithm. [This script](https://github.com/GuySK/uow-dss-1/blob/master/data_trf_lasso.R) contains the code to accomplish those objectives. 

#### First results with xgboost

The first results with this model can be found in [this document](https://github.com/GuySK/uow-dss-1/blob/master/xgboost_2.md). Score was up to 0.57 with a small improvement over the LASSO model.

There are several points to start working with from now on, assuming the xgboost is our model of choice. *xgboost* has several parameters to optimize. As it can be seen from the log in the previous run, the parameter NROUNDS that control the number of trees to grow to reduce approximate the target value (in our case the residuals, since we're doint a liner regression). It is very important to set up the correct value to this parameter to avoid overfitting the data. In the previous script, NROUNDS were chosen by cross-validating it using the function *xgb.cv* provided by the **XGBOOST** R package.

### Further tuning of the model

Boosting is a technique that basically consists in growing trees sequentially to approximate the target function (by minimizing a loss function). So, additionally to the number of trees used there are other important parameters, like the depth of the trees (NDEPTH) and the rate of learning (ETA). 

In order to select these parameters, I wrote a script for cross-validate them and tune them in sequence. It could have been theoretically possible to use a grid selection process like the one provided by the package *CARET* but the number of alternatives and the computational requirements on my computer would have been to much.

The script for tuning these parameters can be found [here](https://github.com/GuySK/uow-dss-1/blob/master/xgboost_3.md).

### Next steps

There are still several ways to try to improve the model's results. Among them:

* Further parameter tuning
* Feature selection
* Dimensionality reduction
* Exploring additional models to compose an ensemble.

I will continue this research since the competition deadline is still months away. Unfortunately, the deadline for this assignment has not allowed for time to achieve better results in this particularly tough problem (the leader in the competition has achieved so far a score of 0.68). 

In my last attempts at reducing the dimensionality of the problem I achieved a score just above 0.58 by replacing the Medical Keywords by their first ten principal components. The script used for this purpose can be inspect [here](https://github.com/GuySK/uow-dss-1/blob/master/xgboost_4.R).





