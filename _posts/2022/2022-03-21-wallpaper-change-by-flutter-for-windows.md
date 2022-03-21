---
layout: post
title: Flutter for Windowsで壁紙を変更してみた
date:  2022-03-21 00:00:00 +0900
tags: [Flutter]
---

[Software Design (ソフトウェアデザイン) 2022年04月号](https://amzn.to/3L2NIBJ) で特集されていたFlutterがWindowsにも対応していたのでちょっと遊んでみました。

## win32パッケージ

[win32 \| Dart Package](https://pub.dev/packages/win32)

win32用のパッケージがありまさにまさにやりたいことが実装されていました。

ドキュメントは本家で確認すると分かりやすかったです。

[IDesktopWallpaper::SetWallpaper (shobjidl_core.h) - Win32 apps \| Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-idesktopwallpaper-setwallpaper)

## コード

win32パッケージのexampleには壁紙を変更するものがなかったのでとりあえず動くところまで実装してみました。

```dart
/// 現在の壁紙のファイルパス
// TODO: ユーザーが画像を選択できるようにする
String wallpaperFilePath = path.join(
    "path", "to", "wallpaper.jpg");

/// 壁紙を変更するボタンが押された時の処理。
void _handleChangeWallpaper() {
  var file = File(wallpaperFilePath);
  if (!file.existsSync()) {
    // ファイルが存在しない
    log("画像が存在しない。 filePath=$wallpaperFilePath");
    return;
  }

  log("壁紙を変更する。 filePath=$wallpaperFilePath");

  final hr = CoInitializeEx(
      nullptr, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);
  if (FAILED(hr)) {
    throw WindowsException(hr);
  }

  var desktopWallpaper = DesktopWallpaper.createInstance();
  Pointer<Utf16> wallpaperFilePathPtr = wallpaperFilePath.toNativeUtf16();
  try {
    int result = FALSE;

    // モニタの数を取得する
    Pointer<Uint32> monitorDevicePathCountPtr = calloc<Uint32>();
    result =
        desktopWallpaper.GetMonitorDevicePathCount(monitorDevicePathCountPtr);
    if (result != S_OK) {
      free(monitorDevicePathCountPtr);
      throw WindowsException(result);
    }
    log("result=$result, monitorDevicePathCountPtr.value=${monitorDevicePathCountPtr.value}");

    // すべてのモニタに壁紙を設定する
    for (var i = 0; i < monitorDevicePathCountPtr.value; i++) {
      Pointer<Pointer<Utf16>> monitorIdPtr = calloc<Pointer<Utf16>>();
      result = desktopWallpaper.GetMonitorDevicePathAt(i, monitorIdPtr);
      if (result != S_OK) {
        free(monitorIdPtr);
        throw WindowsException(result);
      }
      log("result=$result, monitorIdPtr=${monitorIdPtr}");

      log("Change wallpaper. i=$i");
      desktopWallpaper.SetWallpaper(monitorIdPtr.value, wallpaperFilePathPtr);

      free(monitorIdPtr);
    }

    free(monitorDevicePathCountPtr);
  } finally {
    free(wallpaperFilePathPtr);
    free(desktopWallpaper.ptr);
    CoUninitialize();
  }
}
```

## 作りたいもの

Google Photosにアップロードした写真を壁紙に設定出来るものがあると良いなと思って（自分が）せっかくなのでFlutterで作ってみています。
