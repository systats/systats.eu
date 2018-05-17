---
layout: post
title:  Predicting Political Affiliation from Text
---

<img src = "{{ site.baseurl }}/images/research/PolPredText.png" align = "center" width = "80%">

<!--more-->

The `useR!2017` conference in Brussels was very inspiring and also great to get an overview of trending technologies. For those who are interested, some friends and I gathered all conference materials, notes and videos in [this post](https://systats.github.io/user2017/). As a small coding challenge I developed a light weight shiny app, which takes a text input (two or more sentences recommended) and live predicts its probability to be associated with a German political party. The app default language is German and can be accessed by pressing the button below.

<a href="https://systats.shinyapps.io/manifestoR_word2vec/" target="_blank" class="shiny_app_PolTextPrediction">Shiny App #PolTextPrediction</a>

### Tips

If you tried some sentences you will probably recognize the bias in favor for the green party. The German greens have maybe the most diverse agenda which reaches from core values of ecological justice, to social justice and even public security concepts are proposed. Another reason for the bias is statistical modeling itself. If you add more and more text to the input window, the prediction accuracy will increase. For good results two or more sentences are recommended as the output probability is related to the amount of input information (text). If you don't get the desired result remember: *All models are wrong, some are useful* (George Box 1979). 

### Methods

Each time the app is accessed, the shiny server back-end imports some pre-trained statistical models which perform the prediction task. Training data was taken from [manifesto project](https://manifestoproject.wzb.eu/) (who have a really friendly `R` data API, [check it out!](https://github.com/ManifestoProject/manifestoR)). They collect electoral programs from different European countries over a wide time range and make it easily  accessible (of course open source). German electoral programs between 2002 and 2012 were used to train a word2vec model (continuous word embedding) and on top for classification a multi-class/multinomial regression. The final class probabilities (for each party) is presented in a bar plot. 

