---
layout: post
title: Goodbye Digital Ocean, Hello Firebase
date:   2020-11-02 23:43:00 +0900
tags: [Firebase]
---

# Digital OceanからFirebaseに乗り換え

自分で運用しているとあるサービスをDigital OceanからFirebaseに乗り換えしました。

理由は特に重要でもないサービスに毎月数十ドルかかっているのが嫌だったからです。結局このサービスも2年近くダラダラと動いており数十ドル×24ヶ月以上と考えると非常に損した気持ちになります。

本日、11月02日が仕事が休みだったこともあり以前からちまちま進めていたリプレイスを一気に進めることにしました。

# 乗り換え先としてFirebaseを選択

元々、Rails + Sidekiq + Capybara + MySQLという構成でしたが、当面必要な機能はFunctionsで十分そうだったのでFunctions + Firestoreにして、言語もTypeScript + Puppeteerにしました。

以前は管理用のUIもありましたが特に重要ではなかったので削除しました。

# TypeScriptを選んだ理由

最近、仕事や趣味でRubyを使うことが多く、TypeScriptを多く触る機会が欲しかったというのが一番の理由です。

# Functions

APIはもちろん、定期実行も簡単に実装できるのは嬉しい。

さらにFirestoreへのアクセスも簡単なのでさくっとAPI生やしたり定期実行を行ってデータを永続化するのが非常に楽です。

# Firestore

特に深く考えずに実装すると read/write が多くなってしまい無料枠をあっさり超えそうだったので無駄な read/write が発生しないようにチューニングしました。

## readがやたらと多い

read/writeを改善したと思って定期的に確認していたら以前より悪化していることが分かりました。

ただ、コードをいくら見てもreadが増える原因となるような箇所が見つからなかったのでもしかしたらと思って探してみるとどうやらfirebaseコンソール上でfirestoreのデータを閲覧した時もreadが増えるらしいです。

[Google Cloud Firestore console reading of all documents and charges - Stack Overflow](https://stackoverflow.com/questions/54729505/google-cloud-firestore-console-reading-of-all-documents-and-charges)

# Puppeteer

capybaraから移ったということもありAPIの違いなどは最初は違和感がありましたが慣れれば特に不自由なことは今のところありません。

ただ、Functions上で動かしているからなのかタイムアウトが発生することがあったりmemory limitが発生してしまうことがあるのでこの辺は要調整です。
