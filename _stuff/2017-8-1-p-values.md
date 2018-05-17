---
layout: post 
title: "Harmful P-Values?"
---

Staying up-to-date in statistics seems most important in times of computational power for a nickel and the facilitation of simulation studies. In this post I shortly want to summarize a statement issued by the *American Statistical Association* which is warning the rest of the world about the limitations of P values and their widespread misuse. <!--more--> The statistical association report stated:

> While the p-value can be a useful statistical measure, it is commonly misused and misinterpreted. [...] This has led to some scientific journals discouraging the use of p-values, and some scientists and statisticians recommending their abandonment.

Regarding the widespread misuse of p-values the ASA clarifies 

> A p-value, or statistical significance, does not measure the size of an effect or the importance of a result.

[The ASA's Statement on p-Values: Context, Process, and Purpose (2016)](http://amstat.tandfonline.com/doi/full/10.1080/00031305.2016.1154108?scroll=top&needAccess=true)

<br>

<img src="https://www.mememaker.net/static/images/memes/4496199.jpg" width="40%"> 
<img src="http://s2.quickmeme.com/img/b4/b4813bd566bcdc894285af73c657dec1eb3b56e118ab0d55db4f7bdbb1768a63.jpg
" width="40%"> 

<br>

The ASA concludes that researchers intentinally shape their data to get a lower p-value (p < 05). This is called cherry-picking, significance chasing, significance questing, selective inference,  *p-hacking* or stargazing. This leads to a spurious excess of statistically significant results in the published literature and should be vigorously avoided. As a result, the scientific process is biased and the published scientific literature is often unreliable. The paper [*The Search for Significance* by Krawczyk (2015)](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0127872) examines the distribution of p-values in experimental psychology literature, which have less restricted conventions (p < 0.15). As the histogramm below shows there is a systematic increase around 0.05 despite the wider error probability of 0.15.

<img src = "{{ site.baseurl }}/images/p-values.png" width = "60%" align="middle">

[Science News](https://www.sciencenews.org/blog/context/experts-issue-warning-problems-p-values) compares the scientific community's attachment to p-values to a drug addiction, fueled by the institutional rewards that accompany the publication process. In addition, the [Nature](http://www.nature.com/news/statisticians-issue-warning-over-misuse-of-p-values-1.19503) issued the unusual step taken by the ASA, of issuing principles to guide the use of p-values, which it says cannot determine whether a hypothesis is true or whether results are important. BAAMM! 

This is only one of the latest statistical tests that needed a revision. The point is to be skeptical about statistical tests and always make fun of narrow-mindedness: 

> Surely, God loves the 0.06 nearly as much as the 0.05. 

Rosnow, R.J. & Rosenthal, R. Statistical procedures and the justification of knowledge in psychological science. Am. Psychol. 44, 1276–1284 (1989) [Link](http://www.nature.com/neuro/journal/v14/n9/full/nn.2886.html).

<!-- > Good statistical practice, as an essential component of good scientific practice, emphasizes principles of good study design and conduct, a variety of numerical and graphical summaries of data, understanding of the phenomenon under study, interpretation of results in context, complete reporting and proper logical and quantitative understanding of what data summaries mean. No single index should substitute for scientific reasoning.

If you need a reason to change your analysis framework to Bayesian: 

1. **NO** p-values (oversimplified yes or no decisions can be very harmful to medical patients or sciences in general)
2. Bayesian statistics extracts always more information from the data (by not relying on  confidence intervals restricted by assumptions) but by calculating a posterior distribution for every parameter estimated. So you can see by visual exploration whether your Gibbs Sampler is converged and your credible interval ($89\%$) and your visual evaluation is much more precise than a confidence interval based on [1] asymptotic [2] normally distributed distributions from [3] an infinity applicable sample process. Otherwise your p-value is worthless $->$ good news for natural sciences. -->





