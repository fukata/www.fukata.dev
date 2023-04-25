---
layout: post
title: Google Authenticator から Last Pass Authenticator へ移行 
date:  2023-04-26 00:00:00 +0900
tags: [Authenticator]
---

# Google Authenticator

これまでAndroid版のGoogle Authenticatorを使っていましたが検索も並び替えもカテゴリ分けもGoogleアカウントと紐づけることもできなくさらにワンタイムパスワードが切り替わるタイミングにアプリが応答しなくなるというあまり出来の良いものではありませんでした。

そして今日、iOS版のGoogle Authenticatorには検索機能があることを知りました。

多分、Android版の方はそれほど力入れて開発していないんだろうと思い今後の機能改善もあまり見込めなさそうだったので移行することにしました。

# Last Pass Authenticator

長らくパスワード管理にLast Passを使っていてLast Pass Authenticatorも一部で利用していたのでついでなのでこちらにまとめるようにしました。

## 移行方法

Google Authenticatorにはエクスポート機能がありますが別の端末のGoogle Authenticatorでインポートする時に読み込むためのもので別のアプリに移行するためのものではありません。

そこで調べてみるとGoogle Authenticatorのデータを抜き出してくれるアプリがありました。

[scito/extract_otp_secrets: Extract one time password (OTP) secrets from QR codes exported by two-factor authentication (2FA) apps such as "Google Authenticator". The exported QR codes from authentication apps can be captured by camera, read from images, or read from text files. The secrets can be exported to JSON or CSV, or printed as QR codes to console.](https://github.com/scito/extract_otp_secrets)

Google Authenticatorを利用しているのとは別端末でiVCamを起動させてエクスポート用のQRコードを読み取ることでパソコン側にQRコードなど移行用のデータが表示されます。

後は表示されたQRコードをLast Pass Authenticatorで読み込むだけです。今回は60弱くらいしかなかったのでちまちまと手動で読み込みましたがもしかしたらこれらも自動化する方法があるのかもしれません。

めったに移行するものでもないのでとりあえず今回は手動で移行しました。

## まとめ

検索ができたりワンタイムパスワードが更新される際にアプリが固まることもないので非常に快適と言わざるを得ません。

また、カテゴリ分けできるのも便利で並び替えやお気に入り登録することでよく使うものは上部に表示することができ使いやすくなっています。

クラウド上にバックアップする機能も付いているので端末変更時の作業も楽になりそうです。
