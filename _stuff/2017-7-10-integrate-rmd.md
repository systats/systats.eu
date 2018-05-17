---
layout: post
title: Rmarkdown in jekyll github pages
---

As this blog is only a week old, I have to integrate some more Jekyll
features and debug some code. Thanks to Shirin Glander who wrote a very
comprehensive blog post on [how to integrate R + Github +
jekyll](https://shiring.github.io/blogging/2016/12/04/diy_your_own_blog),
I'm now able to bring reproducible research directly to the web.
<!--more--> Not surprisingly, the local site generator prevents from
pushing to Github too often.
[Here](http://rmarkdown.rstudio.com/markdown_document_format.html) are
some differnt md\_output formats.

1.  Check for name/ date consistency
2.  knit to md\_document

        ---
        ...
        title: "Rmarkdown in jekyll github pages"
        layout: post
        categories: rblogging
        tags: test ggplot2
        output:
          md_document:
            variant: markdown
          #html_document: null
        preserve_yaml: true
        ---

3.  Now put the corresponding name and YAML header into the new
    generated .md blog post.

        ---
        output:
          md_document:
            variant: markdown
          #html_document: null
        preserve_yaml: true
        ---

4.  copy the chunk output to the image folder and replace any image
    input by str+f the base.url path.

change all by including at the beginning.

``` {.bash}
    {{ site.baseurl }}/images/
```

to get:

``` {.bash}
    {{ site.baseurl }}/images/2017-7-10-new.md_files/figure-markdown_github/pressure-1.png
```

5.  ready to publish.

Local site generator
====================

[Installation](http://jekyllrb.com/docs/installation/)

``` {.bash}
bundle exec jekyll serve
```

``` {.bash}
git add *
git commit -m "name"
git push origin master
```
