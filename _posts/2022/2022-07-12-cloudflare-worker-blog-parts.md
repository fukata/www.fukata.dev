---
layout: post
title: Cloudflare Workersでブログパーツを作ってみた
date:  2022-07-12 00:00:00 +0900
tags: [Cloudflare Workers]
---

# ブログパーツ

はてなブログとかでよく見る、URLを指定したらサイト名、説明文、画像などを表示してくれるやつを作りました。

![ブログパーツ](/assets/posts/2022/677f8de902d5b9b6577c539f137cff0d.png)

# リポジトリ

[fukata/blog-parts-worker](https://github.com/fukata/blog-parts-worker)

# Cloudflare Workers

非常に開発体験が良くプロキシっ的なサービスを作るのに簡単で良いです。

今回は練習ということでKVも使ってみました。
