---
title: Duplicity 本地备份设置
date: 2016-01-27
author: 徐栖
status: finished
belief: possible
tags: backup
...

<!-- Status choices are: links, notes, draft, in progress, finished -->
<!-- belief tags are: certain, highly likely, likely, possible, unlikely, highly unlikely, remote, impossible -->

# 准备工作

- 安装 [Duplicity][duplicity]。
- 克隆 [duplicity-backup][duplicity-backup] 脚本。
- [设置 GnuPG 签名密钥和加密密钥][gnupg]。
- 设置备份磁盘。

# 更改 duplicity-backup.conf

将下载得到的 `duplicity-backup.conf.example` 拷贝为 `duplicity-backup.conf`，主要修改其中的如下变量：

- `ROOT`
- `DEST`，默认是 S3 的，改为本地挂载的目录。
- `INCLIST`，`ROOT`下需要备份的目录清单，格式类似：
  ```
  INCLIST=( "/Users/*/Documents/" \
            "/Users/*/Codes/" )
  ```
- `EXCLIST`，如果在 `INCLIST` 下包括的目录还有子目录，而这些子目录不打算备份，可以加入这个列表。
- `PASSPHRASE`，用于加密的口令，如果使用 GPG 非对称加密的话，就是你的密钥对应的 passphrase。
- `GPG_ENC_KEY` 和 `GPG_SIGN_KEY`，分别是用于加密和签名的密钥，可以是同一个。
- `STATIC_OPTIONS` 可以按自己需要确定强制完全备份的时间间隔。
- `CLEAN_UP_TYPE` 和 `CLEAN_UP_VARIABLE`，可以确定保留多少个完全备份。
- `LOGDIR`，存放 log 的位置。
- `LOG_FILE`，log 文件命名方式。
- `LOG_FILE_OWNER`，log 的所有者和所在的用户组。

完成设置后，可以用

```
duplicity-backup.sh -c duplicity-backup.conf -b
```

测试一下运行是否正常。在 Mac 系统上，可能会报错同时可打开的文件数太少，可以用 `ulimit -n 2048` 增大。

# Launch Agent 设置

脚本运行没有问题之后，可以让它定期运行。Linux 上用 crontab -e 很容易搞定。OS X 上需要编写一个 plist 文件放在 `~/Library/LaunchAgents` 目录下，文件内容可参考如下的 gist：

<script src="https://gist.github.com/celadevra/8fa727f0cf562d2c4266.js"></script>

同样也要增大 `launchd` 能够同时打开的文件数：

```
launchctl limit maxfiles 2048 unlimited
```

之后用 `launchctl` 载入 plist 文件，备份就开始了。

[duplicity-backup]: https://github.com/zertrin/duplicity-backup
[duplicity]: http://duplicity.nongnu.org/
[gnupg]: http://expoundite.net/gpg-intro
