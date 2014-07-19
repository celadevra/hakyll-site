hakyll-site
===========

![Build Status](https://travis-ci.org/celadevra/hakyll-site.png?branch=master)

我的个人网站，以论说文为主，使用 ~~[Hakyll](http://jaspervdj.be/hakyll/)~~ [Middleman](http://middlemanapp.com/) 搭建。

由于 Cabal 的依赖地狱问题实在太严重，不能适应云时代自动化和长期维持网站的需要，我决定将网站转移到我更熟悉，也更适合做这个工作的 Ruby 上。目前选择的技术栈是

- Sass
- Haml
- Kramdown
- Middleman

依赖：

- Sprocket
- Amazon AWS
- Travis CI
- jQuery

网站发布在 <http://expoundite.net/>

迁移需要做的工作包括：

- [X] 给现有网站拍照留念
- [ ] 在开发机器上安装 rbenv
- [ ] 将原有的 YAML head 格式转为 Middleman 能理解的格式
- [ ] 重写页面模板
- [ ] 编写 helper 读取扩展的 metadata
- [ ] 建立 blog 和 newsletter 功能
- [ ] 删除过去的 Haskell 相关文件和不再使用的静态 assets
