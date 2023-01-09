---
layout: post
title: Vue.jsでSpeedDialを実装してみた 
date:  2023-01-09 00:00:00 +0900
tags: [Vue.js]
---

初めてcssのアニメーションを書いた気がします。

# 動作

gifに変換したらかなりもっさりしてしまいました。

次のgist内にあるgyazoのリンクから見てもらえばなめらかなのは確認できるかと思います。

![動作イメージ](/assets/posts/2023/7841c4bf62f5bae324cc4fe71b71555a.gif)

# コード

Vuetifyを使っていればfloating action buttonが用意されているのでそれを使うだけだったんですけど今回は使えなかったのとよさげなライブラリが見つからなかったので最低限の機能を実装してみました。

[SpeedDial.vue - gist](https://gist.github.com/fukata/e61563b887dc2f5bfee6b31c07c20b7f)