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

### 所有文章
<ul>
  {% for post in site.posts %}
    <li>
      <a href="/blog{{ post.url }}">{{ post.title }}</a> - {{ post.date | date_to_string }}
    </li>
  {% endfor %}
</ul>
