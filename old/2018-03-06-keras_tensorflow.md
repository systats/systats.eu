Text Classification in R
================
2018-03-06

    ---
    title: Text Classification in R
    date: '2018-03-06'
    categories: 
        - R
        - ML
    tags: 
        - keras
        - TensorFlow
        - H2O
        - text2vec
    description: This post is an Rmarkdown example for using highcharter in blogdown post.
    ---

-   <https://www.datacamp.com/community/tutorials/keras-r-deep-learning>

Load Packages
-------------

``` r
#pacman::p_load_gh("rstudio/keras")
#pacman::p_load_gh("systats/tidyTX", install = T)
#devtools::install_github("systats/tidyTX")
pacman::p_load(dplyr, stringr, manifestoR, purrr, keras, tidyr, tidytext, tidyTX, keras, ggplot2, viridis, ggthemes)
# keras::install_keras()
```

Load data by `manifestoR`
-------------------------

``` r
mkey <- "c1d709849c34e15130f9052699c214af"
mp_setapikey(key = mkey)

# edate = Day, month, and year of national election
df <- mp_corpus(
    countryname == "Germany" &
    edate > as.Date("2002-01-01")
  ) %>%
  tidy()
```

``` r
glimpse(df)
```

    ## Observations: 28
    ## Variables: 17
    ## $ manifesto_id                <chr> "41113_200209", "41113_200509", "4...
    ## $ party                       <dbl> 41113, 41113, 41113, 41113, 41113,...
    ## $ date                        <dbl> 200209, 200509, 200909, 201309, 20...
    ## $ language                    <chr> "german", "german", "german", "ger...
    ## $ source                      <chr> "MARPOR", "MARPOR", "MARPOR", "MAR...
    ## $ has_eu_code                 <lgl> FALSE, TRUE, TRUE, FALSE, FALSE, F...
    ## $ is_primary_doc              <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE...
    ## $ may_contradict_core_dataset <lgl> FALSE, FALSE, FALSE, FALSE, FALSE,...
    ## $ md5sum_text                 <chr> "41e90a16558cc94ea37f96c36cc92498"...
    ## $ url_original                <chr> "/down/originals/2015-1/41113_2002...
    ## $ md5sum_original             <chr> "CURRENTLY_UNAVAILABLE", "CURRENTL...
    ## $ annotations                 <lgl> TRUE, TRUE, TRUE, TRUE, TRUE, TRUE...
    ## $ handbook                    <chr> "3", "2", "2", "4", "5", "3", "2",...
    ## $ is_copy_of                  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA...
    ## $ title                       <chr> "Grün wirkt! Unser Wahlprogramm 20...
    ## $ id                          <chr> "41113_200209", "41113_200509", "4...
    ## $ text                        <chr> "Grün wirkt!\nUnser Wahlprogramm\n...

clean text data
---------------

-   [Regular Expressions as used in R](https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html)

``` r
party_dict <- list(
"greens"= c("Green Party", "1", "41113", "#46962b"),
"left" = c("The Left", "2", "41223", "#8B1A1A"),
"spd" = c("SPD", "3", "41320", "#E2001A"),
"fdp" = c("FDP", "4", "41420", "#ffed00"),
"union" = c("CDU/CSU", "5",  "41521", "black")
#"41953" = c("AfD", "6", "afd", "#1C86EE")
)

party_abbrev <- names(party_dict)
party_name <- map_chr(party_dict, function(x) x[1])
party_index <- map_chr(party_dict, function(x) x[2])
party_id <- map_chr(party_dict, function(x) x[3])
party_cols <- map_chr(party_dict, function(x) x[4])


df$party_names <- tx_map_dict(df$party, party_dict, key1 = 3, key2 = 1)
df$party_id <- tx_map_dict(df$party, party_dict, key1 = 3, key2 = 2)
```

``` r
maxlen <- 30

sp_de <-read.table("data/german_stopwords_cust.txt", skip = 9, stringsAsFactors = F) %>%
  rename(words = V1)

df_clean <- df %>%
  #sample_n(size = 1000) %>%
  select(party_id, date, id, text) %>%
  mutate(text = text %>%
    tx_replace_punc() %>%
    #str_replace_all("[[:digit:]]|[[:punct:]]", " ") %>%
    tidyTX::tx_spacing()
  ) %>% 
  # unnest_tokens(unit, text, token = "sentences") %>%
  unnest_tokens(words, text, token = "words") %>%
  ### build batches from one-token-per-row df
  group_by(party_id) %>%
  # generate splitting id (seq)
  dplyr::mutate(seq = seq_along(words) %/% maxlen) %>%
  #ungroup() %>%
  group_by(party_id, seq) %>%
  summarise(text = paste(words, collapse = " ")) %>%
  ungroup() %>%
  ### exclude AfD 6 due to less data
  mutate(party_id = party_id %>% as.numeric) %>% 
  filter(party_id %in% 1:5) %>%
  ### kick statments shorter than 5 words
  mutate(nwords = tx_n_tokens(text)) %>%
  filter(nwords > 5) %>%
  ### Downsample green party statments
  group_by(party_id) %>%
  sample_n(size = 4000) %>%
  ungroup() %>% 
  ### give a reliabel
  mutate(id = 1:n()) %>%
  tx_discard_tokens(text = "text", dict = sp_de, purrr = T) %>%
  ### randomize order of statments from parties
  arrange(sample(1:length(id), length(id)))

print(object.size(df_clean), standard = "SI", units = "MB")
```

    ## 10.8 MB

