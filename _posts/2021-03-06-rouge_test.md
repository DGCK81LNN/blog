---
redirect_from: [ "/2021/03/06/rouge_test.html" ]
---

# Rouge代码高亮测试

本站之前使用[prism.js](https://prismjs.com)进行语法高亮，近期改为直接给GitHub Pages使用的[Jekyll](https://jekyllrb.com)使用的[Kramdown](https://kramdown.gettalong.org/)使用的[Rouge](http://rouge.jneen.net/)提供样式表。


## TypeScript

以下代码来自<https://github.com/DGCK81LNN/lnnbot/blob/19da0d352ff98b5bab9c7b125c9ab11205add906/src/command-l/video.ts>

```typescript
import { Message } from "mirai-ts";
import axios from "axios";
import { SendReplyFunction } from "../types";
import {
    ResponseWrapper,
    VideoCopyright,
    VideoViewResponse,
} from "./types";
import logger from "./logger";
import { Avbv, formatDuration, formatTime, formatStatistic } from "./utils";

function localConvertAVBV(errmsg: string, id: number | string) {
    logger.info(`尝试本地转换AV-BV`);
    var msg = errmsg + "\n本地AV-BV号转换结果：\n";
    try {
        msg += `av${Avbv.toAV(id)}　${Avbv.toBV(id)}`
        logger.success(`成功`);
    }
    catch (error) {
        logger.info(`转换失败`);
        console.log(error);
        msg += `出错：${error}`;
    }
    return Message.Plain(msg);
}

export default async function video<T extends "aid" | "bvid">(type: T, id: T extends "aid" ? number : string, sendReply: SendReplyFunction) {
    try {
        var response = await axios.get<ResponseWrapper<VideoViewResponse>>(`https://api.bilibili.com/x/web-interface/view?${type}=${id}`, { responseType: "json" });
    }
    catch (error) {
        logger.error("请求错误");
        console.error(error);
        await sendReply(localConvertAVBV(`请求出错：${error}`, id));
    }
    var wrapper = response.data;
    if (wrapper.code || !wrapper.data) {
        logger.info("服务器错误");
        console.log(wrapper);
        await sendReply(localConvertAVBV(`服务器错误 ${wrapper.code}：${wrapper.message}`, id));
        return;
    }
    var data = wrapper.data;

    var attributes: String[] = [];
    if (data.rights.is_cooperation) attributes.push("联合投稿");
    if (data.rights.is_stein_gate) attributes.push("互动视频");
    if (!data.rights.download) attributes.push("不允许下载");
    if (data.rights.movie) attributes.push("电影");
    if (data.rights.no_reprint) attributes.push("未经作者授权，禁止转载");

    await sendReply(
        Message.Image(null, data.pic),
        Message.Plain(`\n` +
            `${data.title}\n` +
            `\n` +
            (data.staff?.length ?
                `制作组：\n` +
                data.staff.map(staff =>
                    `${staff.title} - @${staff.name}（UID: ${staff.mid}）`
                ).join("\n")
                : `UP主：@${data.owner.name}（UID: ${data.owner.mid}）`
            ) + "\n" +
            `时长：${formatDuration(data.duration)}　${data.copyright === VideoCopyright.Original ? "自制" : "转载"}　二级分区：${data.tname}\n` +
            `发布时间:${formatTime(data.pubdate)}\n` +
            `av${data.aid}　${data.bvid}\n` +
            (attributes.length ? `属性：${attributes.join(" - ")}\n` : "") + "\n" +
            `简介：\n` +
            data.desc + "\n" +
            `\n` +
            `${formatStatistic(data.stat.view)}次播放　${formatStatistic(data.stat.danmaku)}条弹幕\n` +
            `${formatStatistic(data.stat.like)}人点赞　${formatStatistic(data.stat.coin)}个硬币　${formatStatistic(data.stat.favorite)}人收藏\n` +
            `${formatStatistic(data.stat.share)}次转发　${formatStatistic(data.stat.reply)}条评论\n` +
            `\n` +
            `【分P】${data.pages.length}个\n` +
            data.pages.map(page => `${page.page}. ${page.part} （${formatDuration(page.duration)}）`).join("\n") + "\n" +
            `\n` +
            `使用 /l av${data.aid} -tags 查询视频的标签；\n` +
            `使用 /l av${data.aid} -comments 查询视频的热门评论；\n` +
            `使用 /l av${data.aid} -comments -oldest 查询视频的最先10条评论；\n` +
            `使用 /l av${data.aid} -comments -latest 查询视频的最新10条评论。`
        ),
    );
    logger.success(`成功`);
}
```

## HTML

以下代码来自<https://github.com/DGCK81LNN/dgck81lnn.github.io/blob/0c2c275dd54891e53d939abb5f6dd87e373407df/apps/index.html>

```html
<!doctype html>
<html lang="cmn">
<!--
  这是灵魂小站 / 应用!
  ID: apps.index // soulapps
