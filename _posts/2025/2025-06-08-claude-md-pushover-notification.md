---
layout: post
title: "Claude Codeで作業効率化：CLAUDE.mdとPushover通知の活用法"
date: 2025-06-08 10:00:00 +0900
---

Claude Codeを使って開発作業をしていると、長時間のビルドやテストの実行中に別のPCで作業したくなることがあります。そんな時、タスクの完了や入力待ちを通知で知らせてくれると非常に便利です。

## 背景

最近、複数のリポジトリに対してClaude Codeを使用することが増えてきました。複数のプロジェクトを並行して進めていると、あるプロジェクトでClaude Codeにタスクを依頼した後、別のプロジェクトの作業に移ることがよくあります。

しかし、気づいたら最初のプロジェクトでClaude Codeが入力待ちになっていたり、エラーで止まっていたりすることがありました。定期的にターミナルを確認するのも効率的ではありません。

そこで、Claude Codeの設定ファイル`CLAUDE.md`を使って、Pushover通知を組み込むことにしました。

## CLAUDE.mdとは

CLAUDE.mdは、Claude Codeがプロジェクトやグローバルで参照する設定ファイルです。以下の2つの場所に配置できます：

- `~/.claude/CLAUDE.md`: グローバル設定（全プロジェクト共通）
- `プロジェクトルート/CLAUDE.md`: プロジェクト固有の設定

## Pushover通知の設定

### 1. 通知スクリプトの作成

まず、Pushover APIを使った通知スクリプトを作成します：

```bash
#!/bin/bash
# ~/scripts/notify-pushover.sh

TITLE="$1"
MESSAGE="$2"
PUSHOVER_USER_KEY="your_user_key"
PUSHOVER_APP_TOKEN="your_app_token"

curl -s \
  --form-string "token=${PUSHOVER_APP_TOKEN}" \
  --form-string "user=${PUSHOVER_USER_KEY}" \
  --form-string "title=${TITLE}" \
  --form-string "message=${MESSAGE}" \
  --form-string "sound=pushover" \
  https://api.pushover.net/1/messages.json > /dev/null
```

実行権限を付与：
```bash
chmod +x ~/scripts/notify-pushover.sh
```

### 2. CLAUDE.mdの設定

`~/.claude/CLAUDE.md`に以下の内容を記述します：

```markdown
### Notification Rules

When working with Claude Code, use notifications to inform the user:
- **When prompting for user input**: Execute `~/scripts/notify-pushover.sh "Claude Code" "ユーザーの入力が必要です"`
- **When task is completed**: Execute `~/scripts/notify-pushover.sh "Claude Code" "タスクが完了しました"`
- **When error occurs**: Execute `~/scripts/notify-pushover.sh "Claude Code Error" "エラーが発生しました"`
```

## 実際の動作例

このように設定しておくと、Claude Codeが以下のような場面で自動的に通知を送ってくれます：

### ビルドタスクの例

```
You: npmのビルドを実行してください

Claude Code: npmのビルドを開始します。

[ビルドコマンドを実行]
...
[ビルド完了時に自動的に通知]
~/scripts/notify-pushover.sh "Claude Code" "ビルドが完了しました"
```

### エラー発生時の例

```
You: テストを実行してください

Claude Code: テストを実行します。

[テストコマンドを実行]
...
[エラー発生時に自動的に通知]
~/scripts/notify-pushover.sh "Claude Code Error" "テストが失敗しました: 3件のテストケースでエラー"
```

### ユーザー入力待ちの例

```
You: 本番環境にデプロイしてください

Claude Code: デプロイ先の環境を確認します。

~/scripts/notify-pushover.sh "Claude Code" "本番環境へのデプロイを実行してよろしいですか？(yes/no)"
```

## メリット

1. **マルチタスクが可能に**: 長時間のタスク実行中に別の作業ができます
2. **エラーの早期発見**: エラー発生時にすぐに気づけます
3. **作業の効率化**: 入力待ちで放置されることがなくなります
4. **複数PCでの作業**: 別のPCで作業していても通知を受け取れます

## 注意点

- Linux/macOS環境で動作します（Windowsの場合は別途通知方法の検討が必要）
- Pushoverのアカウント作成とAPIキーの取得が必要です
- 通知が多すぎると逆に作業の妨げになる可能性があるので、適切に設定しましょう

## まとめ

CLAUDE.mdとPushover通知を組み合わせることで、Claude Codeをより効率的に活用できるようになります。特に長時間のビルドやテストを頻繁に実行する開発者にとっては、作業効率の大幅な向上が期待できるでしょう。

ぜひ自分の開発環境に合わせてカスタマイズして、快適な開発環境を構築してみてください。