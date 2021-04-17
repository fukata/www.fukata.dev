---
layout: post
title: CircleCI上でMySQLのレプリケーション環境を構築する
date:  2021-04-17 16:57:00 +0900
tags: [CircleCI]
---

`primary / replica` それぞれのDB接続を行った状態で正常にアプリケーションが動作するかのテストをCI上で行えないかと思って調べて何とか環境を構築出来ました。

後述していますがレプリケーションラグが発生してしまい、それを毎回待っているとテスト全体が遅くなるので特定のE2Eテストのみレプリケーション環境下でテストを行うということにしました。


## 元々のconfig.yml

```yaml
test:
  docker:
    # MySQL
    - image: circleci/mysql:5.6.38-ram
      command:
        - --character-set-server=utf8mb4
        - --collation-server=utf8mb4_bin
        - --long-query-time=1
        - --innodb-file-format=Barracuda
        - --innodb-file-per-table=true
        - --innodb-large-prefix=true
        - --skip-character-set-client-handshake
      environment:
        MYSQL_DB: 'dummy'
        MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
  steps:
    - checkout
    ... DBセットアップ、テスト実行 ...
```

## レプリケーションに対応したconfig.yml

```yaml
test_with_replica:
  docker
    # MySQL (primary)
    - image: circleci/mysql:5.6.38-ram
      command:
        - --character-set-server=utf8mb4
        - --collation-server=utf8mb4_bin
        - --long-query-time=1
        - --innodb-file-format=Barracuda
        - --innodb-file-per-table=true/
        - --innodb-large-prefix=true
        - --skip-character-set-client-handshake
        - --gtid-mode=ON
        - --log-bin
        - --log-slave-updates
        - --binlog-format=ROW
        - --enforce_gtid_consistency=ON
        - --relay-log=relay-bin
        - --server_id=1
        - --port=3306
        - --datadir=/tmp/mysql-primary
      environment:
        MYSQL_DB: 'dummy'
        MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'

    # MySQL (replica)
    - image: circleci/mysql:5.6.38-ram
      command:
        - --character-set-server=utf8mb4
        - --collation-server=utf8mb4_bin
        - --long-query-time=1
        - --innodb-file-format=Barracuda
        - --innodb-file-per-table=true
        - --innodb-large-prefix=true
        - --skip-character-set-client-handshake
        - --bind-address=0.0.0.0
        - --gtid-mode=ON
        - --log-bin
        - --log-slave-updates
        - --binlog-format=ROW
        - --enforce_gtid_consistency=ON
        - --relay-log=relay-bin
        - --server_id=2
        - --port=13306
        - --datadir=/tmp/mysql-replica
      environment:
        MYSQL_DB: 'dummy'
        MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'

  steps:
    - checkout
    - run:
        name: Update apt packages
        command: |
          sudo apt update -qqy
    - run:
        name: Install MySQL Client
        command: |
          sudo apt install -qqy --no-install-recommends default-mysql-client
    - run:
        name: Setup Replication
        command: |
          mysql --user=root --host=127.0.0.1 --port=13306 -v mysql \<<SQL
            RESET MASTER;
          SQL
          mysqladmin ping --wait=5 --user=root --host=127.0.0.1 --port=3306
          mysqladmin ping --wait=5 --user=root --host=127.0.0.1 --port=13306
          mysql --user=root --host=127.0.0.1 --port=13306 -v \<<SQL
            CHANGE MASTER TO
              MASTER_HOST = '127.0.0.1',
              MASTER_PORT = 3306,
              MASTER_USER = 'root',
              MASTER_PASSWORD = '',
              MASTER_AUTO_POSITION = 1,
              MASTER_DELAY = 10;
            START SLAVE;
          SQL
    ... DBセットアップ、テスト実行 ...
```

## レプリケーションラグ

`SHOW SLAVE STATUS;` でレプリケーションラグを取得することが出来るわけですが、ユニットテストのように短時間で `TRUNCATE` を繰り返す環境だとレプリケーションラグが大きくなる傾向があるのでテスト間で現在のレプリケーションラグを確認して場合によっては待ったりする必要があるかもしれません。