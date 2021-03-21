---
layout: post
title: StarTech.comのKVMスイッチ「SV211HDUC」を導入した
date:  2021-03-21 16:11:00 +0900
tags: [KVM Switch]
---

## 導入しようと思ったきっかけ

普段、4Kモニタ1枚で作業しているので仕事が終わったらプライベート用のマシンを接続し直す必要がありそれが面倒に感じたのが導入しようと思ったきっかけです。

使っているマシンは下記の通りです。

- XPS13 9370: Ubuntu 20.04 LTS
- XPS13 9310: Windows10

## SV211HDUC

今回購入したのはStarTech.comの「SV211HDUC」になります。

[StarTech.com USB-Cパソコン対応2ポートKVMスイッチ 4K60Hz HDMI コンパクトUSB Type-Cパソコン切替器 USB-Cケーブル付属 バスパワー対応 MacBook/iPad Pro/ThinkPad/IdeaPad/EliteBook SV211HDUC](https://amzn.to/30ZhZfW)

### ケーブル1本で接続可能

通常のKVMスイッチだと各PCからHDMIとUSBケーブルの2本が必要なんですが私が今仕事用で使っているXPS13 9310にはUSB Type-Cが2ポートしかないのでKVMスイッチのために2ポート使ってしまうと電源確保ができません。

もしかしたらUSB Type-CからHDMIとUSBのアダプタ経由すれば使えたのかもしれませんが付かなかった時に悲しくなるのでUSB Type-Cケーブル1本で接続が可能な `SV211HDUC` にしました。

### 切替時の待ち時間

**5秒** ほどかかります。

それが長いと思うか短いと思うかは人それぞれですが個人的には頻繁に切り替えるわけではないと思うので今のところ許容範囲内です。

### USBハブ

本体にUSB 2.0が2ポート付いていますが下記の機器を取り付けたいので足りません。

- キーボード: HHKB Professional Type-S
- トラックボール: Kensington Expert Mouse Wireless Trackball
- マイク: Blue Microphones Yeti
- WEBカメラ: Logicool C270n

ただし、Kensington Expert Mouseに関してはHHKBのUSBポートを使用するのでとりあえず3つあれば十分です。

そこで下記のUSBハブを取り付けましたがこちらも問題なく使えているようです。

[iBUFFALO USB ハブ USB2.0 バスパワー 4ポート ブラック BSH4U25BK【Windows/Mac対応】](https://amzn.to/3tH8Ogt)

## Windows -> Linuxの切替がうまくいかない

Linux -> Windowsの切替は問題ありませんでしたが、Windows -> Linuxの切替がうまくいかずラップトップを一度開いてあげないと駄目でした。

これはLinuxのラップトップの蓋が閉じた時にサスペンドされるように鳴っていたのが原因でサスペンドしないように設定すれば問題なく切り替えられるようになりました。

設定方法はこちらから。

[【Ubuntu 20.04/18.04 LTS Server】ノートPCで蓋を閉じてもサスペンドを防止 - The modern stone age.](https://www.yokoweb.net/2018/05/11/ubuntu18-notepc-suspend-ignore/)

Windowsへの切替が上手くいかない人もその辺りの設定を見てみるとよいかもしれません。

## まとめ

ケーブル1本で接続出来るのはポート数の少ないラップトップを使っている身としては良かったです。

ただ、アダプタ＋HDMI、USB2本のケーブルが必要なKVMを導入した方がコストは抑えられるかもしれません。

`SV211HDUC` に関するレビューがあまり見つからなかったので今回記事にしました。