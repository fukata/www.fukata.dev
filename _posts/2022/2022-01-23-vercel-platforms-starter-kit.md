---
layout: post
title: VercelのPlatforms Starter Kitを触ってみた
date:  2022-01-23 19:06:00 +0900
tags: [Vercel]
---

[How to Build a Multi-Tenant App with Custom Domains Using Next.js – Vercel Docs](https://vercel.com/guides/nextjs-multi-tenant-application)

コレを触ってみました。

次の個人開発の構成はコレでいこうと思いました。

## Prisma、PlanetScale

普段 Rails を触っている身としては node.js だけだとDB回りがめんどくさいなと感じていました。
そんな中、今回初めて `Prisma` を使ってみましたが `PlatnetScale` とも相まって使い勝手が良くコレなら趣味開発でも使ってみようと思えました。

`PlanetScale` もbranchという機能があって機能開発する時に少しスキーマ変えてみたいという時に便利そうでした。

## NextAuth.js

```shell
npx create-next-app --example https://github.com/vercel/platforms/tree/main study-vercel-platforms
```

2021-01-23時点、上記のコマンドで作成したアプリだとGoogleでOAuthした時に `id_token` の長さがスキーマより長くエラーになっていましたが `Text` 型に変更することで正常に動作しました。

Google,Twitter,Github等普段利用することが多いプロバイダに対応しているので個人開発では困らさなさそうでした。

また、試しては居ないですが独自にOAuthプロバイダを追加するのも簡単そうだったので対応は難しくないと思います。

## Next.js

REST APIを定義する時にファイルをどのような構成にしようか悩みます。

スターターキットだと `/api/create-post.js` のようになっており呼び出すURLも `/api/create-post` となっており、HTTP METHODによる振り分け等は行っていませんでした。

探せば Next.js で REST API を簡単に定義できるライブラリがあるかもしれませんが Next.js のルーティング機能をそのまま使うとちょっとファイルの構成がすこし考える必要がありそうだなと感じました。

## まとめ

DBを使用した個人開発もサーバーレスで気軽に行える環境があるのはすごく嬉しいです。

## 追記（2021-01-23 23:06）

[Remix](https://remix.run/docs/en/v1) も良さそう。。。