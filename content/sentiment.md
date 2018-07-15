
## Sentiment Neuron

This is a demonstration of **Sentiment Analysis** which is a popular method in Natural Language Processing that measures the polarity of sentiments from text data. This app tells you whether it thinks the text you enter below expresses positive or negative sentiment.

<!---<iframe id = "myIframe" src="https://systats.shinyapps.io/shiny_sent/" style="border: none; width: 900px; height: 1000px"></iframe>--->
<br>

<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.16/iframeResizer.min.js"></script>
<style>
  iframe {
    min-width: 100%;
  }
</style>

<iframe id="myIframe" src="https://systats.shinyapps.io/shiny_sent/" scrolling="no" frameborder="no"></iframe>
<script>
  iFrameResize({
    heightCalculationMethod: 'taggedElement'
  });
</script>

## Appendix

The models for this app are trained on half of a million *Amazon Book/Movie/App Reviews*. The main interest is to understand which word sequences a sentiment classifier learns from any given contexts. As this is part of my thesis German reviews were prioritized but English versions will follow. The different neural network architectures and other parameters are summarized below the app. 

**How to?** Copy and paste any German piece of text into the input field and press **Predict**. After processing and prediction you can change the color indicators. 

**Don't forget:** All statistical models are wrong, some are useful. In this sense the results will be more accurate on text that is similar to original training data. If you get an odd result, it could be the words you've used are unrecognized. Try entering more words to improve accuracy.

* Models (Keras):
    + **GloVe** stands for *Global Vectors for Word Representation*. It's a popular embedding method based on factorizing a matrix of word co-occurrence statistics.
    + **CNN** stands for Convolutional Neural Network that originated from computer vision that takes words as inputs instead of pixels.  
* N-grams: A bi-gram is the cooccurance of two words in a sequence. Respectively a uni-gram is a single word and a N-gram can have N words in a sequence. This value indicates the window size around a given word. Thereby the context will be dynamically considered during the sentiment prediction of a word. Thereby we see which word sequences the model has learned. The classifier was originally trained on whole sequences up to 40 words. 
* Examples (the user text input should be empty):
    + Article about Angela **Merkel** is taken from [Cicero.](https://www.cicero.de/innenpolitik/angela-merkel-bundeskanzlerin-befragung-abgeordnete-untersuchungsausschuss-fluechtlinge-lindner-grosse-koalition)
    + Article about Horst **Seehofer** is taken from [Spiegel.](http://www.spiegel.de/politik/deutschland/horst-seehofer-ein-tragischer-fall-kommentar-a-1217881.html)
    + Article about Alexander **Gauland** is taken from [Cicero.](https://www.cicero.de/afd-rede-gauland-junge-alternative-holocaust)
    + Article about Joachim **Löw** is taken from [Spiegel.](https://www.cicero.de/afd-rede-gauland-junge-alternative-holocaust)
