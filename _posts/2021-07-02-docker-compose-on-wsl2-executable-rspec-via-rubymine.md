---
layout: post
title: docker-compose on WSL2でRubyMine経由でRSpecの実行が出来るようになった 
date:  2021-07-02 22:10:00 +0900
tags: [RubyMine]
---

少し前からメインのエディタをVSCodeからRubyMine（InteliJ IDEA）に変更しました。

Rubyを書く際には補完がよく効くので良い感じです。

また、仕事ではWSL2を使っていてその上でdocker-composeでプロジェクトを立ち上げていました。そのような環境だと今まではRubyMine経由でRSpecの実行がうまくいっていなかったんですが今日、Docker Desktopをv3.5.1にアップグレードしたのが良かったのか、docker compose v2 commandを有効化したのが良かったのかすんなり実行出来るようになっていました。

ただ、コンソール上で日本語が文字化けていたので `Help > Edit Custom VM Options` を開き、 `-Dfile.encoding=UTF-8` を追加しRubyMineを再起動することで文字化けも解消しました。

VSCodeから乗り換えて唯一不便な部分だったのでコレで開発効率が更に上がりそうです。