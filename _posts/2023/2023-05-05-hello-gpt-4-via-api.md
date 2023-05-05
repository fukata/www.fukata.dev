---
layout: post
title: やっとAPI経由でGPT-4モデルが利用できるようになったので試してみた 
date:  2023-05-05 00:00:00 +0900
tags: [ChatGPT]
---

## GPT-4がやっと来た！

ずいぶん前にwaitlistに申し込んでいましたがやっと使える状態になりました。

![Yout GPT-4 API invite is here](/assets/posts/2023/Screenshot_20230505_200121.png)

## モデルの違いによる応答速度

以前作ったチャットプログラムにgpt-4を適用して応答速度がどんな感じか確認してみました。

今回、ついでにstreamモードにも対応したのでより速度差が分かりやすくなりました。

### gpt-4 

<video src="https://gyazo.com/42586fc0aa76d3e2bc03a7821ecff556.mp4" autoplay="false" controls="true"></video>

### gpt-3.5-turbo 

<video src="https://gyazo.com/d07e12161b735f93f81ec3f300c13641.mp4" autoplay="false" controls="true"></video>

## ソースコード

試したのは下記のソースコードです。いずれも同じソースコードで環境変数を変更するだけで利用できます。

[openai-sample/chat.js at main · fukata/openai-sample · GitHub](https://github.com/fukata/openai-sample/blob/main/src/chat.js)

## 入力としての画像

GPT-4では特定のアカウントでは入力として画像が使えるようですがコレも早く試してみたいところです。
