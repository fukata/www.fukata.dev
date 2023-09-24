---
layout: post
title: WP Fastest Cache で階層が深いとtmpWpfcのファイルが削除されない
date:  2023-09-24 15:00:00 +0900
tags: [WordPress, WP Fastest Cache]
---

## WP Fastest Cacheとは

[WP Fastest Cache – WordPress プラグイン \| WordPress.org 日本語](https://ja.wordpress.org/plugins/wp-fastest-cache/)

WPのサイトから配信するHTMLやCSS、JSをいい感じにキャッシュ、minifyしてくれるプラグインになります。

使っているサイトも多いんじゃないかと思います。

## /cache/tmpWpfc 以下のファイルが削除されない

お手伝いしているサイトがあり、サーバーの容量が定期的に溜まり続けていて調べると /cache/tmpWpfc 以下が容量を圧迫しているとのことでした。

この時にプラグインのコードを確認して下記のコードがプラグインが読み込まれるたびに実行されているのを確認しました。

```php
// to clear /tmpWpfc folder
if(is_dir($this->getWpContentDir("/cache/tmpWpfc"))){
    $this->rm_folder_recursively($this->getWpContentDir("/cache/tmpWpfc"));
}
```

実際の削除処理の部分。

```php
public function rm_folder_recursively($dir, $i = 1) {
    if(is_dir($dir)){
        $files = @scandir($dir);
        foreach((array)$files as $file) {
            if($i > 50 && !preg_match("/wp-fastest-cache-premium/i", $dir)){
                return true;
            }else{
                $i++;
            }
            if ('.' === $file || '..' === $file) continue;
            if (is_dir("$dir/$file")){
                $this->rm_folder_recursively("$dir/$file", $i);
            }else{
                if(file_exists("$dir/$file")){
                    @unlink("$dir/$file");
                }
            }
        }
    }

   if(is_dir($dir)){
        $files_tmp = @scandir($dir);
        
        if(!isset($files_tmp[2])){
            @rmdir($dir);
        }
   }

   return true;
}
```

`/cache/tmpWpfc` は画面からキャッシュの削除を実行した時に直接ファイルを削除するとCPU使用率が一気に上がる可能性があるため一時的に退避しておくゴミ箱みたいな扱いのようです。

それをリクエスト毎に50ファイルずつ削除するというものみたいです。

## 原因

処理を見てみるとカウンタiが50を超えると処理を中断しています。

`.`、`..` 等のファイルもこの対象なので階層が17を超えるとファイルが全く削除されないという挙動になっていました。

そして、問題のサイトのキャッシュの階層を見てみると実際に階層が17以上存在しました。

アプリケーション側を改修しても良いと思いますが改修コストが高くなりそうだったのでとりあえず別途定期的に自前で `/cache/tmpWpfc` を削除するスクリプトを書くことにしました。

## 要望

削除自体は自前で行うのでリクエスト毎の削除処理をスキップ出来るオプションがあるなといいなと感じたのでサポートの方にリクエストしておきました。

[Feature Request: Skip delete /cache/tmpWpfc files per requests \| WordPress.org](https://wordpress.org/support/topic/feature-request-skip-delete-cache-tmpwpfc-files-per-requests/)