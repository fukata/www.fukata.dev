---
layout: post
title: 撮影データをSDカードから取り込むスクリプト 
date:  2021-02-07 17:00:00 +0900
tags: []
---

# 構造 

普段、ミラーレスで撮影した写真や動画ファイルを下記のようなディレクトリ構造で保存しています。

`_raw` はRAWファイルを保存していてその下に日付ごとのディレクトリを更に作成しています。

```
data/
  camera_raw/
    2021/
      01/
        17/
          xxxx.ORF
  camera/
    2021/
      01/
        17/
          xxxx.jpg
  video_raw/
    2021/
      01/
        17/
          xxxx.MOV
  video/
    2021/
      01/
        17/
          xxxx.mp4
```

# ghoto

手動でこれらのディレクトリを作成するのが面倒くさいので自作のスクリプトを経由してディレクトリの作成、ファイルの移動を行っています。

下記の感じで実行することで上記のディレクトリ構造を保ちつつファイルを移動します。

ディレクトリの日付はExifにある撮影日を元にしています。

```bash
$ghoto --from /path/to/src --to /path/to/dst --photo-dir camera_raw --video-dir video_raw --concurrency 10 --recursive --force
```

[https://github.com/fukata/ghoto](https://github.com/fukata/ghoto)

# 複数SDカード、メーカー毎の構造を吸収

さらに複数のSDカード、メーカー毎のディレクトリ構造の差を吸収するために下記のようなスクリプトを作っています。とりあえず、自分の持っているメーカーであれば問題無く動いています。

そもそもメーカー毎の構造を気にしなくていいようにしたいところです。

{% raw %}
```bash
#!/usr/bin/env bash

#set -x

TO_PATH=''
DATA_DIR=/data/
GHOTO=/home/fukata/dev/src/github.com/fukata/ghoto/ghoto
MOUNT_DIR=/media/fukata/

echo "Finding destination dir..."
# スペースを含むディレクトリに対応するために改行文字に変更
IFS_ORG=$IFS
IFS=$'\n'
for root_dir in $(find $MOUNT_DIR -maxdepth 1 -type d)
do
  # ルートディレクトリ自身は対象に含めない
  if [ "$root_dir" == "$MOUNT_DIR" ]; then
    continue
  fi

  #echo "root_dir=$root_dir"
  # データディレクトリがあれば保存先か問い合わせる
  if [[ "$TO_PATH" == '' ]]; then
    data_path="${root_dir}${DATA_DIR}"
    #echo "data_path=$data_path"
    if [[ -d "$data_path" ]]; then
      read -n1 -p "$data_path is destination path? (y/N): " yn
      echo ''
      if [[ $yn = [yY] ]]; then
        TO_PATH="$data_path"
        break
      fi
    fi
  fi
done

# 保存ディレクトリが見つからなければ強制終了
if [[ "$TO_PATH" == '' ]]; then
  echo "Not found destination dir"
  exit 1
fi

echo "save path: ${TO_PATH}"

echo "Finding sources..."
for root_dir in $(find $MOUNT_DIR -maxdepth 1 -type d)
do
  # ルートディレクトリ自身は対象に含めない
  if [ "$root_dir" == "$MOUNT_DIR" ]; then
    continue
  fi

  for dir1 in $(ls "$root_dir")
  do
    #echo "$root_dir/$dir1"
    if [ "$dir1" = "DCIM" ]; then
      #echo "$root_dir/$dir1"
      for dir2 in $(ls "$root_dir/$dir1")
      do
        src="$root_dir/$dir1/$dir2"
        #echo $src
        # OLYMPUS
        if [ $(echo "$dir2" |egrep '[0-9]+OLYMP') ]; then
          echo "$src is OLYMPUS."
          $GHOTO --from $src --to $TO_PATH --photo-dir camera_raw --video-dir video_raw --concurrency 10 --recursive --force
        fi
        # SONY Action Cam (PHOTO)
        if [ $(echo "$dir2" |egrep '[0-9]+ANV[0-9]+') ]; then
          echo "$src is SONY Action Cam (PHOTO)."
          $GHOTO --from $src --to $TO_PATH --photo-dir camera_raw --video-dir video_raw --concurrency 10 --recursive --force
        fi
      done
    elif [ "$dir1" = "MP_ROOT" ]; then
      echo "$root_dir/$dir1"
      for dir2 in $(ls "$root_dir/$dir1")
      do
        src="$root_dir/$dir1/$dir2"
        #echo $src
        # SONY Action Cam (VIDEO)
        if [ $(echo "$dir2" |egrep '[0-9]+ANV[0-9]+' |wc -l) -gt 0 ]; then
          echo "$src is SONY Action Cam (VIDEO)."
          $GHOTO --from $src --to $TO_PATH --photo-dir camera_raw --video-dir video_raw --concurrency 10 --recursive --force
          # サムネイルファイルを削除
          if [ $(ls $src/ |egrep '\.THM$' |wc -l) -gt 0 ]; then
            rm $src/*.THM
          fi
        fi
      done
    fi
  done
done
IFS=$IFS_ORG
```
{% endraw %}

あとは、このスクリプトを呼び出すだけで複数のSDカードが同時に接続されていてもちゃんと全て転送してくれます。頻度の高い作業なので極力楽したいですね。

```bash
$bash ./mv_camera_data.sh
```