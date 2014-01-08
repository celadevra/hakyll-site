---
title: 'DZSlides：从 Markdown 到 PDF'
date: 2014-01-07
categories: code
tags: [pandoc, ruby, groovy, java, css]
---

## 为什么使用 HTML 来做演示幻灯片

+ Markdown 在准备幻灯片内容时，十分便利，同时鼓励我把注意力集中于内容。
+ CSS 提供了灵活、强大、可重现的布局方式。
+ 可以用 JavaScript 制作更炫的效果。
+ 方便使用互联网上的图片资源和图床。
+ [Pandoc][Pandoc] 是加入 TeX、代码等内容的最佳工具。

## 使用 Markdown 编写幻灯片文本

Markdown 的使用不在此赘述。因为整个幻灯片的生成是用 Pandoc 从 Markdown 生成 HTML，所以需要预先了解一下 Pandoc 的 Markdown 在幻灯片中会怎样被呈现。

Pandoc 默认会处理 Markdown 文件的一个称为 `pandoc_title_block` 的部分，这部分是这样定义的：

~~~~
% Title
% Author
% Date
~~~~

其中任何一行都可以只保留开头的`%`，表示没有这个属性。在 Pandoc 生成的幻灯片中，这部分信息会被放到幻灯片的首页。

Pandoc 的文档说被当成单张幻灯片标题的是紧接着上一级标题，中间没有内容的最高一级标题。换句话说，如果你有这样的文档结构：

~~~~
# 节标题
## 幻灯片标题
Blah blah
### 小标题
~~~~

那么`## 幻灯片标题`下直到下一个二级标题之间的内容会被放到同一张片子上，而`# 节标题`会被作为这一部分幻灯片的总标题单独放在一张特殊形式的幻灯片上。这应该是最常见的一种设置。当然我们也可以用一级标题作为大节标题，二级标题作为小结标题，这时候三级标题才是单张幻灯片的标题。Pandoc 还提供了 `--slide-level=NUMBER` 这个设置来手动控制幻灯片标题的层级。

## 用 Pandoc 生成幻灯片

内容编写完以后，就可以用 Pandoc 转换到 HTML 形式的幻灯片。Pandoc 支持到五种基于 HTML 的幻灯片模式的转换。因为我想让幻灯片的依赖尽量少，所以选择了[DZSlides]格式。转换成这种格式时，Pandoc 需要带上 `-s` 参数，表示 standalone，这样的文件才会带上 DZSlides 正常工作所必须的 `<style>` 和 `<script>` 代码。假设幻灯片的内容定义在 `main.md` 中，Pandoc 的命令可以这样写：

```
$ pandoc -s -t dzslides main.md -o main.html
```

## 用 CSS 控制幻灯片外观

打开生成的 HTML 文件，我们能看到这是一个最基本的幻灯片，白底黑字，我们可以用光标键控制播放，但是这样的效果简陋了一些，我们需要对幻灯片的外观进行一些定制。默认情况下，Pandoc 使用的是自带的 DZSlides 模板，在[这里][dzslides-template]可以找到。我们需要把它下载下来，作为定制的基础。

打开这个文件，可以看到开头部分有这样一段代码：

```
$if(css)$
$for(css)$
  <link rel="stylesheet" href="$css$" $if(html5)$$else$type="text/css" $endif$/>
$endfor$
$else$
<style>
  ...
```

在用 Pandoc 生成 HTML 时，可以用 `--css=URL` 加入自定的 CSS 文件，这个参数可以多次使用以加入多个 CSS。但这样一来，DZSlides 只依赖单个 HTML 文件的优势就没有了，所以我们还是修改 `<style>...` 这部分的 CSS。我修改的文件在我的 GitHub [代码库][my-dzslides]中。

### 字体设置

PowerPoint 等幻灯片制作工具的优势是可以选用本地各种各样的字体，并且很容易打包形成可以独立播放的文件。HTML 格式的幻灯片虽然对软件和操作系统的要求不高，但如何保证在别的机器上播放时仍然能够显示我们选择的字体呢？我花了很长时间折腾这个，考虑了几种方案。

其一，使用系统上自带的字体，利用 CSS 本身的 fallback 机制实现在不同平台上相近的显示效果。我在 OS X 平台上制作幻灯片，播放可能是在 Windows 机器上，所以我这样写 CSS：

```
...
font-family: 'Baskerville-SemiBold', Arial, 'STKaiti', '楷体', 'SimKai', serif;
...
```

这样做的问题在于你没有 Windows 系统的话，很难实际测试生成幻灯片的效果，而且效果确实不怎么样。而且，这样做在后面利用工具生成 PDF 的时候还会造成很大麻烦。

其二，使用现成的 Web Fonts 方案。英文的字体我试用了 [Google Web Fonts][Gwebfonts] 的 Quando，效果差强人意，但是当我找中文的 Web Fonts 时却遇到了难题。台湾的 [JustFont][] 需要生成一段 3K 大小的 JavaScript，载入的速度也有些慢。海峡这边的[有字库][youziku]服务很不稳定，而且调用起来很是麻烦，要求我们先行生成所需字符的列表，不得已，我只好写了一段 Ruby 脚本来处理这个问题，不过这个脚本最终在第三个方案中派上了用场。

