---
layout: post
title: Google Photosの画像をランダムに壁紙に設定するWidnowsアプリをFlutterで作った
ate:  2022-03-27 23:00:00 +0900
tags: [Flutter]
---

![スクリーンショット](/assets/posts/2022/dbdb59f85f2124671cfb9467ff270f5f.png)

[fukata/wallpaper_changer: Wallpaper changer for Windows by Flutter](https://github.com/fukata/wallpaper_changer)

## Flutter

flutter 2.0からWindowsのサポートが安定版になったみたいですがホットリロードが効く環境での開発は心地良いものがあります。

クロスプラットフォームなので当然ですが基本的にはdartでのお作法を学べば Android/iOS/Windows/macOS/Linux でアプリが作れます（たぶん）。趣味アプリの開発用途としては十分ではないかと思います。

本来自分がやりたいことは少しでそれにGUIを取り付けたいだけなのにそのプラットフォーム固有のやり方を調べるのもモチベーション下がりますしそういうところを面倒見てくれるのは嬉しいです。

今回、壁紙を更新するのはwin32 APIを呼び出す事で対応しました。自分でPluginを書かないといけないかと思っていましたがwin32パッケージが既にあったのでそのAPIを呼び出すだけになりました。

## Dart

構文自体は特殊ではないので慣れるのは早かったです。

### テストコード

今回はテストコード書かなかったのでアプリの機能実装が落ち着いたらどんな感じで実装するのか試してみたいと思います。

## IDE

Android Studioにflutterプラグインを入れて使いました。

仕事でもJetBrains製のツールに移行したので同じショートカットが使えるのは嬉しい。

## Realm

クライアントサイドのデータベースとしてRealmを使ってみました。SQLiteが定番だと思いますが趣味アプリということで興味本位でRealmを使ってみましたが比較的使いやすいと感じました。

Realm Studioでデータベースの中を確認出来たりインポート・エクスポートが行えるのも便利そうだなと思いました。

ただ、Realm Dart SDKだと対応している型が少なかったりとその辺りで不便に感じることがあるかもしれません。具体的にはDateTime型への対応などがまだありませんでした。

## CI

[Codemagic - CI/CD for Android, iOS, Flutter and React Native projects](https://codemagic.io/)

公式のサイトでも紹介されていたcodemagicを使いました。

Windowsのインスタンスは有料のみらしく今回無駄にハマってビルドしまくったので6ドル程度かかりました。

### msix

msixパッケージのインストーラーを作成するのは下記のパッケージを使用すれば簡単にできます。

[msix \| Flutter Package](https://pub.dev/packages/msix)

ただし、codemagic上でmsixファイルを作成するのに手間取りました。

### 証明書のインストール

msixファイルの作成するコマンド実行後、pfxをインストールしますか？で止まってしまい先に進めないという問題がありました。

これは、`Pre-build script` に下記の内容を指定することで回避できました。開発用ということでpfxにはパスワードは設定していません。

```
Import-PfxCertificate -FilePath ./wallpaper_changer.pfx -CertStoreLocation Cert:\LocalMachine\Root
```

### APIキーなど

リポジトリにpushしておきたくない値などは.envファイルに書き出しておいてdotenvパッケージから取得するようにしました。

codemagicの環境変数に設定した値を `Post-clone script` として下記のような感じで.envに書き出すようにしました。

今回まともにPowerShellを使ったのでコマンドが正しいのかあまり自信がありません。 

```
New-Item -type file .env
Write-Output "HOGE_CLIENT_ID='$env:HOGE_CLIENT_ID'" | Add-Content .env -Encoding Default
Write-Output "HOGE_CLIENT_SECRET='$env:HOGE_CLIENT_SECRET'" | Add-Content .env -Encoding Default
```

## クラッシュログ

codemagic上で作成したmsixでインストールしたアプリだとなぜか動かない事がありクラッシュログの見方もよく分かっていなかったので原因特定にかなり時間とお金（codemagicへの課金）を使いました。

Sentryを一応入れましたが今回のケースだとSentryの初期化前にクラッシュしていたので結局1つ1つコメントアウトしていって範囲を特定するという泥臭いやり方になってしまいました。

原因から言うと.envの内容が空だったためにエラーになっていたというだけでしたのでmsixの問題ではありませんでした。

Sentry以外にもそれ以前で落ちた時に何かしらクラッシュログ等を表示する処理を追加する必要があるのかもしれません。それともこれは別の方法で確認出来たのでしょうか？

## Microsoft Storeへの公開 

作成したアプリをMicrosoft Storeに公開するためにはMicrosoft パートナーセンターからアプリを登録しないといけないようなのですが、MicrosoftパートナーセンターでCORBが発生していてアプリが登録できないためストアへの公開はそのうち試したいと思います。

## まとめ

3年くらい前にもflutterでAndroidアプリを作りかけた事がありましたがその時は特定のパッケージに機能が足りなくて実装を断念した記憶があります。（現在はその問題も解消されているようです）

それに比べると同様の問題もなく比較的順調に開発を進められてとりあえず自分が最低限欲しい機能を実装することが出来ました。

ちょっとしたGUIアプリを作るのには便利なのでこれからもちょいちょいflutterは触ろうかと思います。
