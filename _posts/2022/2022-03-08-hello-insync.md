---
layout: post
title: Insyncを使ってDropboxからGoogle Driveに移行してみた 
date:  2022-03-08 09:00:00 +0900
tags: [Insync]
---

無くなったら困るデータはDropboxに入れていましたが容量が増えてきて無料で利用可能な枠では厳しくなってきました。

有料プランを契約しようと思ったのですが無料プランの次が2TBのプランで年額払をして1200円/月という感じでちょっと容量を足したいだけにしては高いなと感じていました。

候補としてはOneDriveに月額2ドルで200GBのプランがあったのでこれでいいかと思ったんですがLinux向けの公式のクライアントがなかったので一旦保留にしました。

OSSのものであれば下記のソフトウェアが良さそうでした。

[abraunegg/onedrive: #1 Free OneDrive Client for Linux](https://github.com/abraunegg/onedrive)

結果として既に100GBのプランを契約しているGoogle Driveが使えるInsyncというアプリを試すことにしました。

## Insync

[Insync - Google Drive, OneDrive, and Dropbox Syncing on Linux, Windows & Mac](https://www.insynchq.com?fp_ref=fukata)

Linuxにも対応している買い切りのソフトウェアになります。

DEVELOPER SYNCというプランで 59.99 USD のを買いました。 

Google Drive、One Drive、Dropboxをそれぞれマルチアカウントで利用できるそうです。

### Ignore Rules

.gitignore 形式で同期したくないファイルを指定出来るので開発系のファイルと相性が良いかもしれません。

## Insync を使ってみた感想

自宅のネットワークが問題なのか Linux だからなのか Google Drive が原因なのか、はたまたその組み合わせなのか不明ですが同期しているファイルが詰まってしまい同期が進まない事がたまにありました。

長い事テキトーにDropboxのファイルを管理していたのでこれを機に不要なファイルを削除してディレクトリ構成も整理したら現状は詰まることなく同期されています。

もう少し使ってみて様子を見たいと思います。
