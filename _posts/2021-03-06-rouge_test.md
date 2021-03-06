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

## Wiki Markup

以下代码来自<https://www.mywiki.cn/dgck81lnn/index.php?title=%E5%86%B0%E4%B8%8E%E7%81%AB%E4%B9%8B%E8%88%9E%E8%87%AA%E5%88%B6%E5%85%B3%E5%8D%A1%E6%96%87%E4%BB%B6%E6%A0%BC%E5%BC%8F%E5%88%86%E6%9E%90&oldid=59751>

```wiki
{| class="wikitable" style="float:right"
|-
|<html><img src="http://i.17173cdn.com/0561y4/YWxqaGBf/gamebase/screenshot/DEDPfgbnbFmcAlF.jpg" style="width:300px"></html>
截图来自网络
|}

前段时间在Steam上买了'''冰与火之舞'''。这是一款节奏类游戏，它的玩法比较独特，把音符的时值映射成了路径的夹角。（具体玩法不在此赘述。）此游戏具有内置关卡编辑器，并且可以通过Steam创意工厂分享自制关卡。

编辑器会将关卡保存为<code>.adofai</code>文件，音频和图像、视频等放在同一目录下。用文本编辑器打开<code>.adofai</code>文件，发现是JSON格式。这样就好办了，我会用树形图来表示这些数据的结构。
__NOTOC__
==格式示例==

节点格式：<span style="border:1px solid black">类型 '''键''': 说明</span>

类型：N=数字 S=字符串 A=数组 O=对象

<div class="treeview">
*O: 根对象
**N '''code''': 一个数字
**A '''settings''': 数组可能代表列表或矢量；出现列表时，只举其中一项为例
***O: 列表里的一个对象
****S '''name''': 一个字符串
</div>

注意：<code>.adofai</code>文件目前'''不使用布尔值'''，而是用字符串<code>Enabled</code>或<code>Disabled</code>代替。

==主体格式==
<div class="treeview">
*O: 根对象
**S '''pathData''': 路径信息（后文会详细讲解）
**O '''settings''': 关卡设置
***N '''version''': 格式版本号。目前的版本号是2
**: 关卡设置：
***S '''artist''': 音乐作者
***S '''song''': 标题
***S '''author''': 关卡作者
***S '''separateCountdownTime''': ？疑似未使用（<code>Enabled</code>或<code>Disabled</code>）
***S '''previewImage''': 关卡传送门图片
***S '''previewIcon''': 关卡图标
***S '''previewIconColor''': 关卡图标颜色（HEX色号不含井号）
***S '''previewSongStart''': 音乐预览开始时间（秒）
***S '''previewSongDuration''': 音乐预览持续时间（秒）
***S '''seizureWarning''': 癫痫警告（<code>Enabled</code>或<code>Disabled</code>）
***S '''levelDesc''': 关卡描述
***S '''levelTags''': 关卡标签（半角逗号分隔）
***S '''artistPermission''': 艺术家授权证明图片（相对路径）
***S '''artistLinks''': 艺术家链接
***N '''difficulty''': 难度星级（1到10的整数）
**: 歌曲设置：
***S '''songFilename''': 音乐文件（相对路径）
***N '''bpm''': 初始BPM（每旋转180°算作一拍）
***N '''volume''': 音量%
***N '''offset''': 音乐偏移量（第一次点击时音乐已播放的毫秒数）
***N '''pitch''': 音乐播放速率/音高%
***S '''hitsound''': 打拍声（可能的值：<code>Hat</code>，<code>Kick</code>，<code>Shaker</code>，<code>Sizzle</code>，<code>Chuck</code>，<code>ShakerLoud</code>，<code>None</code>）
***N '''hitsoundVolume''': 打拍声音量%
***N '''countdownTicks''': 倒数拍数
**: 初始轨道设置：
***N '''trackColorType''': 轨道颜色模式（可能的值：<code>Single</code>，<code>Stripes</code>，<code>Glow</code>，<code>Blink</code>，<code>Switch</code>，<code>Rainbow</code>）
***S '''trackColor''': 轨道色调（HEX色号不含井号；<code>Rainbow</code>模式忽略此项）
***S '''secondaryTrackColor''': 轨道副色调（HEX色号不含井号；<code>Single</code>、<code>Rainbow</code>模式忽略此项）
***: （<code>Single</code>、<code>Stripes</code>模式忽略以下三项）
***N '''trackColorAnimDuration''': 色彩动画持续时间（秒）
***S '''trackColorPulse''': 颜色脉冲类型（可能的值：<code>None</code>、<code>Forward</code>、<code>Backward</code>）
***N '''trackPulseLength''': 颜色脉冲持续时间（秒）
***S '''trackStyle''': 轨道风格（可能的值：<code>Standard</code>，<code>Neon</code>，<code>NeonLight</code>，<code>Basic</code>，<code>Gems</code>）
***S '''trackAnimation''': 轨道出现动画（可能的值：<code>None</code>，<code>Assemble</code>，<code>Assemble_Far</code>，<code>Extend</code>，<code>Grow</code>，<code>Grow_Spin</code>，<code>Fade</code>，<code>Drop</code>，<code>Rise</code>）
***N '''beatsAhead''': 方块提前几拍出现（至少为1）
***S '''trackDisappearAnimation''': 轨道消失动画（可能的值：<code>None</code>，<code>Scatter</code>，<code>Scatter_Far</code>，<code>Retract</code>，<code>Shrink</code>，<code>Shrink_Spin</code>，<code>Fade</code>）
***N '''beatsBehind''': 星球离开方块几拍后方块开始消失
**: 背景设置：
***S '''backgroundColor''': 背景颜色（HEX色号不含井号）
***S '''bgImage''': 背景图片（相对路径）
***S '''bgImageColor''': 图片上色（HEX色号不含井号）
***A '''parallax''': 背景图片随前景移动的比率%（二维矢量；例如设为[100,100]即背景和前景同步运动，[0,0]即前景移动，背景不动）
<!--"bgDisplayMode": "FitToScreen", 
"lockRot": "Disabled", 
"loopBG": "Disabled", 
"unscaledSize": 100,
"relativeTo": "Player", 
"position": [0, 0], 
"rotation": 0, 
"zoom": 100,
"bgVideo": "", 
"loopVideo": "Disabled", 
"vidOffset": 0, 
"floorIconOutlines": "Disabled", 
"stickToFloors": "Disabled", 
"planetEase": "Linear", 
"planetEaseParts": 1
-->待补完……2020年8月22日 (六) 10:48 (CST)
</div>

==路径信息==
这是一个字符串，每个字符代表一块轨道的方向。下图是字符和实际方向的对照表，例如一个字母<code>R</code>即代表向当前方块的右侧搭一个方块。

[[文件:Adofai-path-info-legend.bmp]]

360°轨道块直接用反方向的字母表示；字母后加叹号可以使这个轨道块成为中旋方块。

此外还有一些特殊方向：
* 5: 向左转72°
* 6: 向右转72°
* 7: 向左转(360/7)°
* 8: 向右转(360/7)°
注意轨道块之间的夹角必须是15°的整数倍、108°或(900/7)°，否则会有奇怪的显示bug……

==关卡事件==
待补完……2020年8月22日 (六) 10:48 (CST)

[[分类:待填坑]]

```
