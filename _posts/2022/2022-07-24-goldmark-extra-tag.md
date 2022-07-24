---
layout: post
title: yuin/goldmark で独自タグを扱う
date:  2022-07-24 00:00:00 +0900
tags: [Go]
---

nuxt.jsの練習として [traha.org](https://traha.org) というサービスを作っていますがAPIサーバーを脱Railsしたいと思っているんですがmarkdownに独自タグを使用していてそれの対応がめんどくさそうで長いこと出来ていませんでした。

APIの方はどうにかなるだろうと思うのでまずはmarkdownの部分をどうやればできるのか検証してみることにしました。

# やりたいこと

```
[image id="${image_id}" caption="${caption}"]
```

のようなタグを下記のような形式で出力したいです。

```
<figure>
	<figcaption>${caption}</figcaption>
	<a href="${url}" target="_blank">
		<img src="${image_url}" alt="${image_caption}">
	</a>
</figure>
```

画像のURLなどはimage_idを元にアプリケーションのDBから参照する予定です。

# ソースコード

[yuin/goldmark](https://github.com/yuin/goldmark) を使ってみました。

とりあえずどうやれば独自タグを扱うことができるのか知りたかったので雑な部分が多いです。

[fukata/study-goldmark-extra-tag](https://github.com/fukata/study-goldmark-extra-tag)
