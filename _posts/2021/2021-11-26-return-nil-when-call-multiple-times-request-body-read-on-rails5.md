---
layout: post
title: Rails 5でrequest.body.readを複数回呼ぶとnilが返ってくる 
date:  2021-11-26 23:04:00 +0900
tags: [Rails]
---

## バージョン

- Rails: 5.2.4.6

## 結論

`Content-Type` が `json` （ `application/json` 等） ではない場合にこの現象が発生するようです。

`Content-Type` が `json` 以外でどうしても複数回呼びたい場合は `request.raw_post` を使用するとよさそうです。

次に説明しますが `Content-Type` が `json` に該当する場合であれば内部的に `request.raw_post` が呼ばれ、その中で `RAW_POST_DATA` という特殊なヘッダーに値が設定されて `request.body.read` が呼ばれた時もそのヘッダーから値が使用されるため複数回呼び出しても値が返ってくるようになっています。

## ソースコード

`request.body` と `request.raw_post`

[https://github.com/rails/rails/blob/v5.2.4.6/actionpack/lib/action_dispatch/http/request.rb#L311-L329](https://github.com/rails/rails/blob/v5.2.4.6/actionpack/lib/action_dispatch/http/request.rb#L311-L329)

`Content-Type` が `json` に該当する場合に `raw_post` が呼ばれる処理

[https://github.com/rails/rails/blob/v5.2.4.6/actionpack/lib/action_dispatch/http/parameters.rb#L106-L119](https://github.com/rails/rails/blob/v5.2.4.6/actionpack/lib/action_dispatch/http/parameters.rb#L106-L119)