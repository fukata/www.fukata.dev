#!/usr/bin/env bash
# レビューに必要なコンテキスト（対象記事、比較用の記事、タグ一覧、全タイトル）を出力する
# 使い方: context.sh [記事のパス]  省略時は最新の記事
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

posts() { ls _posts/*/*.md | sort -r; }

target="${1:-}"
if [ -z "$target" ] || [ ! -f "$target" ]; then
  target="$(posts | head -1)"
fi

echo "### レビュー対象の記事"
echo "ファイル: $target"
cat "$target"
echo

echo "### 参考用: 最近の別の記事（スタイル比較用）"
for f in $(posts | grep -vxF "$target" | head -2); do echo "=== $f ==="; cat "$f"; echo; done

echo "### 過去に使用されたタグ一覧"
grep -rh "^tags:" _posts/ | sed 's/tags: \[//;s/\]//' | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep -v '^$' | sort -u
echo

echo "### 全記事のタイトルとURL（相互リンク確認用）"
for f in $(posts); do
  b="$(basename "$f" .md)"
  url="/${b:0:4}/${b:5:2}/${b:8:2}/${b:11}.html"
  echo "$url	$(grep -m1 '^title:' "$f" | sed 's/^title: *//')"
done
