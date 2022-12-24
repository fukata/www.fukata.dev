---
layout: post
title: PlaywrightをGoogle Cloud Runで動かす
date:  2022-12-24 00:00:00 +0900
tags: [Playwright,Google Cloud Run]
---

# Google Cloud Run

Cloud RunでHTTP APIを定義できるのは知っていましたがプレビューでジョブも定義できるようになったので使ってみました。

npm installだけでよい通常のライブラリであれば後述するDockerfileを定義する必要も無く、下記のサンプルのようにシンプルになります。

[クイックスタート: Cloud Run で Node.js ジョブをビルドして作成する  \|  Cloud Run のドキュメント  \|  Google Cloud](https://cloud.google.com/run/docs/quickstarts/jobs/build-create-nodejs?hl=ja)

# cloudbuild.yml

```angular2html
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: [ 'build', '-t', 'gcr.io/$PROJECT_ID/$IMAGE_NAME', '.' ]
images:
  - 'gcr.io/$PROJECT_ID/$IMAGE_NAME'
```

`$PROJECT_ID` `IMAGE_NAME` は各自の環境に合わせて変更してください。

# Dockerfile

```dockerfile
FROM node:16.19-bullseye-slim
ENV HOME="/home"
WORKDIR /app
COPY . .
RUN npm ci && npx playwright install --with-deps chromium
CMD npm run start
```

`ENV HOME="/home"` がないとCloud Runで実行した時にplaywrightが見つからず、エラーになっていました。
