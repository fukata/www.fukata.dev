#!/usr/bin/env bash
# 記事作成に必要なコンテキスト（最近の記事、タグ一覧、文体参考、日付）を出力する
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

posts() { ls _posts/*/*.md | sort -r; }

echo "### 最近の記事一覧"
posts | head -5
echo

echo "### 最近の記事のフロントマター"
for f in $(posts | head -3); do echo "=== $f ==="; head -6 "$f"; echo; done

echo "### 過去に使用されたタグ一覧"
grep -rh "^tags:" _posts/ | sed 's/tags: \[//;s/\]//' | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep -v '^$' | sort -u
echo

echo "### 最新記事の全文（文体参考用）"
cat "$(posts | head -1)"
echo

echo "### 本日の日付"
date +"%Y-%m-%d %H:%M:00 %z"
