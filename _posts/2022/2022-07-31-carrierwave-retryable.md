---
layout: post
title: CarrierWaveでリトライを実装する
date:  2022-07-31 00:00:00 +0900
tags: [CarrierWave]
---

CarrierWave経由でS3にファイルをアップロードしているとたまにS3から503が返ることがあります。

呼び出し元でリトライ処理を行っても良いのですがリトライの範囲を間違うと大変なのと毎回呼び出し元でリトライを意識させるのも難しいと思いCarrierWave側でリトライするようにできないか試してみました。

# ソースコード

[fukata/study-carrierwave-retryable](https://github.com/fukata/study-carrierwave-retryable)

# 使い方

`CarrierWave::Storage::Fog` を継承して必要なメソッドでリトライさせるようにしました。

リトライの条件などはアプリケーションに合わせて変更した方が良いと思います。

```
class RetryableStorageFog < CarrierWave::Storage::Fog
  def store!(file)
    retryable(__method__) { super }
  end

  def cache!(new_file)
    retryable(__method__) { super }
  end

  def retrieve_from_cache!(identifier)
    retryable(__method__) { super }
  end

  def retrieve!(identifier)
    retryable(__method__) { super }
  end

  private
  def retryable(method_name)
    retryable_options = {
      tries: 5,
      sleep: lambda{|retries|
        retries += 1
        sleep_seconds = 2**retries
        Rails.logger.warn("[RetryableStorageFog##{method_name}] sleep=#{sleep_seconds}, retries=#{retries}")
        sleep_seconds
      },
      on: [StandardError],
    }
    Retryable.retryable(retryable_options) do |retries, e|
      if retries > 0
        Rails.logger.warn("[RetryableStorageFog##{method_name}] retries=#{retries}, e=#{e}")
      end
      yield
    end
  end
end
```

あとはUploaderに指定するだけです。

```
class ImageUploader < CarrierWave::Uploader::Base
  storage RetryableStorageFog
  cache_storage RetryableStorageFog
end
```

# fog-aws v3.19.0 以上の場合

fog-aws v3.19.0 からリトライに関するデフォルトのオプションが追加されたのでアプリ側で対応する必要はなさそうです。

{% twitter https://twitter.com/rajyan_k/status/1659211374927704067 %}
