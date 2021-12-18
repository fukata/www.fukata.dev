---
layout: post
title: Git Logを表示するJekyllプラグイン「jekyll-git-history」
date:  2020-12-07 11:57:00 +0900
tags: [Jekyll]
---

以前使用していたamdxにあった更新履歴をgit logから取得する機能が良かったのでjekyll用に同じような機能を実現するプラグインを作成しました。

[fukata/jekyll-git-history: Show git history of jekyll post](https://github.com/fukata/jekyll-git-history)

使い方は簡単で下記のようにレイアウトファイルに追記するだけです。

```
{% raw %}{% git_history %}{% endraw %}
```

現在対応しているのはgithubのリポジトリのみになります。

また、記事1つを何十回も更新することはほとんどないので表示数の制限などは実装していませんが更新頻度の高いドキュメントなどに使用する場合は表示制限を付けても良いかもしれません。