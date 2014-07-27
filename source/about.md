---
title: 关于本网站
created: 2014-04-30
author: Haoyang Xu
description: 建立这个网站的目的，使用的工具，以及将来的愿景。
status: links
belief: highly likely
tags: site
---

<!-- Status choices are: links, notes, draft, in progress, finished -->
<!-- belief tags are: certain, highly likely, likely, possible, unlikely, highly unlikely, remote, impossible -->

使我想要建立这个网站的原因是，我曾经是个 blogger。

作为国内最早开始写 blog 的一批人之一，我从2004年开始写 blog，从[博客中国](http://www.blogchina.com)到 Blogger 再到 Wordpress 再到后来的数不清的各种平台，再到自己在 [Bluehost](http://bluehost.com) 上架设 Wordpress 和 GitHub 上的 Octopress，我一直写到了2013年。前前后后大概写了三四百篇长短文章，散落在各处，包括：

* <http://snakehsu.blogspot.com>
* <http://celadevra.blogspot.com>
* <http://celadevra.github.io>

出于猎奇的心理，你可能会饶有兴致地去翻看那些旧文章，但我已经几乎不去看它们了。就我所知，很多人也不会再去看ta们曾经写过的 blog。Blog 对于记录事件和一时的心情是很有用的，对于练笔和整理思路可能也是很有用的，但作为一种想法和知识的积累，它的效用非常有限。Blog 的题材，从最无聊的记录生活细节，到有点深度地就某个事件发表一些看法，都受到时效性的限制。过了半年或更长时间，如果再看当时写的这些文章，不免有今夕何夕之感，它们的阅读价值也就大打折扣。

而这前提是，我还能找到当时写下的文章。Blog 写作者很难针对一个具体的问题打破沙锅问到底，因为一天能用于写字的时间只有那么多，而第二天ta可能没有精力再写，或者转向了其他的题目，许多可以深挖的坑就只好浅尝辄止。因此，经常更新 blog 可以看做是勤奋的表现，却也可以是掩饰缺乏耐性的借口。

2013年下半年，我注意到了 <http://gwern.net> 这个网站。关于它的作者 Gwern 我所知甚少，但他（？）提出的 Long Site，Long Content 的观点完全改变了我对互联网内容发布的看法，影响他的 [Long Now](http://en.wikipedia.org/wiki/Long%20Now) 思想看起来也很有意思。看了他的网站以后，我想仿效他的做法，做一个内容可以长期存在，并且在较长时间内都具有参考价值的个人网站，于是就有了你现在看到的一切。

# 技术细节

这个网站以至少两种形式存在，其一是 expoundite.net 上的成品，其二是 GitHub 上的一个[代码库](https://github.com/celadevra/hakyll-site)。理论上说，只要人们还使用代码管理工具，这个网站从创建至今的状态和它所有的改变历史都可以保存下来。在代码库中，网站的文章保存为 [Markdown](http://daringfireball.net/projects/markdown/) 格式，并使用 Pandoc 提供的各种语法扩展。Markdown 文件通过 Hakyll 静态网站生成器，调用 Pandoc 转换成无扩展名的 HTML 文件，这样所有文章都可以通过 http://expoundite.net/[页面名] 或 http://expoundite.net/docs/[页面名] 的形式访问，避免了在可能的更换后台生成器的时候，由于链接格式不同造成的链接失效问题。采用无扩展名的文件而不是依赖 URL rewrite 是为了让内容尽可能不依赖于后台 HTTP 服务器的具体实现。

生成的网站内容使用 s3cmd 上传到 [Amazon S3](http://aws.amazon.com/)，利用其自带的静态网页发布功能提供浏览。为了提高访问速度，节约流量和使用一些实用的功能，还使用了 [Cloudflare](http://cloudflare.com/) 的免费 CDN。由于 Amazon S3 的网页发布功能依赖 MIME type 确定文件是否属于 HTML 文件，所以在 s3cmd 的上传命令中需要指定默认 MIME type 为 `text/html`，具体见[脚本](https://github.com/celadevra/hakyll-site/blob/master/upload.sh)。

网站的样式以 [Normalize.css](http://necolas.github.io/normalize.css/) 和 [Typeplate](http://typeplate.com) 的 CSS 为基础，并进行了一些定制。图标字体采用 [Entypo](http://www.fontsquirrel.com/fonts/entypo)。网站上的图片目前放在[七牛云](http://www.qiniu.com/)上。

# 愿景

文字是思绪的凝固和记录，而这个网站上的文字应该关系到那些难度最大又最有趣的思考：现象背后的原因为何，如何理解我们的时代，思想如何影响个人的生活。这些思考或许基于一时的现象而生发，但思想的路径不可止于一时的意义，而需要在 the Long Now 的框架中得出更具有普适性的观点，并作为新的讨论的生长点。

而且写就一篇文章，并不意味着对这个问题的思考的终结。网络和电子出版的特性，允许作者不断地在原有作品的基础上深化、拓展，甚或推翻自己的结论。因此凝结在这些网页上的文字，也起到帮助作者回忆一个时期之前的想法，从而展开批评的作用。

为避免托马斯·索维尔在《知识分子与社会》中指出的知识分子的谬误，我的文字应尽量基于实际的经验，而非未经过事实检验的理论。对于理念的讨论，也会考虑它们的实际效用，而不仅仅是表面上的价值观的正确性。一部分文章甚至会专门用来记录经验，而将意义的讨论留给读者。

网站上也会有一些我的虚构作品。写小说对我来说还是一种新的体验，但它可以带出一些连我自己也不知道的观感、态度，也可以让我对自己有更多的认识。

最后，我会做一个业余抄书匠，在速朽的网络上为一些文字多留一份拷贝。