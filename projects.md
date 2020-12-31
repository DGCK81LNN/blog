---
title: Project 记录表
---

{% for namespace in site.data.projects %}
## `{{ namespace.id }}` - {{ namespace.desc }} {% if namespace.url %}<{{ namespace.url }}>{% endif %}
{% for project in namespace.projs %}
*   `{{ project.id }}` - {{ project.desc }} {% if project.url %}<{{ project.url }}>{% endif %}
{% assign status = "not_started" -%}
{%- assign phase = 1 -%}
{%- assign progress = 0 -%}
{%- for news in project.news reversed -%}
    {%- if news.status -%}
        {%- assign status = news.status -%}
    {%- endif -%}
    {%- if news.phase -%}
        {%- assign phase = news.phase -%}
    {%- endif -%}
    {%- if news.progress -%}
        {%- assign progress = news.progress -%}
    {%- endif -%}
{%- endfor %}
    **当前状态：** `{{ status }}`
{% if phase != 1 %}
    第 {{ phase }} 期工程
{%- endif %}
{%- if progress != 0 %}
    **当前进度：** {{ progress }}
{% endif %}

{% if project.news %}
    NEWS:

{% for news in project.news %}
    -   {{ news.date | default: "（未知日期）" }}

{% if news.status %}
        **状态：** `{{ news.status }}`
{% endif %}

{% if news.phase %}
        进入 {{ news.phase }} 期工程
{% endif %}

{% if news.progress %}
        **进度：** {{ news.progress }}
{% endif %}

{% if news.content %}
        {{ news.content | replace: "\n", "\n        " }}
{% endif %}

{% endfor %}
{% endif %}

{% endfor %}
{% endfor %}
