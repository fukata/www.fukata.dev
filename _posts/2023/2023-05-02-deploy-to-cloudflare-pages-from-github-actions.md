---
layout: post
title: Jekyll を Github Actions でビルドして Cloudflare Pages にデプロイする 
date:  2023-05-02 00:00:00 +0900
tags: [Jekyll, Github Actions, Cloudflare Pages]
---

## .github/workflows/deploy.yml

ソースを見た方が早いと思うので読んでみてください。

```yaml
name: Deploy

on: [push]

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      deployments: write
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          # see https://github.com/actions/checkout/issues/520#issuecomment-1320838255
          fetch-depth: 2147483647

      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: .ruby-version
          bundler-cache: true

      - run: bundle exec jekyll build
        env:
          JEKYLL_ENV: production

      - name: Publish to Cloudflare Pages
        uses: cloudflare/pages-action@1
        with:
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          projectName: www-fukata-dev
          directory: ./_site
          gitHubToken: ${{ secrets.GITHUB_TOKEN }}
```

[www.fukata.dev/deploy.yml at master · fukata/www.fukata.dev · GitHub](https://github.com/fukata/www.fukata.dev/blob/master/.github/workflows/deploy.yml)

## Cloudflare Pages でのビルドを止めた理由

移行した理由はCloudflare Pages のビルドではRuby 3系が使えずEOLになっている2.7系までしか使えないためです。

[Build Image Update · cloudflare/pages-build-image · Discussion #1](https://github.com/cloudflare/pages-build-image/discussions/1)

一応、上記の記事で議論されていますがいつ頃対応されるのか分かりません。