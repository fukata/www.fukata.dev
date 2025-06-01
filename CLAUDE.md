# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Communication Language

このリポジトリでのやり取りは日本語で行ってください。コミットメッセージも日本語で記述してください。

## Git Configuration

コミット時の作者情報は.gitconfigの設定を使用してください。Co-Authored-Byなどの追加情報は含めないでください。

## Project Overview

This is a Jekyll-based personal blog (www.fukata.dev) written in Japanese. The site is deployed to Cloudflare Pages.

## Development Commands

### Start Development Server

Using Docker (recommended):
```bash
docker compose up
```

Using native Ruby:
```bash
bundle exec rake dev
```

Both commands start Jekyll server on http://localhost:4000 with live reload enabled.

### Create New Blog Post

```bash
bundle exec rake posts:new
```

This interactive command (in Japanese) will:
- Prompt for post title
- Prompt for URL slug
- Create a new post file in `_posts/YYYY/YYYY-MM-DD-slug.md`
- Pre-fill with appropriate front matter

## Architecture

### Key Files
- `_config.yml`: Jekyll configuration, plugins, and site metadata
- `Rakefile`: Automation tasks for development and post creation
- `docker-compose.yml`: Containerized development environment (Ruby 3.4.3)

### Content Structure
- Blog posts: `_posts/YYYY/YYYY-MM-DD-slug.md`
- Assets: `assets/posts/YYYY/` for post-specific images
- Layouts: `_layouts/` (home, page, post)
- Includes: `_includes/` for reusable components

### Special Features
- Custom git-history plugin for showing file edit history
- Support for Twitter/YouTube embeds and Mermaid diagrams
- Japanese language content
- Google Analytics integration
- Cloudflare Pages deployment (see `_headers` for configuration)