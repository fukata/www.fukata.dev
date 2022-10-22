---
layout: post
title: Cloudflare Workers + AWS Lambda + SQLite3 でメディアサイトを作成する
date:  2022-10-22 00:00:00 +0900
tags: [Serverless,Cloudflare Workers,AWS Lambda,SQLite3]
---

ユーザーから更新等が発生しないサイトをサーバーレスで作成したのでメモしておきます。

# 構成

{% mermaid %}
sequenceDiagram
    participant Browser 
    participant Workers as Cloudflare Workers
    participant Lambda as AWS Lambda
    participant S3

    Browser->>Workers: https://example.com
    Workers->>Lambda: 呼び出し（認証有）
    Lambda->>Lambda: データベース参照
    Lambda->>S3: コンテンツの取得
    S3->>Lambda: コンテンツ 
    Lambda->>Workers: レスポンス 
    Workers->>Workers: キャッシュ
    Workers->>Browser: レスポンス 
{% endmermaid %}

（jekyll-mermaidを導入してみたけど便利）

# AWS Lmabda 

`vendia/serverless-express` を使っています。

ローカルでも簡単に動かせて便利です。

[vendia/serverless-express: Run Node.js web applications and APIs using existing application frameworks on AWS #serverless technologies such as Lambda, API Gateway, Lambda@Edge, and ALB.](https://github.com/vendia/serverless-express)

AWS LambdaのエンドポイントをCNAMEなどに設定しようかと思ったんですがうまくいかないことが分かったのでプロキシとしてCloudflare Workersを利用することにしました。

# Cloudflare Workers

カスタムドメインを使っています。

## Cloudflare WorkersからAWS Lambdaの呼び出し

認証がなければテキトーに呼び出せば良いですが認証付きだと `mhart/aws4fetch` が依存関係が少なくて便利でした。

[mhart/aws4fetch: A compact AWS client for modern JS environments](https://github.com/mhart/aws4fetch)

## キャッシュ

毎回、AWS Lambda側にリクエストをする必要がないサイトだったのでできる限りWorkers側でキャッシュするようにしました。

やり方はドキュメントがありほぼそれの通りでした。

[Cache using fetch · Cloudflare Workers docs](https://developers.cloudflare.com/workers/examples/cache-using-fetch/)

# データベース 

SQLite3を使っています。

AWS LambdaにS3経由で更新しており、ユーザーから更新等がないサイトなのでデータベースファイルも一緒にアップしています。

# S3

コンテンツをすべてSQLite3に含めようとすると簡単にAWS Lambdaの150MB制限に引っかかる事がわかったので検索対象じゃないような大きめのコンテンツに関してはS3に置いてそれを取得するようにしています。

# デプロイ 

データの更新が必要になったら手元で更新してからデプロイという流れにしています。

現在は自宅サーバーから定期的にデプロイをしているのでgit repoにpushすればデプロイされるようになっています。

頻度や処理によっては手動やGithub ActionsなどCIで行っても良いと思います。

# SQLite3が便利

S3経由でAWS Lambdaにデプロイしており、S3にアップしたファイルはライフサイクルによって90日後に削除されるようにしています。

これがバックアップにもなります。

簡単なスクリプトを書くだけで任意のリリースを手元に落としてきて復元することも出来ます。DBとプログラムが一緒になっているのでこのあたりは非常に楽ですね。

# 体感速度

AWS Lambdaを使っている以上、一定時間アクセスがないと起動に時間がかかりレスポンスに多少時間がかかることがありますがこれは仕方ないと受け止めています。

適度にアクセスがあれば気にならない程度ですし、Cloudflare側に既にキャッシュされているURLであれば普通に速いです。

常に一定レベルのレスポンスタイムが要求されるような場合はAWS Lambda側で予め立ち上げておくオプションを使えば良いのかもしれませんが趣味開発なんで基本的には無料を狙っていきたいので使っていません。

# まとめ

デプロイも容易でスケールもするので簡単なメディアサイトくらいならこれで有りだなと思いました。
