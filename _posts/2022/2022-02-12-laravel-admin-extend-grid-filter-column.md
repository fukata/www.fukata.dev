---
layout: post
title: laravel-adminのGrid\Filterを拡張してSection毎に定義できるようにしてみた
date:  2022-02-12 21:44:00 +0900
tags: [Laravel, laravel-admin]
---

laravel-admin で作られた管理画面をいじる機会があり、そもそも可能なのか調べていた時のメモです。

非常に検索対象のカラムが多いテーブルの検索UIとして理想を言えば、下記のように検索したい項目、条件、値を動的に追加していけるUIが良かったのですがそれらを実現するライブラリが見つからなかったのでlaravel-adminのソースコードを追ってみました。

[![検索条件を動的に追加できるUI](/assets/posts/2022/fac7c6706816144c18b3917bd54306a9.png)](/assets/posts/2022/fac7c6706816144c18b3917bd54306a9.png){:target="_blank"}

すると、Grid、Grid\Filterでは検索項目のみGETパラメータで受け取った場合に検索条件として処理していたのでその辺りのハック、もちろんビュー側もいじればできないこともなさそうでしたが実装コストが高いように思えました。

また、laravel-adminのバージョンアップ等によって動かなくなる可能性も高いと思いました。

そこで、代替案として下記のような `詳細検索` みたいに基本項目以外はアコーディオンメニューのように開閉が出来ればいいのではと思いそちらの案でソースを追ってみるとレイアウトに関する部分の修正で対応できそうだということが分かりました。

[![代替案のUI](/assets/posts/2022/f7228dd6b1e2366103cd29935ffab3d6.png)](/assets/posts/2022/f7228dd6b1e2366103cd29935ffab3d6.png){:target="_blank"}

laravel-adminというかLaravelの流儀も特に理解していないのでソースコードが汚いとかあるかもしれませんがとりあえずこんな感じでいじればいけるようでした。

より詳細なものをGistに載せました。

[https://gist.github.com/fukata/1138ad62bdf84875dcea5c75e37150ae](https://gist.github.com/fukata/1138ad62bdf84875dcea5c75e37150ae)

同様の事をやるライブラリが既にあれば是非教えてください。