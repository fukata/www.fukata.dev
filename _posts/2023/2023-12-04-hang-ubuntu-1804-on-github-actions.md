---
layout: post
title: Github ActionsでUbuntu 18.04がハングする 
date:  2023-12-04 00:00:00 +0900
tags: [Github Actions, Ubuntu]
---

## 症状

ubuntu-18.04の指定したGithub Actionsのジョブがハングするようになっていました。

```shell
Requested labels: ubuntu-18.04
Job defined at: xxx/yyy/.github/workflows/zzz.yaml@refs/heads/master
Waiting for a runner to pick up this job...
```

最初は障害かなにかかと思っていて時間が経てば解決するだろうと思っていましたが10時間近く経過しても解決しませんでした。

## 原因

Xを検索すると、以下のようなIssueが見つかりました。

[The Ubuntu 18.04 Actions runner image will begin deprecation on 2022/08/08 and will be fully unsupported by 2023/04/03 · Issue #6002 · actions/runner-images](https://github.com/actions/runner-images/issues/6002)

どうやら2023年04月にサポートが切れたことが原因で動かなくなったようです。

## 対処

ubuntu-22.04 を指定して動くことを確認しました。

サポートが切れて動かなくなるのは構わないけどハングするのではなく、エラーにして欲しい。

普段はCircleCIを使うことが多いので気づくのが遅れました。