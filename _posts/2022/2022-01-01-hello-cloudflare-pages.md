---
layout: post
title: Cloudflare Pagesへ引っ越し
date:  2022-01-01 00:35:00 +0900
tags: [Cloudflare]
---

あけましておめでとうございます。

Netlify で運用しているこのブログの表示速度が [Cloudflare Pages](https://pages.cloudflare.com/) で運用した場合に比べて遅い事が分かったので引っ越しました。

## 表示速度は改善

これが移行の理由なので当然といえば当然ですが体感で分かるくらい速くなっておりレイテンシ的にも2倍程速くなっているようです。

## Cloudflare Workersがちょっと面白そう

年末年始の休みにドキュメントを読んでいて面白そうだったので何か試しに作ってみたいなと思ったのもCloudflareに引っ越したした理由の1つです。

[Cloudflare Workers documentation · Cloudflare Workers docs](https://developers.cloudflare.com/workers/)

## Ruby 3.0が使えない

ビルド自体は問題なくできましたが Cloudflare Pages だとRuby 3.0がまだ使えないようでした。

その原因が ruby 3.0 向けの tar.bz2 が無い事が原因のようで Ruby 2.8 から tar.bz2 のファイルを作らないようにするというissueがあったので今後Cloudflare Pages側で何かしら対応がされるのではないかと思います。

[Misc #16483: How about stopping new *.tar.bz2 releases? - Ruby master - Ruby Issue Tracking System](https://bugs.ruby-lang.org/issues/16483)

## ビルド時間が遅い

Netlify と比べると少しビルドに時間がかかるようになった気がします。キャッシュがうまく使えていないのかRubyのインストールに時間がかかっているのかは詳細は見ていません。

大体、2分くらいかかっていたのが5分程度になりました。

## Slack 連携機能がない

Netlify の頃にあったSlack連携機能が無いみたいなので自分でなんとかするしかないのかもしれません。個人利用でどうしても必要な機能というわけではないので気が向いたら対応してみようかと思います。
