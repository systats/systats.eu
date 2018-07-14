
## Sentiment Neuron

**Sentiment Analysis** is a popular method in Natural Language Processing that measures the polarity of sentiments from text data. Over time different approaches have been proposed. The traditional dictionary-based approach doesn't account for the context of a given word. Newer methods define sentiment analysis as supervised machine learning task that requires a labeld training set. 

This application delivers different sentiment classifiers trained on 100.000 *Amazon Reviews*. The main interest is to understand which word sequences a sentiment classifier learns from any given contexts. As this is part of my thesis German reviews were prioritized but English versions will follow. The different neural network architectures and other parameter are summarized below the application. 

**How to?** Copy and paste any German text piece into the input field and press analyze. After processing and prediction you can change the color indicators. 

**Don't forget!** All statistical models are wrong, some are useful. So don't expect perfect results. Moreover the length of the input vector should not be less than 5 and more than 40 words.   

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

* Models (Keras):
    + **GloVe** stands for *Global Vectors for Word Representation*. It's a popular embedding method based on factorizing a matrix of word co-occurrence statistics.
    + **CNN** stands for Convolutional Neural Network that originated from computer vision that takes words as inputs instead of pixels.  
* N-grams: A bi-gram is the cooccurance of two words in a sequence. Respectively a uni-gram is a single word and a N-gram can have N words in a sequence. This value indicates the window size around a given word. Thereby the context will be dynamically considered during the sentiment prediction of a word. 
* Examples:
    + Seehofer
    + Merkel
