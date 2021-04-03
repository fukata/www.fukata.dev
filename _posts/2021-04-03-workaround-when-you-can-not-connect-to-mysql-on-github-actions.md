---
layout: post
title: Github Actions上でMySQLに接続できなくなったので bitnami/mysql を使用した
date:  2021-04-03 12:21:00 +0900
tags: [Github Actions]
---

表題の通りです。

かなり久しぶりにデプロイしようとしてGithub Actions上でビルドを走らせるとMySQLに繋がらないという現象が起きました。

[Announce/Feedback: MySQL will become shut down by default on Ubuntu images on 03/12/2020 · Issue #375 · actions/virtual-environments](https://github.com/actions/virtual-environments/issues/375)

というissueもありますがdocker imageでmysqlを起動させていたので関係ないという認識です。

手元ではMySQL 8.0系を使っていたのにGithub Actions上では5.7系を使っていたという歪な状態になっていたのでバージョンも揃えることにしました。

結果的にこのようになりました。

## 修正前

```
services:
  db:
    image: mysql:5.7
    env:
      MYSQL_ALLOW_EMPTY_PASSWORD: true
      MYSQL_DATABASE: 'dummy_test'
      MYSQL_USER: 'root'
```

## 修正後

本当は `mysql` 本家のイメージを使いたかったんですがauthentication_pluginの設定が上手く反映できなかったり、依然として上手く接続、その後のセットアップが通らなかったりとハマっていたので `bitnami/mysql` のイメージを使うことにしました。

とりあえずコレで正常に動作させることが出来るようになりました。

```
services:
  db:
    image: bitnami/mysql:8.0
    env:
      ALLOW_EMPTY_PASSWORD: yes
      MYSQL_DATABASE: dummy_test
      MYSQL_USER: 'root'
      MYSQL_AUTHENTICATION_PLUGIN: mysql_native_password
    ports:
      - 3306/tcp
    options: >-
      --health-cmd="mysqladmin ping"
      --health-interval=10s
      --health-timeout=5s
      --health-retries=
```