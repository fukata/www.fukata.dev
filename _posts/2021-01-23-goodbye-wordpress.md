---
layout: post
title: WordPressで作ったサイトをSimply Staticで静的サイトにしてGithub Pagesで公開する
date:  2021-01-23 16:44:00 +0900
tags: [WordPress]
---

## 現状

個人ブログ([blog.fukata.org](https://blog.fukata.org))をWordPressで運用しています。

wp-flickr-pressというプラグインを開発していた時もありましたがflickrの使い心地が改善されなくなったことやその当時1ヶ月程かけてインドネシア、マレーシア、タイを旅行しながら生活していた時があってその記録用に作った [traha.org](https://traha.org) に個人ブログ的なものを移しました。

その結果、WordPressが数年放置されました。

先ほど久々にWordPressの管理画面にログインしてみるとアップデートや警告がひどい事になっていました。

![久々にログインしたWordPressの管理画面](/assets/posts/2021-01-13/fba8a604cddebba690b6049ee8b38ff6.png)

放置しているだけのものにサーバー代を払いたくないというのもありますし、メンテナンスしたくないので何かしらの方法で静的サイトとして残しておけないかと思っています。

この記事を書いている最中はまだ具体的にどのような方法があるのか分かっていません。

## 移行方法の選定

WordPressを静的サイトに変換するプラグインとして主に下記のものが見つかりました。

- [WP2Static](https://wp2static.com/)
    - 最終更新日: 2021-01-21 (2021-01-23時点)
    - 継続的にメンテナンスが続いている。
    - 公式のサイトが少し心配になるくらい簡素。
    - URLをクロールしてHTMLを出力する。
    - WP-CLIにも対応している。
    - アドオンが比較的充実している。(今回はローカルに出力できればいいので不要)
- [Simply Static](https://wordpress.org/plugins/simply-static/)
    - 最終更新日: 2020-12 (2021-01-23時点)
    - 継続的にメンテナンスが続いている。
    - URLをクロールしてHTMLを出力する。
    - 管理画面上から追加・除外URLの設定ができる。
- [StaticPress](http://ja.staticpress.net/)
    - 最終更新日: 2016-05-27 (2021-01-23時点)
    - URLをクロールしてHTMLを出力する。
    - URLのリダイレクトやリライトが複雑ではない場合には有効？
    - 出力したHTMLをS3にホスティングする機能があるが今回は1回限りの移行なので不要。

最初は `WP2Static` を使おうと思い管理画面からプラグインを検索してみたところヒットしなかったのでまずは `Simply Static` を使ってみることにします。

## 各種バージョン

- Server: Ubuntu 16.04.4 LTS
- PHP: 7.1.12
- WordPress: 5.3.6
- Simply Static: 2.1.1
 
## 移行手順

- WPがあまりにも古いのでとりあえず最新版にアップデートする。 5.3.6 => 5.6
    - 管理画面上からのアップデートですんなり終わった。
- Simply Staticをインストール
    - 管理画面からプラグインの追加画面で `Simply Static` と検索すればヒットする。
- 不要なプラグインやウィジェットを削除する。
  - アーカイブ目的だと別に必要のないプラグインやウィジェットがあり邪魔だったので削除した。
- `Simply Static > Generate > Generate Static Files` を実行する。
    - 標準だとzip形式(デフォルト)かローカル出力のいずれかが選択できる。
- 完了。
![完了](/assets/posts/2021-01-13/43f2d7bf46865fd10d88e561504f2414.png)
- zipファイルをダウンロードして内容を確認する。
```bash
$unzip simply-static-1-1611362950.zip -d simply-static-1-1611362950
$cd simply-static-1-1611362950
$ls -la
total 240
drwxrwxr-x   9 fukata   4096  1月 23 12:11 ./
drwxr-xr-x   5 fukata   4096  1月 23 12:11 ../
drwxrwxr-x 912 fukata 118784  1月 23 12:11 archives/
drwxrwxr-x   3 fukata   4096  1月 23 12:11 comments/
drwxrwxr-x   2 fukata   4096  1月 23 12:11 feed/
-rw-rw-r--   1 fukata  71482  1月 23 00:50 index.html
drwxrwxr-x  47 fukata  12288  1月 23 12:11 page/
drwxrwxr-x   4 fukata   4096  1月 23 12:11 wp-content/
drwxrwxr-x   4 fukata   4096  1月 23 12:11 wp-includes/
drwxrwxr-x   3 fukata   4096  1月 23 12:11 wp-json/
$http-server .
```
- URLエンコードされたディレクトリ名をデコードする。これで日本語のタグでも正常にリンク先が表示されるようになる。
```bash
$for d in $(find archives/tag -maxdepth 1 -type d|grep '%'); do mv $d $(echo $d |nkf --url-input); done
$for d in $(find archives/tag -maxdepth 2 -type d|grep '%'); do mv $d $(echo $d |nkf --url-input); done
```
- `/archives/tag/外食/外食/index.html` のようになぜか一つ下にファイルが置かれていた。下記のスクリプトを実行して調整する。
```bash
# 1つ下に出力されたindex.htmlを上のディレクトリに移動
$for f in $(find archives/tag/*/*/ -name index.html |grep -v page); do mv $f $(echo $f |sed -e s@index.html@../@g); done
# 1つ下に出力されたfeedを上のディレクトリに移動
$for f in $(find archives/tag/*/*/feed/ -type d); do mv $f $f../../; done
# 空のディレクトリを削除
$find archives/tag -type d -empty|xargs rm -fr 
```

一通り動作確認したところ問題なさそうだったのでこれをどこかにアップロードします。

### アップロード先

ファイルの全体が大体250MB程度あります。

更新しやすいようにgithubにリポジトリを作成してpushしたら反映されるようにしたいと思います。

[https://github.com/fukata/blog.fukata.org](https://github.com/fukata/blog.fukata.org)

アップロード先はとりあえず、Github Pagesにしたいと思います。

昔は専用のブランチを作る必要がありましたが現在はmainブランチのまま公開することが出来るので非常に楽です。

## ハマった点

- 記事URLに末尾スラッシュが無い場合、HTMLとして保存される時の形式と合わずに無限ループが発生するようになっていました。
    - permalink設定から末尾にスラッシュを付与するようにしました。
- `/archives/tag/外食/外食/index.html` のようになぜか一つ下にファイルが置かれてしまう事がありました。
    - なぜこのような形になったのか分からなかったがシェルスクリプトで無理矢理調整することにしました。