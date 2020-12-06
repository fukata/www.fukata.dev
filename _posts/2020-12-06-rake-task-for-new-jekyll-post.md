---
layout: post
title: JekyllのPost作成用Rakeタスク 
date:  2020-12-06 13:39:00 +0900
tags: [Jekyll]
---

Jekyllには投稿を新規作成するコマンドがないので簡単なRakeタスクを作成しました。　

```ruby
# Rakefile
namespace :posts do
  desc "新しい投稿を作成します。"
  task :new do |task|
    input = {}

    puts "新しい投稿を作成します。情報を入力してください。"
    print "タイトル："
    input[:title] = STDIN.gets.strip
    if input[:title].length == 0
      puts "タイトルは1文字以上入力してください。"
      next
    end
    
    print "URLスラグ："
    input[:slug] = STDIN.gets.strip
    if input[:slug].length == 0
      puts "URLスラグは1文字以上入力してください。"
      next
    end

    puts "以下の内容で投稿を作成していいですか？(Y/n)"
    puts input.inspect

    unless STDIN.gets.strip.downcase == 'y'
      puts "キャンセルしました。"
      next
    end

    now = Time.now
    filepath = "_posts/#{now.strftime("%Y-%m-%d")}-#{input[:slug]}.md"
    puts "ファイルを作成します。 #{filepath}"
    File.open(filepath, 'w') do |f|
      f.write(<<"POST"
---
layout: post
title: #{input[:title]} 
date:  #{now.strftime("%Y-%m-%d %H:%M:00 %z")}
---

PLEASE WRITE GOOD POSTS
POST
      )
    end
    puts "ファイルを作成しました。 #{filepath}"
  end
end
```