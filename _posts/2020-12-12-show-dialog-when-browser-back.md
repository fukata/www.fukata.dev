---
layout: post
title: ブラウザバックを検知して離脱防止用ダイアログを表示する 
date:  2020-12-12 21:38:00 +0900
tags: [JS]
---

利用者としてはあると煩わしいですけど必要だったので実装する方法を調べたのでメモしておきます。

```js
const handler = (event) => {
  alert("ほんとに戻りますか？");
}

if (window.history && window.history.pushState) {
  const path = window.location.pathname;
  window.history.pushState(path, null, null);
  window.addEventListener('popstate', handler);
}
```