``` r
df_clean
```

    ## # A tibble: 20,000 x 6
    ##    party_id   seq text                    nwords    id ctext              
    ##       <dbl> <dbl> <chr>                    <int> <int> <chr>              
    ##  1       5. 2894. wollen auch in zukunft…     29 17316 wollen zukunft bei…
    ##  2       1. 2074. und es ist zynisch die…     30  1567 zynisch form ausbe…
    ##  3       2. 3451. einkauf im internet um…     29  6077 einkauf internet z…
    ##  4       5.  781. deutschland weil ihre …     29 19208 deutschland regier…
    ##  5       4. 1216. die liberale einkommen…     29 14361 liberale einkommen…
    ##  6       3. 2444. brauchen einen neuen i…     29  9891 brauchen neuen imp…
    ##  7       1. 6385. auch europäisch zu rea…     29  2787 europäisch reagier…
    ##  8       2. 2638. per volksentscheid vor…     29  5742 volksentscheid vor…
    ##  9       5.  379. und vertrauen zu siche…     29 17309 vertrauen sichern …
    ## 10       4.   10. wichtigsten zukunftsre…     29 15715 wichtigsten zukunf…
    ## # ... with 19,990 more rows

Train & Test Set
----------------

``` r
set.seed(2018)
df_clean$split_id <- sample(1:2, size = nrow(df_clean), replace = T, prob=c(.9, .1))
train <- df_clean %>% filter(split_id %in% 1)
test <- df_clean %>% filter(split_id == 2)
```

Keras
=====

Text Preprocessing
------------------

``` r
### vocabluary size
library(ggplot2)
train %>%
  unnest_tokens(words, ctext) %>%
  select(words) %>%
  group_by(words) %>%
  tally %>%
  ggplot(aes(n)) +
  geom_histogram() +
  xlim(0, 100) 
```

![](2018-03-06-keras_tensorflow_files/figure-markdown_github/vocab-1.png)

``` r
max_features <- 20000 # top most common words
batch_size <- 32
#maxlen <- 20 # Cut texts after this number of words (called earlier)

#tokenizer <- text_tokenizer(num_words = max_features)
#fit_text_tokenizer(tokenizer, x = train$ctext)
#keras::save_text_tokenizer(tokenizer, "data/tokenizer")
tokenizer <- keras::load_text_tokenizer("data/tokenizer")

train_seq <- tx_text_to_seq(
  token_fun = tokenizer,
  string = train$ctext,
  maxlen = maxlen
)

test_seq <- tx_text_to_seq(
  token_fun = tokenizer,
  string = test$ctext,
  maxlen = maxlen
)
```

fasttext Model
--------------

``` r
glove_fit <- keras_model_sequential() %>%
  layer_embedding(
    input_dim = max_features, 
    output_dim = 128, 
    input_length = maxlen
    ) %>%
  layer_global_average_pooling_1d() %>%
  layer_dense(5, activation = "sigmoid") %>%
  compile(
    loss = "binary_crossentropy",
    optimizer = "adam",
    metrics = "accuracy"
  )

summary(glove_fit)
```

    ## ___________________________________________________________________________
    ## Layer (type)                     Output Shape                  Param #     
    ## ===========================================================================
    ## embedding_1 (Embedding)          (None, 30, 128)               2560000     
    ## ___________________________________________________________________________
    ## global_average_pooling1d_1 (Glob (None, 128)                   0           
    ## ___________________________________________________________________________
    ## dense_1 (Dense)                  (None, 5)                     645         
    ## ===========================================================================
    ## Total params: 2,560,645
    ## Trainable params: 2,560,645
    ## Non-trainable params: 0
    ## ___________________________________________________________________________

``` r
glove_hist <- glove_fit %>% 
  keras::fit(
    x = train_seq, 
    y = tx_onehot(train$party_id),
    batch_size = batch_size,
    epochs = 5, 
    validation_split = .2
  )
```

