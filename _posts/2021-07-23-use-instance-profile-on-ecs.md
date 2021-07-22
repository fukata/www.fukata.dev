---
layout: post
title: ECSからインスタンスプロファイルを使用する 
date:  2021-07-23 09:00:00 +0900
tags: [AWS]
---

ECS上からElasticsearchに接続する必要がありデプロイしたら急に接続できなくなりました。

今までEC2上からは問題なく繋がっていたので最初はポリシーの設定がミスったのかと思っていましたがよくよく調べてみるとEC2とECS上とでインスタンスプロファイルを使用する際に使用するクラスが違う事が分かりました。

最終的に下記のように環境変数の有無で分ける事で回避しました。

```ruby
Elasticsearch::Model.client = Elasticsearch::Client.new(config) do |f|
  credentials_provider = if ENV["AWS_CONTAINER_CREDENTIALS_RELATIVE_URI"]
                           Aws::ECSCredentials.new
                         else
                           Aws::InstanceProfileCredentials.new
                         end
  f.request(
    :aws_sigv4,
    service: 'es',
    region: ENV['AWS_REGION'],
    credentials_provider: credentials_provider,
  )
end
```

AWS SDKをそのまま使う場合には内部で同様に環境変数で分岐してくれているみたいですが Credential Provider を直接指定するようなケースだと今回のように自分で分岐してあげるしかないんでしょうかね。

最初、 `Aws::InstanceProfileCredentials` がクラス名からもEC2上で使用するものというのを知らなくてかなり時間を無駄にしたのでまた同じような事をやる時にハマると思ったのでメモしておきます。