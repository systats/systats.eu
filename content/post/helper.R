### Check 

# check_df <- function(default, input){
#   input <- as.list(input)
#   cols <- names(default) %in% names(input)
#   dat <- c(input, default[!cols])
#   return(dat)
# }
# p1 <- list(
#   split = .1,
#   ups = 5
# ) 
# 
# p2 <- tibble(
#   split = .7,
#   ups = 1
# ) 
# 
# list(
#   mi = 1,
#   mu = 2
# ) %>% 
#   check_list(p1) 


# check_df <- function(default, input){
#   cols <- names(default) %in% names(input)
#   dat <- cbind(input, default[!cols])
#   return(dat)
# }

check_list <- function(default, input){
  cols <- names(default) %in% names(input)
  dat <- c(input, default[!cols])
  return(dat)
}

### Split Function 
tx_split <- function(data, params){
  
  params <- list(
    split = .7
  ) %>% 
  check_list(params)
  
  train_id  <- caret::createDataPartition(y = data$index, p = params$split, list = F)
  train <- data[train_id,]
  test  <- data[-train_id,]
  
  return(list(data = list(train = train, test = test), params = params))
}

### seq tokenizer
tx_to_seq <- function(container, text){
  
  params <- list(
    max_features = 2000, 
    batch_size = 40, 
    maxlen = 30
  ) %>% 
    check_list(container$params)
  
  tokenizer <- keras::text_tokenizer(num_words = params$max_features)
  keras::fit_text_tokenizer(tokenizer, x = container$data$train[[text]])
  
  train_seq <- tokenizer %>% 
    keras::texts_to_sequences(container$data$train[[text]]) %>% 
    keras::pad_sequences(maxlen = params$maxlen, value = 0)
  
  test_seq <- tokenizer %>% 
    keras::texts_to_sequences(container$data$test[[text]]) %>% 
    keras::pad_sequences(maxlen = params$maxlen, value = 0)  
  
  data <- c(container$data, list(train_seq = train_seq, test_seq = test_seq))

  return(list(data = data, params = params))
} 

### compile Keras graph
tx_compile_keras <- function(container){
  
  params <- list(
    max_features = 2000, 
    output_dim = 128, 
    maxlen = 30, 
    activation = "softmax", 
    loss = "binary_crossentropy", 
    optimizer = "adam"
  ) %>% 
    check_list(container$params)
  
  model <- keras::keras_model_sequential() %>%
    keras::layer_embedding(
      input_dim = params$max_features, 
      output_dim = params$output_dim, 
      input_length = params$maxlen
    ) %>%
    keras::layer_global_average_pooling_1d() %>%
    keras::layer_dense(5, activation = params$activation) %>%
    keras::compile(
      loss = params$loss,
      optimizer = params$optimizer,
      metrics = "accuracy"
    )
  return(list(model = model, params = params, data = container$data))
}


### Fitting
tx_keras_predict <- function (model, seq, index = 1){
  preds <- keras::predict_classes(model, x = seq) + index %>% as.vector()
  return(preds)
}

tx_learn <- function(container, target){
  
  params <- list(
    batch_size = 32,
    epochs = 2, 
    val_split = .2
  ) %>% 
    check_list(container$params)
  
  history <- container$model %>% 
    keras::fit(
      x = container$data$train_seq, 
      y = tidyTX::tx_onehot(container$data$train[[target]]),
      batch_size = params$batch_size,
      epochs = params$epochs, 
      validation_split = params$val_split
    )
  
  preds <- container$model %>%
    #keras::predict_classes(model, x = seq) + 1 %>%
    tx_keras_predict(container$data$test_seq, 1) %>% 
    as.vector()
  
  confusion <- caret::confusionMatrix(preds, container$data$test[[target]])
  perform = list(history = history$metrics, confusion = confusion)
  
  return(list(perform = perform, params = params))
}


# names(perform$test)
# perform$test$overall
# perform$test$byClass
#%>% as.data.frame()
fit_keras <- function(max_features, maxlen, batch_size, output_dim){
  
  params <- list(
    max_features = max_features,
    maxlen = maxlen,
    batch_size = batch_size,
    output_dim = output_dim
  ) %>% map (~round(.x,0))
  
  out <- dt %>% 
    mutate(index = 1:n()) %>%
    tx_split(params) %>%
    tx_to_seq("text_lemma") %>% 
    tx_compile_keras() %>%
    tx_learn(target = "party_id")
  
  return(list(Score = out$perform$confusion$overall[["Accuracy"]], Pred = out$perform))
}