``` r
#plot(glove_hist)
preds_glove <- glove_fit %>%
  tx_keras_predict(test_seq, 1) %>% 
  as.vector()

caret::confusionMatrix(preds_glove, test$party_id)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction   1   2   3   4   5
    ##          1 232  25  48  33  29
    ##          2  45 346  49  16  10
    ##          3  31  15 202  21  22
    ##          4  35  13  23 292  34
    ##          5  49  11  60  47 318
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.6929          
    ##                  95% CI : (0.6722, 0.7131)
    ##     No Information Rate : 0.2059          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.6157          
    ##  Mcnemar's Test P-Value : 8.225e-08       
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 4 Class: 5
    ## Sensitivity            0.5918   0.8439   0.5288   0.7139   0.7700
    ## Specificity            0.9164   0.9248   0.9452   0.9343   0.8952
    ## Pos Pred Value         0.6322   0.7425   0.6942   0.7355   0.6557
    ## Neg Pred Value         0.9024   0.9584   0.8950   0.9273   0.9375
    ## Prevalence             0.1954   0.2044   0.1904   0.2039   0.2059
    ## Detection Rate         0.1157   0.1725   0.1007   0.1456   0.1585
    ## Detection Prevalence   0.1830   0.2323   0.1451   0.1979   0.2418
    ## Balanced Accuracy      0.7541   0.8844   0.7370   0.8241   0.8326

``` r
tx_confusion(x = preds_glove, y = test$party_id, lib = "gg")
```

![](2018-03-06-keras_tensorflow_files/figure-markdown_github/pred1-1.png)

LSTM model
----------

``` r
lstm_fit <- keras_model_sequential() %>%
  ### model arch
  layer_embedding(
    input_dim = max_features, 
    output_dim = 128, 
    input_length = maxlen
  ) %>% 
  layer_lstm(units = 64, dropout = 0.3, recurrent_dropout = 0.1) %>% 
  layer_dense(units = 5, activation = 'sigmoid') %>%
  ### compiler
  compile(
    loss = 'binary_crossentropy',
    optimizer = 'adam',
    metrics = c('accuracy')
  )

summary(lstm_fit)
```

    ## ___________________________________________________________________________
    ## Layer (type)                     Output Shape                  Param #     
    ## ===========================================================================
    ## embedding_2 (Embedding)          (None, 30, 128)               2560000     
    ## ___________________________________________________________________________
    ## lstm_1 (LSTM)                    (None, 64)                    49408       
    ## ___________________________________________________________________________
    ## dense_2 (Dense)                  (None, 5)                     325         
    ## ===========================================================================
    ## Total params: 2,609,733
    ## Trainable params: 2,609,733
    ## Non-trainable params: 0
    ## ___________________________________________________________________________

``` r
lstm_hist <- lstm_fit %>% 
  keras::fit(
    x = train_seq, 
    y = tx_onehot(train$party_id),
    batch_size = batch_size,
    epochs = 3,
    validation_split = .2
  )
```

``` r
# tx_keras_plot(lstm_hist)
preds_lstm <- lstm_fit %>% 
  tx_keras_predict(test_seq, 1)

nn <- tibble(preds_lstm, test$party_id) %>%
  mutate(real = preds_lstm == test$party_id)
prop.table(table(nn$real))
```

    ## 
    ##     FALSE      TRUE 
    ## 0.2701894 0.7298106

``` r
#dm[[3]] %>% hist

caret::confusionMatrix(preds_lstm, test$party_id)
```

    ## Confusion Matrix and Statistics
    ## 
    ##           Reference
    ## Prediction   1   2   3   4   5
    ##          1 213  15  31  17  10
    ##          2  39 357  28  14   8
    ##          3  58  22 256  34  43
    ##          4  48  13  18 310  24
    ##          5  34   3  49  34 328
    ## 
    ## Overall Statistics
    ##                                           
    ##                Accuracy : 0.7298          
    ##                  95% CI : (0.7098, 0.7491)
    ##     No Information Rate : 0.2059          
    ##     P-Value [Acc > NIR] : < 2.2e-16       
    ##                                           
    ##                   Kappa : 0.6621          
    ##  Mcnemar's Test P-Value : 1.452e-08       
    ## 
    ## Statistics by Class:
    ## 
    ##                      Class: 1 Class: 2 Class: 3 Class: 4 Class: 5
    ## Sensitivity            0.5434   0.8707   0.6702   0.7579   0.7942
    ## Specificity            0.9548   0.9442   0.9033   0.9355   0.9247
    ## Pos Pred Value         0.7448   0.8004   0.6199   0.7506   0.7321
    ## Neg Pred Value         0.8959   0.9660   0.9209   0.9379   0.9454
    ## Prevalence             0.1954   0.2044   0.1904   0.2039   0.2059
    ## Detection Rate         0.1062   0.1780   0.1276   0.1545   0.1635
    ## Detection Prevalence   0.1426   0.2223   0.2059   0.2059   0.2233
    ## Balanced Accuracy      0.7491   0.9075   0.7867   0.8467   0.8594

``` r
tx_confusion(x = preds_lstm, y = test$party_id, lib = "gg", info = F)
```

![](2018-03-06-keras_tensorflow_files/figure-markdown_github/fit2-1.png)
