---
layout: post
title: tunnelto.devを使ってみる
date:  2021-03-12 17:51:00 +0900
tags: [tunnelto.dev]
---

[ngrok.com](https://ngrok.com) のサブドメインが使いたくて有料版を契約しようと久しぶりにログインしてみるとGithub OAuth経由でなぜかログインできず、どうしようかと調べていたら類似サービスの `tunnelto.dev` というのを見つけたのでコレを試してみたらこれでいいやんとなったのでメモします。

## tunnelto.dev

[tunnelto.dev](https://tunnelto.dev)

メールアドレス入力して送信したらログイン用URLが渡されるのでそれでさくっとサインイン出来てしまう手軽さ。

使い方も簡単で認証キーを設定したら `ngrok.com` と同じようにこんな感じで公開することが出来ます。

```
tunnelto --subdomain fukata 8080
```

`ngrok.com` と違い無料版でもサブドメインが使えるのが地味にありがたいです。

### オープンソース

CLI自体はオープンソースとして公開されているので気になる方は見てみても面白いかもしれないです。

Rust製のようです。

[agrinman/tunnelto: Expose your local web server to the internet with a public URL.](https://github.com/agrinman/tunnelto)
