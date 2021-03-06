# Rouge代码高亮测试

本站之前使用[prism.js](https://prismjs.com)进行语法高亮，近期改为直接给GitHub Pages使用的[Jekyll](https://jekyllrb.com)使用的[Kramdown](https://kramdown.gettalong.org/)使用的[Rouge](http://rouge.jneen.net/)提供样式表。

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
