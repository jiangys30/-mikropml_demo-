#' Default model hyperparameters
#'
#' @format a data frame with 51 rows and 3 columns
#' \describe{
#'   \item{param}{hyperparameter}
#'   \item{value}{value of the hyperparameter}
#'   \item{method}{ML method that the hyperparameter applies to}
#' }
"default_hyperparams"

#' Large OTU abundance dataset
#'
#' A dataset containing relatives abundances of 6,920 OTUs for 490 human stool samples
#'
#' @format A data frame with 490 rows and 6,921 variables.
#' The `dx` column is the diagnosis: healthy or cancerous (colorectal).
#' All other columns are OTU relative abundances.
"otu_large"

#' Medium-sized OTU abundance dataset
#'
#' A dataset containing relatives abundances of 6,920 OTUs for 60 human stool samples
#'
#' @format A data frame with 60 rows and 6921 variables.
#' The `dx` column is the diagnosis: healthy or cancerous (colorectal).
#' All other columns are OTU relative abundances.
"otu_medium"

#' Small OTU abundance dataset
#'
#' A dataset containing relatives abundances of 60 OTUs for 60 human stool samples
#'
#' @format A data frame with 60 rows and 61 variables.
#' The `dx` column is the diagnosis: healthy or cancerous (colorectal).
#' All other columns are OTU relative abundances.
"otu_small"

#' A training data partition from `otu_small`
"train_data_sm"

#' A test data partition from `otu_small`
"test_data_sm"

#' A trained model from L2 logistic regression on `train_data_sm`
"trained_model_sm"

#' 5-fold cross validation on `train_data_sm`
"otu_sm_cv5"

#' Results from running the pipline with L2 logistic regression on `otu_small`
"otu_sm_results"

#' A training data partition from `otu_medium`
"train_data1"

#' A test data partition from `otu_medium`
"test_data1"

#' A trained model from L2 logistic regression on `train_data1`
"trained_model1"