bayes_fits_keras <- function(grid, n_iter){
  
  bounds <- grid %>%
    purrr::map(~{
      c(min(.x), max(.x))
    })
  
  init_grid <- 
    list(
      grid %>%
        purrr::map(~sample(.x, 1)),
      grid %>%
        purrr::map(~sample(.x, 1))
    ) %>% 
    purrr::reduce(dplyr::bind_rows)
  
  ba_search <- bayesian_optimization(
    FUN = fit_keras, # fun to be maximized
    bounds = bounds, # parameter boundaries
    init_grid_dt = init_grid, # inital grid points n>2
    init_points = 0, 
    n_iter = n_iter,
    acq = "ei", 
    kappa = 1, 
    eps = 0.0,
    verbose = T
  )
  return(ba_search)
}


bayesian_optimization <- function(FUN, bounds, init_grid_dt = NULL, init_points = 0, n_iter, acq = "ucb", kappa = 2.576, eps = 0.0, kernel = list(type = "exponential", power = 2), verbose = TRUE, ...) {
  # Preparation
  ## DT_bounds
  DT_bounds <- data.table(
    Parameter = names(bounds), 
    Lower = bounds %>% map_dbl(~.x[1]),
    Upper = bounds %>% map_dbl(~.x[2]), 
    Type = bounds %>% map_chr(class)
  )
  
  setDT(init_grid_dt)
  if (nrow(init_grid_dt) != 0) {
    if (identical(names(init_grid_dt), DT_bounds[, Parameter]) == TRUE) {
      init_grid_dt[, `:=`(Value, -Inf)]
    }
    else if (identical(names(init_grid_dt), c(DT_bounds[, 
                                                        Parameter], "Value")) == TRUE) {
      paste(nrow(init_grid_dt), "points in hyperparameter space were pre-sampled\n", 
            sep = " ") %>% cat(.)
    }
    else {
      stop("bounds and init_grid_dt should be compatible")
    }
  }
  ## init_points_dt
  init_points_dt <- Matrix_runif(
    n = init_points, 
    lower = DT_bounds[, Lower], 
    upper = DT_bounds[, Upper]
  ) %>%
    data.table(.) %T>%
    setnames(
      ., old = names(.), 
      new = DT_bounds[, Parameter]
    ) %T>% {
      if (any(DT_bounds[, Type] == "integer")) {
        set(.,
            j = DT_bounds[Type == "integer", Parameter],
            value = round(extract(., j = DT_bounds[Type == "integer", Parameter], with = F)))
      } else {
        .
      }
    } %T>%
    extract(., j = Value:=-Inf)
  
  ## iter_points_dt
  iter_points_dt <- data.table(
    matrix(-Inf, nrow = n_iter, ncol = nrow(DT_bounds) + 1)
  ) %>%
    setnames(., old = names(.), new = c(DT_bounds[, Parameter], "Value"))
  
  ## DT_history
  DT_history <- rbind(
    init_grid_dt, 
    init_points_dt, 
    iter_points_dt
  ) %>%
    cbind(data.table(Round = 1:nrow(.)), .)
  
  ## Pred_list
  Pred_list <- vector(mode = "list", length = nrow(DT_history))
  
  # Initialization
  for (i in 1:(nrow(init_grid_dt) + nrow(init_points_dt))) {
    if (is.infinite(DT_history[i, Value]) == TRUE) {
      This_Par <- DT_history[i, DT_bounds[, Parameter], with = FALSE]
    } else {
      next
    }
    # Function Evaluation
    This_Log <- utils::capture.output({
      This_Time <- system.time({
        This_Score_Pred <- do.call(what = FUN, args = as.list(This_Par))
      })
    })
    # Saving History and Prediction
    data.table::set(DT_history,
                    i = as.integer(i),
                    j = "Value",
                    value = as.list(c(This_Score_Pred$Score)))
    Pred_list[[i]] <- This_Score_Pred$Pred
    # Printing History
    if (verbose == TRUE) {
      paste(c("elapsed", names(DT_history)),
            c(format(This_Time["elapsed"], trim = FALSE, digits = 0, nsmall = 2),
              format(DT_history[i, "Round", with = FALSE], trim = FALSE, digits = 0, nsmall = 0),
              format(DT_history[i, -"Round", with = FALSE], trim = FALSE, digits = 0, nsmall = 4)),
            sep = " = ", collapse = "\t") %>%
        cat(., "\n")
    }
  }
  # Optimization
  for (j in (nrow(init_grid_dt) + nrow(init_points_dt) + 1):nrow(DT_history)) {
    if (nrow(iter_points_dt) == 0) {
      next
    }
    # Fitting Gaussian Process
    Par_Mat <- Min_Max_Scale_Mat(as.matrix(DT_history[1:(j - 1), DT_bounds[, Parameter], with = FALSE]),
                                 lower = DT_bounds[, Lower],
                                 upper = DT_bounds[, Upper])
    Rounds_Unique <- setdiff(1:(j - 1), which(duplicated(Par_Mat) == TRUE))
    Value_Vec <- DT_history[1:(j - 1), Value]
    GP_Log <- utils::capture.output({
      GP <- GPfit::GP_fit(X = Par_Mat[Rounds_Unique, ],
                          Y = Value_Vec[Rounds_Unique],
                          corr = kernel, ...)
    })
    # Minimizing Negative Utility Function
    Next_Par <- Utility_Max(DT_bounds, GP, acq = acq, y_max = max(DT_history[, Value]), kappa = kappa, eps = eps) %>%
      Min_Max_Inverse_Scale_Vec(., lower = DT_bounds[, Lower], upper = DT_bounds[, Upper]) %>%
      magrittr::set_names(., DT_bounds[, Parameter]) %>%
      inset(., DT_bounds[Type == "integer", Parameter], round(extract(., DT_bounds[Type == "integer", Parameter])))
    # Function Evaluation
    Next_Log <- utils::capture.output({
      Next_Time <- system.time({
        Next_Score_Pred <- do.call(what = FUN, args = as.list(Next_Par))
      })
    })
    # Saving History and Prediction
    data.table::set(DT_history,
                    i = as.integer(j),
                    j = c(DT_bounds[, Parameter], "Value"),
                    value = as.list(c(Next_Par, Value = Next_Score_Pred$Score)))
    Pred_list[[j]] <- Next_Score_Pred$Pred
    # Printing History
    if (verbose == TRUE) {
      paste(c("elapsed", names(DT_history)),
            c(format(Next_Time["elapsed"], trim = FALSE, digits = 0, nsmall = 2),
              format(DT_history[j, "Round", with = FALSE], trim = FALSE, digits = 0, nsmall = 0),
              format(DT_history[j, -"Round", with = FALSE], trim = FALSE, digits = 0, nsmall = 4)), sep = " = ", collapse = "\t") %>%
        cat(., "\n")
    }
  }
  # Computing Result
  Best_Par <- as.numeric(DT_history[which.max(Value), DT_bounds[, Parameter], with = FALSE]) %>%
    magrittr::set_names(., DT_bounds[, Parameter])
  Best_Value <- max(DT_history[, Value], na.rm = TRUE)
  #Pred_DT <- data.table::as.data.table(Pred_list)
  Result <- list(Best_Par = Best_Par,
                 Best_Value = Best_Value,
                 History = DT_history,
                 Pred = Pred_list)
  # Printing Best
  cat("\n Best Parameters Found: \n")
  paste(names(DT_history),
        c(format(DT_history[which.max(Value), "Round", with = FALSE], trim = FALSE, digits = 0, nsmall = 0),
          format(DT_history[which.max(Value), -"Round", with = FALSE], trim = FALSE, digits = 0, nsmall = 4)),
        sep = " = ", collapse = "\t") %>%
    cat(., "\n")
  # Return
  return(Result)
}



tidy_grid <- function(grid){
  history <- grid$History %>%
    dplyr::mutate(
      conf = grid$Pred %>% purrr::map(~ .x$conf$table)
    ) %>% 
    dplyr::rename(round = Round, metric = Value) %>%
    dplyr::arrange(desc(metric))
  return(history)
}

