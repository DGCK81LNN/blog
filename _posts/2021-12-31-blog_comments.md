---
tags: 编程 日常写代码
date: 2021-12-31T21:51:40+0800
---

# 给 Jekyll 博客添加评论区

近日我给这个博客添加了评论区。因为是使用 [Github Pages][pages] 和 [Jekyll][jekyll] 构建的静态网页博客，不方便实时地把评论添加到网站上。

给静态博客添加评论区的一个常见方法是使用 [Disqus][disqus]。这是一个博客评论平台，只需在自己的静态站上引用相应的脚本，就可以创建一个评论区。

[pages]: https://pages.github.com/
[jekyll]: https://jekyllcn.com/
[disqus]: https://disqus.com/


![在评论区上方还可以选择表情符号进行快速互动。]({% link assets/2021-12-31-disqus.jpg %})

不过，Disqus 在中国大陆无法访问，而其它类似的平台基本都没有免费订阅方案，所以我放弃了这个方法，使用了一种另类的办法。

我用问卷星创建了[一个表单][form]用来接收评论；在 Jekyll 博客中添加了一个 `comments` 数据文件，用来存储全站的所有评论：

[form]: https://www.wjx.top/vm/rljkHbJ.aspx

```yaml
- date: 2021-12-30T22:08:41+0800
  post_url: "/posts/210306_rouge_test"
  nickname: "DGCK81LNN"
  email: "triluolnn@163.com"
  homepage: "https://github.com/DGCK81LNN"
  content: |
    这是一条测试评论
  reply: |
    这是一条测试回复
```

一旦有人评论（不会真的有吧😅），我就手动把评论写进数据文件中。

我还写了[一个 Liquid 扩展][myfilters]来显示 Gravatar 头像，因为需要对用户的邮箱地址生成 MD5 哈希。虽然 Gravatar 在国内一样无法访问，不过可以用 loli.net 镜像站。

[myfilters]: https://github.com/DGCK81LNN/blog/blob/24fa2788508f7b938ae7db03f2c96d65520a0371/_plugins/myfilters.rb

    https://gravatar.loli.net/avatar/b57408c9ef25d27a791ba9b871aa03f9

![使用这个网址应该就可以正常显示出我的头像。](https://gravatar.loli.net/avatar/b57408c9ef25d27a791ba9b871aa03f9
)

这个扩展里还有一个 Liquid 过滤器，可以把邮箱地址中的一些字符改成英文单词（如：triluolnn at 163 dot com）。

然后，在布局模板里添加了评论区的代码。值得注意的是，通过判断 `page.collection` 的值，可以只在博文中显示评论区：（Jekyll 文档的“变量”一页上好像没提这个变量）

{% raw %}
```liquid
{%- if page.collection == "posts" %}
```
{% endraw %}

[这篇博文][rougetest]下有一条测试评论，可以看到评论的显示效果，我自己觉得比较满意。

[rougetest]: {% link _posts/2021-03-06-rouge_test.md %}
