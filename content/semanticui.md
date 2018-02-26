---
title: Semantic UI
---


* [code-mentor](https://www.codementor.io/)
* [blogdown for websites](https://bookdown.org/yihui/blogdown/)
* [dashboard examples](https://speckyboy.com/beautifully-designed-admin-dashboards/)
* https://www.nounou-top.fr/
* [learn semantic ui](http://learnsemantic.com/preface/introduction.html)


## Other Stuff


{{< tweet 852205086956818432 >}}


**XMin** is the first Hugo theme I have designed. The original reason that I wrote it was I needed a minimal example of Hugo themes when I was writing the  [**blogdown**](https://github.com/rstudio/blogdown) book. 

# Custom layouts

There are two layout files under `layouts/partials/` that you may want to override: `head_custom.html` and `foot_custom.html`. This is how you inject arbitrary HTML code to the head and foot areas. For example, this site has a file `layouts/partials/foot_custom.html` to support LaTeX math via MathJax and center images automatically:

```html
<script src="//yihui.name/js/math-code.js"></script>
<script async src="//cdn.bootcss.com/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML">
</script>
<script async src="//yihui.name/js/center-img.js"></script>
```

# Other features

I could have added more features to this theme, but I decided not to, since I have no intention to make this theme feature-rich. However, I will teach you how. I have prepared several examples via pull requests at https://github.com/yihui/hugo-xmin/pulls, so that you can see the implementations of these features when you check out the diffs in the pull requests. For example, you can:

- [Enable Google Analytics](https://github.com/yihui/hugo-xmin/pull/3)

- [Enable Disqus comments](https://github.com/yihui/hugo-xmin/pull/4)

- [Enable highlight.js for syntax highlighting of code blocks](https://github.com/yihui/hugo-xmin/pull/5)

- [Display categories and tags on a page](https://github.com/yihui/hugo-xmin/pull/2)

- [Add a table of contents](https://github.com/yihui/hugo-xmin/pull/7)

- [Add a link in the footer of each page to "Edit this page" on Github](https://github.com/yihui/hugo-xmin/pull/6)

To fully understand these examples, you have to read [the section on Hugo templates](https://bookdown.org/yihui/blogdown/templates.html) in the **blogdown** book.



## Examples of Semantic UI Homepages


<div class="ui three column grid">
  <div class="column">
    <a href="https://moneytracker.cc/" target="_blank">
      <img class = "ui large image" src="/images/moneytracker.png">
    </a>
  </div>
  <div class="column">
    <a href="https://www.mistay.in/" target="_blank">
      <img class = "ui large image" src="/images/mistay.png">
    </a>
  </div>
  <div class="column">
    <a href="https://www.clubom.com.br/" target="_blank">
      <img class = "ui large image" src="/images/clubom.png">
   </a>
  </div>
<!--- second image line --->
  <div class="column">
    <a href="https://edabit.com/" target="_blank">
      <img class = "ui large image" src="/images/edabit.png">
    </a>
  </div>
  <div class="column">
    <a href="https://www.seeuletter.com/" target="_blank">
      <img class = "ui large image" src="/images/seeuletter.png">
    </a>
  </div>
  <div class="column">
    <a href="https://www.blackship.com/" target="_blank">
      <img class = "ui large image" src="/images/blackship.png">
   </a>
  </div>
</div>
<div class="ui three column grid">
  <div class="column">
    <a href="https://roadmap.space/" target="_blank">
      <img class = "ui large image" src="/images/roadmap.png">
    </a>
  </div>
</div>







