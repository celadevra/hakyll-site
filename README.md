hakyll-site
===========

我的个人网站，以论说文为主，使用 [Hakyll](http://jaspervdj.be/hakyll/) 搭建。

依赖：

- Digital Ocean
- Docker
- nginx
- jQuery
- MathJax

网站发布在 <https://expoundite.net/>

## 部署方法

部署一台 Linux 服务器。

安装 [Docker](https://docker.com) 和 Git。

Clone 这个 repo 到本地，假设是 `~/src/hakyll-site`。

```
docker pull celadevra/blog
docker pull nginx
```

将 [nginx.conf](https://gist.github.com/celadevra/91977fe7a31be2290e4c#file-config) 的内容保存到本地，假设为 `~/src/docker-nginx/config`。

安装 [Let's Encrypt](https://letsencrypt.org) 的客户端。生成所需域名的 SSL 证书。将证书从 `/etc/letsencrypt/live/{$域名}` 拷贝到 `~/src/docker-nginx/` 目录下。

第一次生成网站：
```
docker run -v ~/src/hakyll-site:/src celadevra/blog '/src/site build'
```

启动 watch 进程：
```
docker run -d -v ~/src/hakyll-site:/src celadevra/blog '/src/site watch' 
```

将 [Dockerfile](https://gist.github.com/celadevra/91977fe7a31be2290e4c#file-dockerfile) 下载到 `~/src/docker-nginx/Dockerfile`。

在 nginx 镜像的基础上构建一个新的 docker 镜像：
```
cd ~/src/docker-nginx
docker build -t hakyll-nginx .
```

启动 nginx：
```
docker run -d -p 80:80 -p 443:443 -v ~/src/hakyll-site/_site:/data/www hakyll-nginx
```

TODO: 使用 docker compose 自动化上述过程。

## 其他

网站内容使用 CC-BY-SA 4.0 协议发布，除非另有说明。

对网站代码和内容有任何意见，请在 GitHub 提交 Issue 或 Pull Request。
