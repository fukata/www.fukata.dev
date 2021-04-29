---
layout: post
title: ElasticBeanstalk上でのアプリケーションログのローテート
date:  2021-04-29 09:51:00 +0900
tags: [ElasticBeanstalk]
---

# 結論

`/var/app/current/log/*.log` は `/var/app/containerfiles/logs/rotated/` 以下にローテートされるようです。

他のプラットフォームを使用していないので分かりませんが、Rubyプラットフォームを使っている場合はデプロイ直後にある `log/*.log` のみが対象となるようです。

Railsの場合は起動した時にログファイルが出来ると思いますが、独自のフレームワークを使っていてログがローテートされないという方がいればこの辺りを見ても良いかもしれません。

# アプリケーションログのログローテート設定

`/etc/logrotate.elasticbeanstalk.hourly/logrotate.elasticbeanstalk.webapp.conf`

```bash
/var/app/containerfiles/logs/* {
size 10M
rotate 5
missingok
compress
notifempty
copytruncate
dateext
dateformat %s
olddir /var/app/containerfiles/logs/rotated
}
```

# デプロイ直後に呼ばれるフック

`/opt/elasticbeanstalk/hooks/appdeploy/post/01_rails_support.sh`

```bash
#!/usr/bin/env bash
#==============================================================================
# Copyright 2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use
# this file except in compliance with the License. A copy of the License is
# located at
#
#       https://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
# implied. See the License for the specific language governing permissions
# and limitations under the License.
#==============================================================================
set -xe
EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config container -k app_deploy_dir)
EB_APP_LOG_DIR=$(/opt/elasticbeanstalk/bin/get-config container -k app_log_dir)
# For builtin Rails logging support
ln -sf $EB_APP_DEPLOY_DIR/log/*.log $EB_APP_LOG_DIR
```