-->
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="format-detection" content="telephone=no">
  <link rel="stylesheet" href="/css/commons.css">
  <link rel="icon" href="/site_icon.png">
  <link rel="shortcut icon" href="/site_icon.png">
  <link rel="apple-touch-icon" href="/site_icon.png" sizes="160x160">
  <script src="https://polyfill.io/v3/polyfill.min.js?features=es2015%2CIntersectionObserver"></script>
  <script src="https://cdn.bootcdn.net/ajax/libs/vue/2.6.12/vue.min.js"></script>
  <script src="https://cdn.bootcdn.net/ajax/libs/bootstrap-vue/2.21.0/bootstrap-vue.min.js"></script>
  <script src="https://cdn.bootcdn.net/ajax/libs/bootstrap-vue/2.21.0/bootstrap-vue-icons.min.js"></script>
  <script src="/js/commons.js"></script>
  <title>应用 - 灵魂小站</title>
  <style>
    .flex {
      flex-wrap: wrap;
    }
    .card {
      flex: 1;
      min-width: 300px;
      margin: 1rem 8px;
    }
    .card-link {
      float: right;
      padding: 3px 0;
    }
    .card img {
      float: left;
      height: 60px;
      margin: 1rem;
    }
  </style>
</head>

<body>
  <div id="app">
    <soul-header></soul-header>
    <soul-main>
      <b-breadcrumb>
        <b-breadcrumb-item href="/home">主站</b-breadcrumb-item>
        <b-breadcrumb-item active>应用</b-breadcrumb-item>
      </b-breadcrumb>

      <b-card-group deck class="flex">
        <b-card
        v-for="item in a"
        :key="item.title"
        class="card"
        >
          <div slot="header" class="clearfix">
            <span>{{item.title}}</span>
            <b-link
            v-if="item.link"
            class="card-link"
            :href="item.link"
            >进入</b-link>
          </div>
          <div v-html="item.body"></div>
        </b-card>
      </b-container>
    </soul-main>
    <soul-footer></soul-footer>
  </div>
  <script>
    const vm = new Vue({
      el: "#app",
      data: {
          a: [
              {
                title: "灵魂实验室",
                body: `<p>
                  运行JavaScript... 或者一些奇怪的编程语言。
                </p>`,
                link: "lab/"
              },
              {
                title: "更多内容即将到来...",
                body: ""
              }
          ]
      }
    });
  </script>
</body>

</html>
```

## ruby

```ruby
subj, act, expl = [gets, gets, gets].map(&:strip)
puts <<END
#{subj}#{act}是怎么回事呢？#{subj}相信大家都很熟悉，但是#{subj}#{act}是怎么回事呢，下面就让小编带大家一起了解吧。
#{subj}#{act}，其实就是#{expl}，大家可能会很惊讶#{subj}怎么会#{act}呢？但事实就是这样，小编也感到非常惊讶。
这就是关于#{subj}#{act}的事情了，大家有什么想法呢，欢迎在评论区告诉小编一起讨论哦！
END
```

```ruby
s0 = 0.0002908882045634 # sin 1'
c0 = (1 - s0**2)**0.5
s, c = s0, c0
1.upto(5400) do |n|
    puts format("sin %2d° %2d' = %.9f", n / 60, n % 60, s)
    s = s * c0 + c * s0
    c = (1 - s**2)**0.5
end
```

以下代码来自<https://www.luogu.com.cn/record/47491997>

```ruby
module DigitDisplay
  @@d = [[], [], [], [], []]
  module_function
  def add_digit(digit)
    (0..4).each do |line|
      @@d[line].append(digit[line])
    end
  end
  def to_s
    @@d.map { |l| l.join(".") }.join("\n")
  end
end

gets # skip first line of input (number of digits)
gets.chomp.each_char do |char|
    DigitDisplay.add_digit(
        case char
        when "0" then ["XXX", "X.X", "X.X", "X.X", "XXX"]
        when "1" then ["..X", "..X", "..X", "..X", "..X"]
        when "2" then ["XXX", "..X", "XXX", "X..", "XXX"]
        when "3" then ["XXX", "..X", "XXX", "..X", "XXX"]
        when "4" then ["X.X", "X.X", "XXX", "..X", "..X"]
        when "5" then ["XXX", "X..", "XXX", "..X", "XXX"]
        when "6" then ["XXX", "X..", "XXX", "X.X", "XXX"]
        when "7" then ["XXX", "..X", "..X", "..X", "..X"]
        when "8" then ["XXX", "X.X", "XXX", "X.X", "XXX"]
        when "9" then ["XXX", "X.X", "XXX", "..X", "XXX"]
        end
    )
end

puts DigitDisplay
```

## C++

以下代码来自<https://www.luogu.com.cn/record/40823805>

```cpp
#include <iostream>
using namespace std;

const int dim = 16384;
int a[dim], b[dim], g[dim], k[dim];
int n;
int x, y;

int main() {
  cin >> n;
  
  int i;
  for (i = 1; i <= n; ++i)
    cin >> a[i] >> b[i] >> g[i] >> k[i];
  
  cin >> x >> y;
  for (i = n; i > 0; --i)
    if (x >= a[i] && x <= a[i] + g[i] &&
      y >= b[i] && y <= b[i] + k[i]) {
      cout << i << endl;
      return 0;
    }
  cout << -1 << endl;
  return 0;
}
```
