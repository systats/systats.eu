
# Web Development

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
