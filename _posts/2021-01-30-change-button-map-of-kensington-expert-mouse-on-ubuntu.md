---
layout: post
title: LinuxでKensington Expert Mouseのボタン配置を変更する 
date:  2021-01-30 12:11:00 +0900
tags: [Linux]
---

以前までマウスを使っていましたが手首が痛くなってきたのでトラックボール「Kensington Expert Mouse」に変更しました。

その結果、手首の痛みは改善し楽になりました。

ただ、1つ困ることがあり右クリックが右下のボタンに割り当てられており右小指で押す時に少し手首が痛い時があります。

## マウスのIDを調べる 

Linuxでマウスのボタン配置を変更する方法は色々あると思いますが今回は `xinput` を使うことにしました。

まず、対象のマウスのIDを知るために下記のコマンドを実行します。

```bash
fukata:~ $xinput list
⎡ Virtual core pointer                          id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ ELAN24F0:00 04F3:24F0                     id=12   [slave  pointer  (2)]
⎜   ↳ DELL07E6:00 06CB:76AF Mouse               id=13   [slave  pointer  (2)]
⎜   ↳ DELL07E6:00 06CB:76AF Touchpad            id=14   [slave  pointer  (2)]
⎜   ↳ Kensington Expert Wireless TB Mouse       id=16   [slave  pointer  (2)]
⎜   ↳ PS/2 Synaptics TouchPad                   id=24   [slave  pointer  (2)]
⎜   ↳ Generic Blue Microphones Consumer Control id=18   [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ Power Button                              id=8    [slave  keyboard (3)]
    ↳ Sleep Button                              id=9    [slave  keyboard (3)]
    ↳ Integrated_Webcam_HD: Integrate           id=10   [slave  keyboard (3)]
    ↳ Integrated_Webcam_HD: Integrate           id=11   [slave  keyboard (3)]
    ↳ Topre Corporation HHKB Professional       id=15   [slave  keyboard (3)]
    ↳ Kensington Expert Wireless TB Consumer Control    id=17   [slave  keyboard (3)]
    ↳ Intel HID events                          id=20   [slave  keyboard (3)]
    ↳ Intel HID 5 button array                  id=21   [slave  keyboard (3)]
    ↳ Dell WMI hotkeys                          id=22   [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard              id=23   [slave  keyboard (3)]
    ↳ Generic Blue Microphones Consumer Control id=19   [slave  keyboard (3)]
    ↳ Generic Blue Microphones                  id=25   [slave  keyboard (3)]
```

下記のようにあるので id=16 だということが分かります。

```
⎜   ↳ Kensington Expert Wireless TB Mouse       id=16   [slave  pointer  (2)]
```

## キーの確認

`xinput query-state マウスのID` を実行することで現在の各ボタンの状況を調べることができます。

```bash
fukata:~ $xinput query-state 16
2 classes :
ButtonClass
        button[1]=up
        button[2]=up
        button[3]=up
        button[4]=up
        button[5]=up
        button[6]=up
        button[7]=up
        button[8]=up
        button[9]=up
ValuatorClass Mode=Relative Proximity=In
        valuator[0]=1362
        valuator[1]=1364
        valuator[2]=0
        valuator[3]=11715
```

どのボタンがどの番号なのかは対象のボタンを押しながら先ほどのコマンドを実行することで押されているボタンが `down` と表示されます。

右下のボタンを押しながら先ほどのコマンドを実行した結果です。

```bash
fukata:~ $xinput query-state 16
2 classes :
ButtonClass
        button[1]=up
        button[2]=up
        button[3]=down
        button[4]=up
        button[5]=up
        button[6]=up
        button[7]=up
        button[8]=up
        button[9]=up
ValuatorClass Mode=Relative Proximity=In
        valuator[0]=1281
        valuator[1]=1859
        valuator[2]=0
        valuator[3]=11715
```

また、右クリックを割り当てたい右上のボタンを押しながら実行した結果です。

```bash
fukata:~ $xinput query-state 16
2 classes :
ButtonClass
        button[1]=up
        button[2]=up
        button[3]=up
        button[4]=up
        button[5]=up
        button[6]=up
        button[7]=up
        button[8]=down
        button[9]=up
ValuatorClass Mode=Relative Proximity=In
        valuator[0]=1237
        valuator[1]=2015
        valuator[2]=0
        valuator[3]=11715
```

`右下=3` `右上=8` だということが分かりました。

## ボタンマップの割当

`右下=3` `右上=8` が分かったので右上にも右下と同じものを配置したいと思います。

まずは現在のボタンマップを確認します。

```bash
fukata:~ $xinput --get-button-map 16
1 2 3 4 5 6 7 8 9
```

ボタンの数が一致していることを確認してください。

次に8番目を3番目と同じものに割り当てます。

```bash
fukata:~ $xinput set-button-map 16 1 2 3 4 5 6 7 3 9
```

このままだと再起動時に元に戻ってしまうので `.bashrc` や `.bash_profile` などに追記しておくと良いかと思います。