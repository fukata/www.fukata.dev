---
layout: post
title: Jekyllでページ一覧を返すjsonを作成する 
date:  2021-02-02 00:25:00 +0900
tags: [Jekyll]
---

Jekyllでページ一覧を返すjsonを生やしたかったので下記のようなものを作成してみました。

Liquidには配列を生成する方法は `split` をするしかないようなので表示対象として有効なページパスだけをまずカンマ区切りで文字列にして出力時に `split` するようにしています。

`pages.json` としてファイルを作成します。

```
{% raw %}
---
permalink: /pages.json
---

{%- assign output = "" -%}
{%- assign page_paths = site.pages | map: "path" -%}
{%- for path in page_paths -%}
  {%- assign my_page = site.pages | where: "path", path | first -%}
  {%- if my_page.title -%}
    {%- assign output = output | append: ',' | append: path -%}
  {%- endif -%}
{%- endfor -%}

{%- assign output_page_paths = output | split: ',' -%}
[
  {%- for path in output_page_paths -%}
    {%- assign my_page = site.pages | where: "path", path | first -%}
    {%- if my_page.title -%}
      {
        "title": "{{ my_page.title | escape }}",
        "url": "{{ my_page.url | relative_url }}"
      }
      {%- if forloop.last == false -%},{%- endif -%}
    {%- endif -%}
  {%- endfor -%}
]
{% endraw %}
```