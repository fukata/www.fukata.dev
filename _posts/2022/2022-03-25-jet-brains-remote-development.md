---
layout: post
title: Remote Development with JetBrains Gatewayが快適
date:  2022-03-25 00:00:00 +0900
tags: [JetBrains]
---

ただそれだけの内容です。

メインマシンを先日購入したDELL G15 5521にしたわけですがまだ開発環境は以前のメインマシンだったXPS 13 9370のままです。

ただ、モニタは1台しかなく入力切替も仕事用の別のマシンと利用しているためXPS 13のために用意できるモニタ、キーボード等がないという状況です。

仕方なくXPS 13の小さな画面で開発していたんですがすっかりWFHのおかげで4Kディスプレイなしでの開発が苦痛になってしまいました。

何か良い方法はないものかと探しているとふとPhpStormの起動画面にSSH Remoteというのが目に写りそれを試してみたらめちゃくちゃ便利でした。

## Remote Development with JetBrains Gateway

どうやら裏では JetBrains Gateway というのが立ち上がっておりそちらが良い感じにリモートマシンと通信してくれてホストマシンの方でもPhpStormを使った開発ができています。

[Getting started with remote development \| IntelliJ IDEA](https://www.jetbrains.com/help/idea/remote-development-a.html)

PhpStorm内でTerminalを開けばリモートマシンにSSHで繋がった状態になっています。

こうなってくるとホストマシンは使い慣れたOSを使ってリモートマシンにLinuxなどを使ってに快適開発ができるそうです。

まだbeta版のようですが比較的快適に動作しています。
