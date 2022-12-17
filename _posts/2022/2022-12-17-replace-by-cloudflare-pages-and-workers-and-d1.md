---
layout: post
title: Cloudflare Pages + Workers + D1を使ってサイトをリプレイスしてみた
date:  2022-12-17 00:00:00 +0900
tags: [Serverless,Cloudflare Workers,Cloudflare Pages, Cloudflare D1]
---

前回、書いた下記のサイトを試しにD1を使ってリプレイスしてみました。

[Cloudflare Workers + AWS Lambda + SQLite3 でメディアサイトを作成する](/2022/10/22/serverless-media-site.html)

# 構成

{% mermaid %}
graph TD;
    Browser((Browser))-->Frontend[Frontend on Pages];
    Frontend-- Authenticated -->UserApi[UserApi on Workers];
    UserApi-->Database[(D1)];
    UserApi-->Storage[(R2)];
    UserApi-->Cache[(KV)];

    ExternalSystem[Cloud Run]-- Authenticated -->AdminApi[AdminApi on Workers];
    AdminApi-->Database[(D1)];
    AdminApi-->Storage[(R2)];
{% endmermaid %}

## フレームワーク

- Frontend
  - [Astro](https://astro.build/)
- Api(UserApi, AdminApi)
  - [Hono](https://honojs.dev/)
  - ORMなし

# D1を触ってみて

D1と通信（読み取り）するたびに300ms程度かかっている印象でした。

まだアルファ版なのでなんとも言えませんが今回触ってみた感想としては正式版が楽しみでしかありません。

## バックアップ

バックアップが自動で行われているのも嬉しいですがダウンロードするとsqlite3ファイルがそのまま落とせます。

なので落としたファイルを普通に手元で開くことが可能です。

## wrangler d1 execute で一部のクエリしか実行されない場合がある

`wrangler d1 execute` でsqlファイルを指定した時になぜか一部のクエリしか実行されないという現象があり、回避方法がよくわからなかったためデータ移行用のAPIを作成して対応しました。

他の方も報告されていたのでそのうち修正されるんじゃないかと思います。

# まとめ

D1の正式版が出たら小中規模程度のシステムだったらこれでいいんじゃないかと思わせてくれるくらいの印象でした。

また、Hono.jsも人気があるだけあって非常に使いやすかったです。