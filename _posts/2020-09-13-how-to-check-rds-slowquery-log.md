---
layout: post
title: RDSのスロークエリの取得、確認方法
date:   2020-09-13 22:32:00 +0900
tags: [AWS]
---

# 突然スパイクするCPU使用率

今まで平穏に過ごしていたデータベースのCPU使用率が突然跳ね上がり出しました。

アカウントに紐づくデータが特別多いアカウントの活動が活発なことが起因しているようでした。

# スロークエリのダウンロード

とりあえずこんな感じのスクリプトを書いて直近のスロークエリを手元にダウンロード出来るようにしました。

```bash
#!/usr/bin/env bash

DB_INSTANCE_ID="RDSのインスタンスID"
AWS_PROFILE="AWSプロフィール"
aws rds --profile $AWS_PROFILE describe-db-log-files --db-instance-identifier $DB_INSTANCE_ID |jq -r .DescribeDBLogFiles[].LogFileName |grep slow > slowquery-list.txt
for log in $(cat slowquery-list.txt)
do
  echo $log
  aws rds --profile $AWS_PROFILE download-db-log-file-portion --db-instance-identifier $DB_INSTANCE_ID --log-file-name $log > $(echo $log | cut -d / -f 2)
done
```

# スロークエリの確認

個別のファイルを確認する際はこんな感じです。

```bash
cat mysql-slowquery.log.2020-09-11.13 |jq -rs .[].LogFileData |less
```

ざっと時間別のクエリ数を確認したい時のスクリプトはこんな感じです。

クエリ数の多い時間順に並べたい場合はwc -lの結果をsortコマンドに繋げても良いでしょう。

```bash
for f in $(ls mysql-slowquery.log.2020-09-11.*); do echo -n "$f ";  cat $f |jq -rs .[].LogFileData |grep 'User@Host' - |wc -l; done
```
