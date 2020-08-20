
#' Check all params that don't return a value
#'
#' @inheritParams run_ml
#'
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_all(otu_small, "regLogistic", TRUE, as.integer(5), 0.8, NA)
check_all <- function(dataset, method, permute, kfold, training_frac, seed) {
  check_method(method)
  check_dataset(dataset)
  check_permute(permute)
  check_kfold(kfold, dataset)
  check_training_frac(training_frac)
  check_seed(seed)
}

#' Check that the dataset is not empty and has more than 1 column.
#'
#' Errors if there are no rows or fewer than 2 columns.
#'
#' @inheritParams run_ml
#'
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_dataset(otu_small)
check_dataset <- function(dataset) {
  if (nrow(dataset) == 0) {
    stop("No rows detected in dataset.")
  }
  if (ncol(dataset) <= 1) {
    stop(
      "1 or fewer columns detected in dataset. There should be an outcome column and at least one feature column."
    )
  }
}

#' Check if the method is supported. If not, throws error.
#'
#' @inheritParams run_ml
#'
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_method("regLogistic")
check_method <- function(method) {
  methods <- c("regLogistic", "svmRadial", "rpart2", "rf", "xgbTree")
  if (!(method %in% methods)) {
    stop(paste0(
      "Method '",
      method,
      "' is not supported. Supported methods are:\n    ",
      paste(methods, collapse = ", ")
    ))
  }
}

#' Check that permute is a logical
#'
#' @inheritParams run_ml
#'
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' do_permute <- TRUE
#' check_permute(do_permute)
check_permute <- function(permute) {
  if (!is.logical(permute)) {
    stop(paste0(
      "`permute` must be TRUE or FALSE, but you provided a ",
      class(permute)
    ))
  }
}

#' Check that kfold is an integer of reasonable size
#'
#' @inheritParams run_ml
#'
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_kfold(5, otu_small)
check_kfold <- function(kfold, dataset) {
  not_a_number <- !is.integer(kfold) & !is.numeric(kfold)
  not_an_int <- kfold != as.integer(kfold)
  nfeats <- ncol(dataset) - 1
  out_of_range <- (kfold < 1) | (kfold > nfeats)
  if (not_a_number | not_an_int | out_of_range) {
    stop(paste0(
      "`kfold` must be an integer between 1 and the number of features in the data.\n",
      "  You provided ", kfold, " folds and your dataset has ", nfeats, " features."
    ))
  }
}

#' Check that the training fraction is between 0 and 1
#'
#' @param frac fraction (numeric)
#'
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_training_frac(0.8)
check_training_frac <- function(frac) {
  if (!is.numeric(frac) | (frac <= 0 | frac >= 1)) {
    stop(paste0(
      "`training_frac` must be a numeric between 0 and 1.\n",
      "    You provided: ", frac
    ))
  }
}

#' check that the seed is either NA or a number
#'
#' @param seed random seed
#'
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_seed(2019)
check_seed <- function(seed) {
  if (!is.na(seed) & !is.numeric(seed)) {
    stop(paste0(
      "`seed` must be `NA` or numeric.\n",
      "    You provided: ", seed
    ))
  }
}

#' Check that outcome column exists. Pick outcome column if not specified.
#'
#' @inheritParams run_ml
#'
#' @return outcome colname
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_outcome_column(otu_small, NA)
#' check_outcome_column(otu_small, "dx")
check_outcome_column <- function(dataset, outcome_colname) {
  # If no outcome colname specified, use first column in data
  if (is.na(outcome_colname)) {
    outcome_colname <- colnames(dataset)[1]
  } else {
    # check to see if outcome is in column names of data
    if (!outcome_colname %in% colnames(dataset)) {
      stop(paste0("Outcome '", outcome_colname, "' not in column names of data."))
    }
  }
  return(outcome_colname)
}

#' Check that the outcome variable is binary. Pick outcome value if necessary.
#'
#' @inheritParams run_ml
#' @inheritParams pick_outcome_value
#'
#' @return outcome value
#' @noRd
#' @author Kelly Sovacool, \email{sovacool@@umich.edu}
#'
#' @examples
#' check_outcome_value(otu_small, "dx", "cancer")
check_outcome_value <- function(dataset, outcome_colname, outcome_value, method = "fewer") {
  # check binary outcome
  outcomes <- unique(dataset[, outcome_colname])
  num_outcomes <- length(outcomes)
  if (num_outcomes != 2) {
    stop(
      paste0(
        "A binary outcome variable is required, but this dataset has ",
        num_outcomes,  " outcomes: ", paste(outcomes, collapse = ",")
      )
    )
  }
  # pick binary outcome value of interest if not provided by user
  if (is.na(outcome_value)) {
    outcome_value <-
      pick_outcome_value(dataset, outcome_colname, method = method)
  } else if (!any(dataset[, outcome_colname] == outcome_value)) {
    stop(
      paste0(
        "No rows in the outcome column (",
        outcome_colname,
        ") with the outcome of interest (",
        outcome_value,
        ") were detected."
      )
    )
  }
  message(
    paste0(
      "Using '",
      outcome_colname,
      "' as the outcome column and '",
      outcome_value,
      "' as the outcome value of interest."
    )
  )
  return(outcome_value)
}

#' Check whether package(s) are installed
#'
#' @param package_names names of packages (or a single package) to check
#' @return logical vector - whether packages are installed (TRUE) or not (FALSE).
#' @noRd
#' @author Zena Lapp, \email{zenalapp@@umich.edu}
#'
#' @examples
#' check_package_installed("base")
#' check_package_installed("asdf")
#' all(check_package_installed(c("parallel", "doParallel")))
check_package_installed <- function(package_names) {
  return(package_names %in% rownames(utils::installed.packages()))
}

check_features <- function(features) {
  if (!class(features)[1] %in% c("data.frame", "tbl_df")) {
    stop("Argument `features` must be a `data.frame` or `tibble`")
  }
}