其三，使用本地存放的 Web 字体。Google 了一通之后，我发现了 [Font Squirrel][fontsquirrel] 这个网站。它提供几百种不同类型的字体供选择，我们也可以上传体积不大的字体，让它帮我们[生成][squirrelgen] WOFF、EOT、TTF 等格式的字体文件和相应的 CSS `@font-face` 描述。我选择了这里的 [Arsenal][] 作为我幻灯片的英文字体，另外选择了 [Modern Pictograms][modernpics] 来做列表前的 bullet，见我修改的[模板][my-dzslides]。

中文字体怎么办呢？如果继续用本地系统自带的字体文件，在浏览器中预览是没有什么问题，但生成 PDF 时就有很大的延迟，导致前几张片子都用不上字体。所以要用裁剪后的字体，只包括我幻灯片里实际用到的字。

我把 Ruby 脚本稍作修改，除了输出用到的汉字列表之外，还可以输出一个 [FontForge][] 脚本，用来从大的字体文件中提取需要的字符生成小的字符文件。脚本见 gist：

<script src="https://gist.github.com/celadevra/8294149.js"></script>

在我的系统上，执行产生的 FontForge 脚本需要带上环境变量：

```
FONTFORGE_LANGUAGE=fontforge ./subsetter /Library/Fonts/Kai.ttf fonts/Kai.ttf
```

否则会报语法错误。

我的 Ruby 脚本还可以输出一份中文字符列表，保存在一个文本文件中，一些字体切割工具似乎可以使用这用的输入形式。

这样得到了一个仅100多K的楷体字体文件，载入就足够快了。

## 生成 PDF

我的演示里有一些图片，放在[微博图床][zhuyi-weibo]上。演示放映地点的 Wi-fi 不稳定，到时候图片出不来怎么办？最好还是生成一个 PDF，而且像 [SlideShare][] 这样的网站也只接受 PDF 和 PPT(X) 格式。

工具方面没有太多选择，大多数使用 Pandoc 的人都会使用 [deck2pdf][]，因为它支持的幻灯片格式和 Pandoc 高度重合，而且自己写 Profile 还可以支持其他的格式，这点和 Pandoc 的哲学似乎也有相似之处。另外还有一些 Python 写的脚本，往往依赖 Qt 和 WebKit，对于这样一个简单的任务来说似乎太重了，~~尤其是在我已经为 deck2pdf 装了 JDK 和 FontForge 以后。~~

deck2pdf 需要使用 Java 1.7 版本或更高自己编译，调用它生成 PDF 的命令如下：

```
~/bin/deck2pdf-0.1-SNAPSHOT/bin/deck2pdf
  --profile=dzslides.groovy
  --width=1024 --height=768
  --fontsdir=fonts main.html slides.pdf
```

其中 `--profile` 参数必填，使用 deck2pdf 自带的 profile 就填 `dzslides`，否则可以自己用 [Groovy][] 写一个，但文件扩展名必须用 `.groovy`。deck2pdf 本质上是用 JVM 上的一个浏览器播放幻灯片并截屏，`--width` 和 `--height` 决定了这个浏览器窗口的大小，如果不填的话生成的 PDF 会采用和目前全屏显示一样的比例，对大多数现代电脑来说，这将是 16:9 或 16:10，而多数投影仪还是 1024x768 的分辨率，放映出来就会有点奇怪。
`--fontsdir` 告诉 deck2pdf 到哪里找字体，如果用 Java 1.8 中带的 JavaFX 3 编译运行 deck2pdf 而且 CSS 中有 `@font-face` 指令的话，这个参数并不必要。

用 deck2pdf 生成 PDF 还有一个问题，我始终没有解决，就是标题幻灯片截取的时候只有第一行大标题，没有作者和日期信息，需要手动在预览窗口里切换到下一张再切回来，所以我在自定的 profile 中把延迟延长到了5秒：`pause = 5000`，不过总是不太爽，有空再想法解决吧。

[Pandoc]: http://johnmacfarlane.net/pandoc/ "About Pandoc"
[DZSlides]: https://github.com/paulrouget/dzslides "DZSlides on GitHub"
[dzslides-template]: https://github.com/jgm/pandoc-templates/blob/master/default.dzslides "DZSlides template for Pandoc"
[my-dzslides]: https://github.com/celadevra/jobreview-2013/blob/master/feco.dzslides "My customize DZSlides template"
[Gwebfonts]: http://www.google.com/fonts "Web fonts provided by Google"
[JustFont]: http://www.justfont.com "中文字型web font服務"
[youziku]: http://www.youziku.com "有字库"
[fontsquirrel]: http://www.fontsquirrel.com "Handpicked free fonts for graphic designers with commercial-use licenses."
[squirrelgen]: http://www.fontsquirrel.com/tools/webfont-generator "Create Your Own @font-face Kits"
[Arsenal]: http://www.fontsquirrel.com/fonts/arsenal "Free Font Arsenal by Andriy Shevchenko"
[modernpics]: http://www.fontsquirrel.com/fonts/modern-pictograms "Free Font Modern Pictograms by John Caserta"
[FontForge]: http://fontforge.org "An outline font editor"
[zhuyi-weibo]: http://weibotuchuang.sinaapp.com "微博图床修复计划"
[SlideShare]: http://www.slideshare.net/
[deck2pdf]: https://github.com/melix/deck2pdf "Convert slide deck to PDF"
[Groovy]: http://groovy.codehaus.org "A dynamic language on JVM"
