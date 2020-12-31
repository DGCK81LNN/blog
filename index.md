---
soulblog-footer-links: 
  - 
    href: 'https://www.mywiki.cn/dgck81lnn'
    text: '旧博客站'
  -
    href: 'https://dgck81lnn.blog.luogu.org'
    text: '洛谷网博客'
---

欢迎来到<strong style="color:#3ba">DGCK81LNN的博客！</strong>！

***（新增）*** [我的 Project 记录表](projects.html)

### 所有文章

{% for post in site.posts %}
*    [{{ post.title }}](/blog{{ post.url }}) - {{ post.date | date: "%Y-%m-%d" }}
{% endfor %}
