---
layout: post
title: elasticsearch-rubyでPITを使って1万件以上取得する 
date:  2021-02-12 23:32:00 +0900
tags: [Elasticsearch]
---

## バージョン

- Elasticsearch: 7.10.1

## 1万件の制限

Elasticsearchのデフォルトでは通常の `search` で取得可能なドキュメントは1万件でそれ以上はPIT (Point In Time)を使って取得する必要があります。

Scroll APIというのもあるようですがこちらは現在非推奨になっているのでPITとsearch_afterパラメータを使って取得するのが良いようです。

[Point in time API - Elasticsearch Reference [7.11] - Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/point-in-time-api.html)

ちなみに1万件の制限については `index.max_result_window` で変更できます。

[Index modules - Elasticsearch Reference [7.11] - Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/index-modules.html)

## サンプル

`Gemfile`
```ruby
gem 'elasticsearch', '~> 7'
gem 'elasticsearch-xpack', '~> 7'
```

`main.rb`
```ruby
#!/usr/bin/env ruby
Bundler.require

client = Elasticsearch::Client.new(
  url: 'http://127.0.0.1:9200',
  log: true,
)

pit_id = nil
search_after = nil
begin
  # スナップショットを作成（1分間だけ保持する）
  response = client.xpack.open_point_in_time(index: 'items', keep_alive: '1m')
  puts JSON.pretty_generate(response)
  pit_id = response['id']

  # 一度に取得する件数
  size = 10000
  while true
    search_opts = {
      body: {
        size: size,
        query: {
          match: {
            'user_id': 123,
          }
        },
        pit: {
          id: pit_id,
          keep_alive: '1m', # スナップショットを1分間延長する
        },
        sort: [
          { 'title': 'desc' },
          { 'id': 'desc' },
        ],
      },
    }
    search_opts[:body][:search_after] = search_after if search_after
    response = client.search(search_opts)

    # 各リクエスト毎にIDが変化する可能性があるので最新のIDを設定する
    pit_id = response['pit_id']

    # 次に読み込む位置を設定
    search_after = response['hits']['hits'].last['sort']
   
    # 取得できた件数がsizeより少ないなら最後まで読み込んだ
    fetched_num = response['hits']['hits'].size
    if fetched_num < size
      puts "全て読み込みました。"
      break
    end
  end
ensure
  # スナップショットを削除
  if pit_id
    response = client.xpack.close_point_in_time(body: JSON.generate({id: pit_id}))
    puts JSON.pretty_generate(response)
  end
end
```

## まとめ

`elasticsearch-ruby` で `X-Pack` の使い方が分かりにくかったですがライブラリの実装を読むことで理解できました。

[elastic/elasticsearch-ruby: Ruby integrations for Elasticsearch](https://github.com/elastic/elasticsearch-ruby)