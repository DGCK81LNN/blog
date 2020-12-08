---
title: "哔哩哔哩API详解"
---

此页面正在重新排版中，部分内容尚不能正常显示

API输出结果中无法理解/重复出现的信息已删去

### 格式示例

节点格式：<span style="border:1px solid black">类型 `键`: 说明</span>

类型：N=数字 S=字符串 B=布尔值 A=数组 O=对象

<div class="soultree"></div>

* O: 根对象
    * N `code`: 一个数字
    * A `data`: 出现数组时，只举其中一项为例
        * O: 数组里的一个对象
            * S `name`: 一个字符串
    * B `status`: 一个布尔值

如果某个节点的说明后面标有“（?）”标记，表示这段说明只是笔者的猜测，如有错误欢迎在评论区指出

### 通用报错格式

未特殊说明的API均使用以下格式报错：

<div class="soultree"></div>

* O: 根对象
    * N `code`: 错误代码，没有错误则为0
    * S `message`: 错误信息
    * O `data`: 正文

有时`message`会变成`msg`

## 主站

### 视频信息

#### 视频基本信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| <del>[刻在DNA里的BV号](https://zh.moegirl.org/刻在DNA里的oo)</del> [BV17x411w7KC](https://zh.moegirl.org/Av170001#视频)
| [查看](https://www.bilibili.com/video/BV17x411w7KC) [查询](https://api.bilibili.com/x/web-interface/view?bvid=BV17x411w7KC)
|-
| [av106](https://zh.moegirl.org/最终鬼畜蓝蓝路)
| [查看](https://www.bilibili.com/video/av106) [查询](https://api.bilibili.com/x/web-interface/view?aid=106)
|-
|colspan=2 | * 查看 = 在哔哩哔哩查看，查询 = 调用这个API
|}
```
https://api.bilibili.com/x/web-interface/view?bvid=【BV号】
https://api.bilibili.com/x/web-interface/view?aid=【AV号】
```

<div class="soultree"></div>

* O: 根对象
    * O `data`
        * S `bvid`: BV号
        * N `aid`: AV号
        * N `videos`: 分P数量
        * S `tname`: 分区名
        * N `copyright`: 类型 1自制 2转载
        * S `pic`: 封面URL
        * S `title`: 标题
        * N `pubdate`: 发布时间 <br> （时间未特殊说明的一律是1574695956这样的时间戳）
        * N `ctime`: 过审时间
        * S `desc`: 简介
        * N `duration`: 时长 <br> （时长未特殊说明的一律按秒计算，后略）
        * O `rights`: 视频属性
            * N `download`: 是否允许缓存（版权限制）（0=不允许 1=允许）
            * N `movie`: 是否是电影（0=否 1=是）
            * N `pay`: 是否仅限大会员观看（0=否 1=是）
            * N `no_reprint`: 是否显示“未经作者授权，禁止转载”字样（0=不显示 1=显示）
            * N `is_cooperation`: 是否是联合投稿（0=否 1=是）
        * O `owner`: UP主信息
            * N `mid`: UID
            * S `name`: 昵称
            * S `face`: 头像URL
        * O `stat`: 统计数据
            * N `view`: 播放量
            * N `danmaku`: 弹幕数
            * N `reply`: 评论数
            * N `favorite`: 收藏数
            * N `coin`: 硬币数
            * N `share`: 转发数
            * N `now_rank`: 全站排行（没有的为0）
            * N `his_rank`: 历史最高全站排行（没有的为0）
            * N `like`: 点赞数
        * S `dynamic`: 动态内容
        * A `pages`: 分P列表
            * O
                * N `page`: 序号
                * S `part`: 标题
                * N `duration`: 时长
        * A `staff`: 联合投稿信息（非联合投稿没有此节点）
            * O
                * N `mid`: UID
                * S `title`: 类型描述，如“UP主”“参演”“后期”
                * S `name`: 昵称
                * S `face`: 头像URL
                * O `vip`: 大会员状态
                    * N `type`: 0非大会员 1大会员 2年度大会员
                * O `official`: bilibili认证信息
                    * N `type`: -1无 0个人认证 1机构认证
                    * S `title`: 认证说明
                * N `follower`: 关注数

#### 视频标签

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| <del>[刻在DNA里的BV号](https://zh.moegirl.org/刻在DNA里的oo)</del> [BV17x411w7KC](https://zh.moegirl.org/Av170001#视频)
| [查看](https://www.bilibili.com/video/BV17x411w7KC) [查询](https://api.bilibili.com/x/tag/archive/tags?bvid=BV17x411w7KC)
|-
| av107<ref>最终[鬼畜](https://zh.moegirl.org/鬼畜)[芙兰朵露](https://zh.moegirl.org/芙兰朵露·斯卡蕾特)</ref>
| [查看](https://www.bilibili.com/video/av107) [查询](https://api.bilibili.com/x/tag/archive/tags?aid=107)
|-
|colspan=2| <references />
|}
```
https://api.bilibili.com/x/tag/archive/tags?bvid=【BV号】
https://api.bilibili.com/x/tag/archive/tags?aid=【AV号】
```

<div class="soultree"></div>

* O: 根对象
    * A `data`
        * O
            * N `tag_id`: 标签ID
            * S `tag_name`: 标签名
            * S `cover`: 标签图标
            * S `head_cover`: 标签封面
            * S `content`: 标签简介
            * S `short_content`: 短简介
            * O `count`
                * N `atten`: 订阅数

### 收藏夹信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| ml829913747
| [查看](https://www.bilibili.com/medialist/detail/ml829913747) [查询](https://api.bilibili.com/x/v3/fav/resource/list?media_id=829913747&pn=1&ps=20)
|}
```
https://api.bilibili.com/x/v3/fav/resource/list?media_id=【ML号】&pn=【页码】&ps=【每页几个】
```

页码未特殊说明的均从1开始

<div class="soultree"></div>

* O: 根对象
    * O `data`
        * O `info`: 收藏夹基本信息
            * N `id`: ML号
            * N `mid`: 创建者UID
            * S `title`: 收藏夹名
            * S `cover`: 收藏夹封面
            * O `upper`: UP主信息
                * N `mid`: 创建者UID
                * S `name`: 创建者昵称
                * S `face`: 创建者头像
            * N `attr`: 属性 <br> 0=普通 9=已被UP主删除 16=互动视频 待补充……
            * O `cnt_info`: 统计数据
                * N `collect`: 收藏数
                * N `play`: 播放数
                * N `thumb_up`: 点赞数
                * N `share`: 转发数
            * S `intro`: 简介
            * N `ctime`: 创建时间
            * N `mtime`: 修改时间<!--
            * `state`: 0,
            * `fav_state`: 0,
            * `like_state`: 0,-->
            * N `media_count`: 视频数量
        * A `medias`: 收藏夹内容
            * O
                * N `id`: AV号
                * S `title`: 标题
                * S `cover`: 封面
                * S `intro`: 简介
                * N `page`: 分P数
                * N `duration`: 时长
                * O `upper`: UP主信息
                    * N `mid`: UID
                    * S `name`: 昵称
                * O `cnt_info`: 统计数据
                    * N `collect`: 收藏数
                    * N `play`: 播放数
                    * N `danmaku`: 弹幕数
                * N `ctime`: 过审时间
                * N `pubtime`: 发布时间
                * N `fav_time`: 收藏时间
                * S `bvid`: BV号

### 专栏信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| cv3593887
| [查看](https://www.bilibili.com/read/cv3593887) [查询](https://api.bilibili.com/x/article/view?id=3593887)
|}
```
https://api.bilibili.com/x/article/view?id=【CV号】
```

* O: 根对象
    * O `data`
        * N `id`: CV号
        * O `category`: 分区
            * N `id`: 分区ID
            * N `parent_id`: 父分区的ID（顶级分区为0）
            * S `name`: 分区名
        * A `categories`: 详细分区信息（两级，一个父分区一个子分区）
            * O
                * N `id`
                * N `parent_id`
                * S `name`
        * S `title`: 标题
        * S `summary`: 预览
        * S `banner_url`: 头图URL
        * O `author`: UP主信息
            * N `mid`: UID
            * S `name`: 昵称
            * S `face`: 头像URL
            * O `pendant`: 头像挂件信息
            * O `official_verify`: bilibili认证信息
            * O `nameplate`
            * O `vip`: 大会员信息
        * B `original`: 是否为原创（?）
        * N `reprint`: 是否允许规范转载（?）
        * A `image_urls`: 封面列表（最多三个）
            * S: 封面URL
        * A `origin_image_urls`: 封面原图列表（最多三个）
            * S: 封面原图URL
        * N `publish_time`: 发布时间
        * N `ctime`: 过审时间（?）
        * O `stats`: 统计数据
            * N `view`: 阅读数
            * N `favorite`: 收藏数
            * N `like`: 点赞数
            * N `reply`: 评论数
            * N `share`: 分享数
            * N `coin`: 硬币数
        * A `tags`: 标签列表
            * O
                * N `tid`: 标签ID
                * S `name`: 标签名
        * N `words`: 字数
        * S `dynamic`: 动态内容
        * O `list`: 所属文集信息
            * N `id`: ML号
            * N `mid`: UP主UID
            * S `name`: 标题
            * S `image_url`: 封面URL
            * N `update_time`: 更新时间
            * N `ctime`: 过审时间（?）
            * N `publish_time`: 发布时间
            * S `summary`: 简介
            * N `words`: 字数
        * S `content`: 专栏正文HTML <br> 注意，里面的图片URL似乎都是`//`开头的，所以如果你要在没有HTTPS的网站上把正文显示出来，请把`src="//`替换成`src="https://`。 <br> 还有，为了降低违和感，建议加上[这个样式表](https://s1.hdslb.com/bfs/static/jinkela/article/pcDetail.90443ecd539e7e8e5ae3a0f3e4326fd747e08d71.css)，背景色改成`#f2f2f2`，并把正文放在一个`<div class="article-holder">`里。
        * S `keywords`: 从原文中随机抓取的关键词，半角逗号（“,”）分隔

### 专栏文集信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| rl154835
| [查看](https://www.bilibili.com/read/readlist/rl154835) [查询](https://api.bilibili.com/x/article/list/web/articles?id=154835)
|}
```
https://api.bilibili.com/x/article/list/web/articles?id=【RL号】
```

* O: 根对象
    * O `data`
        * O `list`: 文集基本信息
            * N `id`: RL号
            * N `mid`: UP主UID
            * S `name`: 文集标题
            * S `image_url`: 封面URL
            * N `update_time`: 更新时间
            * N `ctime`: 创建时间（?）
            * N `publish_time`: 发布时间
            * S `summary`: 简介
            * N `words`: 字数
            * N `read`: 阅读数
            * N `articles_count`: 篇数
        * O `author`: UP主信息
            * N `mid`: UID
            * S `name`: 昵称
            * S `face`: 头像URL
            * O `pendant`: 头像挂件信息
            * O `official_verify`: bilibili认证信息
            * O `nameplate`
            * O `vip`: 大会员信息
        * A `articles`: 文集中的文章
            * O
                * N `id`: CV号
                * S `title`: 标题
                * N `publish_time`: 发布时间
                * N `words`: 字数
                * A `image_urls`: 封面列表（最多三个）
                    * S: 封面URL
                * O `category`: 分区
                    * N `id`: 分区ID
                    * N `parent_id`: 父分区的ID（顶级分区为0）
                    * S `name`: 分区名
                * A `categories`: 详细分区信息（两级，一个父分区一个子分区）
                    * O
                        * N `id`
                        * N `parent_id`
                        * S `name`
                * S `summary`: 预览文本
                * O `stats`: 统计数据
                    * N `view`: 阅读数
                    * N `favorite`: 收藏数
                    * N `like`: 点赞数
                    * N `reply`: 评论数
                    * N `share`: 转发数
                    * N `coin`: 硬币数
        * O `last`: 文集中的最新一篇文章（格式同上）

### 搜索

待补充……

## 旧版VC小视频

目前新投稿的小视频将进入主站，VC小视频似乎已经弃用。

#### 小视频信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| vc1919810
| [查看](https://vc.bilibili.com/video/1919810) [查询](https://api.vc.bilibili.com/clip/v1/video/detail?video_id=1919810)
|-
|colspan=2| <del>这么臭的vlog还有存在的必要么<br>删了罢（无慈悲）</del>
|}
```
https://api.vc.bilibili.com/clip/v1/video/detail?video_id=VC号
```

* O: 根对象
    * O `data`
        * O `user`: UP主信息
            * N `uid`: UID
            * S `head_url`: 头像
            * S `name`: 昵称
            * N `is_vip`: 大会员状态（0=非大会员 1=大会员 2=年度大会员）
            * N `upload_count`: 该用户上传的VC小视频数量
        * O `item`: 视频信息
            * N `id`: VC号
            * O `cover`
                * S `default`: 封面URL
            * S `first_pic`: 视频初始画面截图（?）
            * S `description`: 简介
            * A `tags`: 标签列表
                * S: 标签名
            * N `video_time`: 时长
            * S `upload_time`: 发布时间字符串（格式：年年年年-月月-日日 时时:分分:秒秒）
            * N `width`: 视频宽度
            * N `height`: 视频高度
            * S `at_control`: 视频简介里艾特的其他用户的信息JSON（?） <br> 由于考古过程中还没找到在简介里艾特了其他人的小视频，此项的格式尚不明确
            * N `watched_num`: 播放数
            * N `reply`: 评论数
            * S `video_playurl`: 视频URL
            * A `backup_playurl`: 视频备用URL列表
                * S

## 哔哩哔哩音乐

### 音频信息

#### 音频基本信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| au1281641
| [查看](https://www.bilibili.com/audio/au1281641) [查询](https://www.bilibili.com/audio/music-service-c/web/song/info?sid=1281641)
|}
```
https://www.bilibili.com/audio/music-service-c/web/song/info?sid=【AU号】
```

注意，此API的返回值被强制gzip压缩，如果使用cURL等方式获取，记得设置解码：
```
curl_setopt($curl, CURLOPT_ENCODING, 'gzip');
```
* O: 根对象
    * O `data`
        * N `id`: AU号
        * N `uid`: UP主UID
        * S `uname`: UP主昵称
        * S `title`: 标题
        * S `cover`: 封面URL
        * O `vipInfo` :
            * `type`: 0非大会员 1大会员 2年度大会员
        * S `intro`: 简介
        * S `lyric`: 歌词
        * N `duration`: 时长
        * N `passtime`: 过审时间（?）
        * N `curtime`: 最近修改时间（?）
        * N `aid`: 链接视频AV号
        * S `bvid`: 链接视频BV号
        * O `statistic`: 统计数据
            * N `play`: 播放数
            * N `collect`: 收藏数
            * N `comment`: 评论数
            * N `share`: 转发数
        * N `coin_num`: 硬币数（?）

#### 音频所属合辑

### 歌单信息

待补充……

### 音乐人信息

待补充……

#### 音乐人基本信息

#### 音乐人统计数据

#### 音乐人热门歌曲

## 个人空间

### 首页

#### 用户基本信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747) [查询](https://api.bilibili.com/x/space/acc/info?mid=328066747)
|}
```
https://api.bilibili.com/x/space/acc/info?mid=【UID】
```

* O: 根对象
    * O `data`:
        * `mid`: UID
        * `name`: 昵称
        * `sex`: 性别（男/女/保密）
        * `face`: 头像
        * `sign`: 个签
        * `level`: 等级（1~6）
        * `birthday`: 生日，格式：月月-日日
        * `coins`: 硬币数
        * `fans_badge`: 是否开通粉丝勋章
        * O `official`: （bilibili认证）
            * `type`: -1无 0个人认证 1机构认证
            * `title`: 认证说明
        * O `vip`:
            * `type`: 0非大会员 1大会员 2年度大会员
        * `top_photo`: 头图
<hr>
前方各种用户信息API大全轰炸预警！

#### 好友数

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747) [查询](https://api.bilibili.com/x/relation/stat?vmid=328066747)
|}
```
https://api.bilibili.com/x/relation/stat?vmid=【UID】
```

* O: 根对象
    * `data`:{
        * `mid`: UID
        * `following`: 关注数
        * `whisper`: 悄悄关注数
        * `black`: 黑名单数
        * `follower`: 粉丝数

#### UP主统计数据

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747) [查询](https://api.bilibili.com/x/space/upstat?mid=328066747)
|}
```
https://api.bilibili.com/x/space/upstat?mid=【UID】
```

* O: 根对象
    * O `data`:
        * O `archive`:
            * `view`: 视频播放量
        * O `article`:
            * `view`: 专栏阅读量
        * `likes`: 视频、动态、专栏累计获赞

#### UP主置顶视频（粉丝可见）

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747) [查询](https://api.bilibili.com/x/space/top/arc?vmid=328066747)
|}
```
https://api.bilibili.com/x/space/top/arc?vmid=【UID】
```

* O: 根对象
    * O `data`:
        * `aid`: AV号
        * `videos`: 分P数
        * `tname`: 分区名
        * `copyright`: 类型 1自制 2转载
        * `pic`: 封面
        * `title`: 标题
        * `pubdate`: 发布时间
        * `ctime`: 过审时间
        * `desc`: 简介
        * `duration`: 时长
        * O `owner`:
            * `mid`: UID
            * `name`: UP主昵称
            * `face`: UP主头像
        * O `stat`:
            * `view`: 播放数
            * `danmaku`: 弹幕数
            * `reply`: 评论数
            * `favorite`: 收藏数
            * `coin`: 硬币数
            * `share`: 转发数
            * `like`: 点赞数
        * `dynamic`: 动态文本
        * `bvid`: BV号
        * `reason`: 置顶理由

#### UP主代表作（访客可见）

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747) [查询](https://api.bilibili.com/x/space/masterpiece?vmid=328066747)
|}
```
https://api.bilibili.com/x/space/masterpiece?vmid=【UID】
```

* O: 根对象
    * A `data`: （代表作可以有3个）
        * O
            * `aid`: AV号
            * `videos`: 分P数
            * `tname`: 分区
            * `copyright`: 1自制 2转载
            * `pic`: 封面
            * `title`: 标题
            * `pubdate`: 发布时间
            * `ctime`: 过审时间
            * `desc`: 简介
            * `duration`: 时长
            * O `owner`:
                * `mid`: UID
                * `name`: UP主昵称
                * `face`: 头像
            * O `stat`:
                * `view`: 播放数
                * `danmaku`: 弹幕数
                * `reply`: 评论数
                * `favorite`: 收藏数
                * `coin`: 硬币数
                * `share`: 转发数
                * `like`: 点赞数
            * `dynamic`: 动态文本
            * `bvid`: BV号

### 动态

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/dynamic) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/space_history?host_uid=328066747&offset_dynamic_id=0&need_top=1)
|}
```
https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/space_history?host_uid=【UID】&offset_dynamic_id=【从哪条开始，0为从最新的开始】&need_top=【是否包含置顶动态，1=输出，0=不输出】
```

* O : 根对象
    * O `data`
        * N `has_more`: 是否还有下一页（1=有 0=没有）
        * A `cards`
            * O
                * O `desc`: 
                    * N `uid`: 发送者UID
                    * N `type`: 动态类型（详见[[#动态详情]]）
                    * N `view`: 阅读数
                    * N `repost`: 转发数
                    * N `comment`: 评论数
                    * N `like`: 点赞数
                    * N `timestamp`: 发布时间
                    * N `orig_type`: 所转发的原动态号（仅转发动态）
                    * O `user_profile`: UP主信息
                        * O `info`: 基本信息
                            * N `uid`: UID
                            * S `uname`: 昵称
                            * S `face`: 头像
                        * O `card`
                            * O `official_verify`: bilibili认证信息
                                * N `type`: -1无 0个人认证 1机构认证
                                * S `desc`: 认证说明
                        * O `vip`: 大会员信息
                            * N `type`: （0=非大会员 1=大会员 2=年度大会员）
                        * S `sign`: 个签
                        * O `level_info`
                            * N `current_level`: 等级（1~6）
                    * N `dynamic_id`: 动态号
                    * S `dynamic_id_str`: 动态号字符串
                    * N `orig_dy_id`: 所转发的原动态号
                    * S `orig_dy_id_str`: 所转发的原动态号字符串
                    * N `rid`: OID（详见[[#评论区通用]]）
                    * S `rid_str`: OID（详见[[#评论区通用]]）字符串 <br> 动态号是18位数，很遗憾JavaScript最大整数是**900,719,925,474,092**，18位数会强行变成浮点，故提供了字符串形式的动态号
                * S `card`: 动态卡片JSON（详见[[#动态详情]]）
                * S `extend_json`: 附加信息（详见[[#动态详情]]）
                * O `extra`
                    * N `is_space_top`: 是否是置顶动态（1=是 0=不是）
                * O `display`
                    * O `like_info`: ×××赞了
                        * A `like_users`
                            * O
                                * N `uid`: 点赞的人UID
                                * S`uname`: 点赞的人昵称
        * N `next_offset`: 下一页第一条的动态号 <br> 等等，明明动态号是18位数，这里为什么不给动态号字符串？？？ <br> （实测

### 投稿

#### 视频

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/video) [查询](https://api.bilibili.com/x/space/arc/search?mid=328066747&pn=1&ps=20)
|}
```
https://api.bilibili.com/x/space/arc/search?mid=【UID】&pn=【页码】&ps=【每页几个】&tid=【分区号，省略此参数则显示所有分区】
```

* O: 根对象
    * `code`: 0,
    * `message`: "0",
    * `ttl`: 1,
    * O `data`:
        * O `list`:
            * O `tlist`: （UP主各个分区的视频数量）
                * O 分区号:
                    * `tid`: 分区号
                    * `count`: UP主该分区的视频数量
                    * `name`: 分区名
            * A `vlist`:
                * O
                    * `comment`: 评论数
                    * `play`: 播放数
                    * `pic`: 封面
                    * `description`: 简介
                    * `title`: 标题
                    * `author`: UP主昵称
                    * `mid`: UID
                    * `created`: 发布时间
                    * `length`: 视频时长字符串，格式：分分:秒秒 或 时:分分:秒秒
                    * `aid`: AV号
                    * `bvid`: BV号
                    * `is_union_video`: 是否是联合创作，1是，0否
        * O `page`:
            * `count`: 页数
            * `pn`: 页码
            * `ps`: 每页视频数量

#### 音频

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/audio) [查询](https://api.bilibili.com/audio/music-service/web/song/upper?uid=328066747&pn=1&ps=20&order=1)
|}
```
https://api.bilibili.com/audio/music-service/web/song/upper?uid=【UID】&pn=【页码】&ps=【每页几个】&order=【排序，1(默认)发布时间，2播放量】
```

* O: 根对象
    * O `data`:
        * `curPage`: 页码
        * `pageCount`: 页数
        * `totalSize`: 稿件总数
        * `pageSize`: 每页稿件数量
        * A `data`:
            * O
                * `id`: AU号
                * `uid`: UP主UID
                * `uname`: UP主昵称
                * `title`: 标题
                * `cover`: 封面
                * `lyric`: 歌词
                * `duration`: 时长
                * `passtime`: 发布时间
                * O `statistic`:
                    * `sid`: AU号
                    * `play`: 播放数
                    * `collect`: 收藏数
                    * `comment`: 评论数
                    * `share`: 转发数

#### 专栏

##### 文章

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/article) [查询](https://api.bilibili.com/x/space/article?mid=328066747&pn=1&ps=20&sort=publish_time)
|}
```
https://api.bilibili.com/x/space/article?mid=【UID】&pn=【页码】&ps=【每页几个】&sort=【排序，默认为publish_time，其他可能的值待研究……】
```

* O: 根对象
    * O `data`:
        * A `articles`:
            * O
                * `id`: CV号
                * O `category`:
                    * `name`: 分区
                * A `categories`: （标签列表）
                    * O
                        * `name`: 标签名
                * `title`: 标题
                * `summary`: 预览文本
                * `banner_url`: 封面
                * O `author`:
                    * `mid`: UP主UID
                    * `name`: UP主昵称
                    * `face`: UP主头像
                    * O `vip`:
                        * `type`: 0非大会员 1大会员 2年度大会员
                * A `image_urls`: （头图列表）
                    *头图URL
                * `publish_time`: 发布时间
                * `ctime`: 过审时间
                * O `stats`:
                    * `view`: 阅读数
                    * `favorite`: 收藏数
                    * `like`: 点赞数
                    * `reply`: 评论数
                    * `share`: 转发数
                    * `coin`: 硬币数
                * `words`: 字数
                * A `origin_image_urls`: （头图原图列表）
                    *头图原图URL
                * `original`: 1原创 0非原创
        * `pn`: 页码
        * `ps`: 每页项数
        * `count`: 页数

##### 文集

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/article) [查询](https://api.bilibili.com/x/article/up/lists?mid=328066747&sort=0)
|}
```
https://api.bilibili.com/x/article/up/lists?mid=【UID】&sort=【排序 0发布时间 1阅读量】
```

* O: 根对象
    * O `data`:
        * A `lists`:
            * O
                * `id`: RL号
                * `mid`: UP主UID
                * `name`: UP主昵称
                * `image_url`: 封面URL
                * `update_time`: 修改时间
                * `ctime`: 过审时间
                * `summary`: 简介
                * `words`: 字数
                * `read`: 阅读量
                * `articles_count`: 篇数
        * `total`: 文集总数

#### 相簿

##### 各分区投稿数量统计

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/album) [查询](https://api.vc.bilibili.com/link_draw/v1/doc/upload_count?uid=328066747)
|}
```
https://api.vc.bilibili.com/link_draw/v1/doc/upload_count?uid=【UID】
```

* O: 根对象
    * O `data`:
        * `all_count`: 相册投稿总数
        * `draw_count`: 绘画区稿件数
        * `photo_count`: 摄影区稿件数
        * `daily_count`: 日常区稿件数

##### 全部相簿投稿

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/album) [查询](https://api.vc.bilibili.com/link_draw/v1/doc/doc_list?uid=328066747&page_num=0&page_size=20)
|}
```
https://api.vc.bilibili.com/link_draw/v1/doc/doc_list?uid=【UID】&page_num=【页码（从0开始）】&page_size=【每页几个】
```

* O: 根对象
    * O `data`:
        * A `items`:
            * O
                * `doc_id`: 相册投稿号
                * `poster_uid`: UID
                * `title`: 标题
                * `description`: 简介
                * A `pictures`:
                    * O
                        * `img_src`: 图片URL
                        * `img_width`: 图片宽度
                        * `img_height`: 图片高度
                        * `img_size`: 图片大小（KB）
                * `count`: 图片数量
                * `ctime`: 发布时间
                * `view`: 查看数
                * `like`: 点赞数

### 频道

#### 频道基本信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/channel/index) [查询](https://api.bilibili.com/x/space/channel/list?mid=328066747)
|}
```
https://api.bilibili.com/x/space/channel/list?mid=【UID】
```

* O: 根对象
    * O `data`:
        * `count`: 频道数量
        * A `list`:
            * O
                * `cid`: 频道号
                * `mid`: UID
                * `name`: 频道名
                * `intro`: 频道简介
                * `mtime`: 创建时间
                * `count`: 视频数量
                * `cover`: 封面

#### 频道内容

待补充…………

### 收藏

#### 创建的收藏夹

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/favlist) [查询](https://api.bilibili.com/x/v3/fav/folder/created/list-all?up_mid=328066747)
|}
```
https://api.bilibili.com/x/v3/fav/folder/created/list-all?up_mid=【UID】
```

* O: 根对象
    * O `data`:
        * `count`: 收藏夹数量
        * A `list`:
            * O
                * `id`: 收藏夹ML号
                * `mid`: UID
                * `title`: 收藏夹名
                * `media_count`: 视频数

#### 收藏的收藏夹

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/favlist) [查询](https://api.bilibili.com/x/v3/fav/folder/collected/list?pn=1&ps=20&up_mid=328066747)
|}
```
https://api.bilibili.com/x/v3/fav/folder/collected/list?pn=【页码】&ps=【每页几个】&up_mid=【UID】
```

* O: 根对象
    * O `data`:
        * `count`: 收藏的收藏夹数量
        * A `list`:
            * O
                * `id`: 收藏夹ML号
                * `mid`: 创建者UID
                * `title`: 收藏夹名
                * O `upper`:
                    * `mid`: 创建者UID
                    * `name`: 创建者昵称
                * `intro`: 简介
                * `ctime`: 创建时间
                * `media_count`: 视频数量

### 订阅

#### 追番追剧

{|class="wikitable" style="float:right"
|-
!colspan=3| 栗子
|-
|rowspan=2| uid328066747
| 追番
| [查看](https://space.bilibili.com/328066747/bangumi) [查询](https://api.bilibili.com/x/space/bangumi/follow/list?type=1&pn=1&ps=20&vmid=328066747)
|-
| 追剧
| [查看](https://space.bilibili.com/328066747/cinema) [查询](https://api.bilibili.com/x/space/bangumi/follow/list?type=2&pn=1&ps=20&vmid=328066747)
|}
```
https://api.bilibili.com/x/space/bangumi/follow/list?type=【1追番 2追剧】&pn=【页码】&ps=【每页几个】&vmid=【UID】
```

* O: 根对象
    * O `data`:
        * A `list`:
            * O
                * `season_id`: 番剧SS号
                * `media_id`: 番剧MD号
                * `season_type_name`: 番剧类型（字符串）
                * `title`: 番剧标题
                * `cover`: 封面
                * `total_count`: 共几话
                * `is_finish`: 1完结 0未完结
                * O `stat`:
                    * `follow`: 追番数
                    * `view`: 播放数
                    * `danmaku`: 弹幕数
                    * `reply`: 评论数
                    * `coin`: 硬币数
                    * `series_follow`: 系列总追番数
                    * `series_view`: 系列总播放量
                * O `new_ep`: （最新剧集）
                    * `id`: 剧集EP号
                    * `index_show`: 更新状态（字符串）
                    * `cover`: 封面
                    * `title`: 短标题
                    * `long_title`: 完整标题
                    * `pub_time`: 发布时间 格式：年年年年-月月-日日 时时:分分:秒秒
                    * `duration`: 时长（毫秒）
                * O `rating`:
                    * `score`: 评分（满分10）
                    * `count`: 评价数
                * `square_cover`: 正方形封面
                * `season_title`: 本季在系列中的描述（如“第一季”）
                * `evaluate`: 简介开头的一段，长度超出的用“...”表示
                * A `areas`:
                    * O
                        * `name`: 制作国（如“美国”）
                * `first_ep`: 第一集EP号
                * O `series`:
                    * `series_id`: 系列号
                    * `title`: 系列名
                    * `season_count`: 季数
                    * `new_season_id`: 最新一季SS号
                * O `publish`:
                    * `pub_time`: 发布时间 格式：年年年年-月月-日日 时时:分分:秒秒
                    * `release_date`: 发布日期 格式：年年年年-月月-日日
                * `progress`: 观看进度，如“看到第1话”
        * `pn`: 页码
        * `ps`: 每页项数
        * `total`: 页数

番剧SS号、MD号，剧集EP号这三种神秘的番号，我暂时还没有研究明白，，，，恕不作讲解

#### 话题

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| uid328066747
| [查看](https://space.bilibili.com/328066747/subs) [查询](https://space.bilibili.com/ajax/tags/getSubList?mid=328066747)
|}
```
https://space.bilibili.com/ajax/tags/getSubList?mid=【UID】
```

此API的报错格式不是通用格式

* O: 根对象
    * `status`: 是否查询成功
    * O `data`:
        * A `tags`:
            * `name`: 话题名
            * `cover`: 话题封面（可能为空）
            * `tag_id`: 话题号
    * `count`: 话题数量

### 关注/粉丝列表

{|class="wikitable" style="float:right"
|-
!colspan=3| 栗子
|-
|rowspan=2| uid328066747
| 关注
| [查看](https://space.bilibili.com/328066747/fans/follow) [查询](https://api.bilibili.com/x/relation/followings?vmid=328066747&pn=1&ps=20&order=desc)
|-
| 粉丝
| [查看](https://space.bilibili.com/328066747/fans/fans) [查询](https://api.bilibili.com/x/relation/followers?vmid=328066747&pn=1&ps=20&order=desc)
|}

关注：`https://api.bilibili.com/x/relation/followings?vmid=【UID】&pn=【页码】&ps=【每页几个】&order=【排序 desc=新关注的在前 asc=新关注的在后】`

粉丝：`https://api.bilibili.com/x/relation/followers?vmid=【UID】&pn=【页码】&ps=【每页几个】&order=【排序 desc=新关注的在前 asc=新关注的在后】`

* O: 根对象
    * O `data`:
        * A `list`:
            * O
                * `mid`: UID
                * `mtime`: 关注时间
                * `special`: 1特别关注 0普通
                * `uname`: 昵称
                * `face`: 头像
                * `sign`: 个签
                * O `official_verify`:
                    * `type`: -1无认证 0个人认证 1机构认证
                    * `desc`: 认证说明
                * O `vip`:
                    * `vipType`: 0非大会员 1大会员 2年度大会员
        * `total`: 关注总数

用户信息API大全 完

## 动态

### 动态详情

{|class="wikitable" style="float:right"
|-
!colspan=4|动态类型
|-
! 类型号
! 说明
!colspan=2| 栗子
|-
| 1
| 转发动态
| 355295470145652823
| [查看](https://t.bilibili.com/355295470145652823) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=355295470145652823)
|-
| 2
| 相册投稿
| 351782199784737587
| [查看](https://t.bilibili.com/351782199784737587) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=351782199784737587)
|-
| 4
| 文字动态
| 371794999330051793
| [查看](https://t.bilibili.com/371794999330051793) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=371794999330051793)
|-
| 8
| 视频投稿
| 355292278981797225
| [查看](https://t.bilibili.com/355292278981797225) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=355292278981797225)
|-
| 16
| VC小视频投稿
| 354713888622461421
| [查看](https://t.bilibili.com/354713888622461421) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=354713888622461421)
|-
| 64
| 专栏投稿
| 334997154054634266
| [查看](https://t.bilibili.com/334997154054634266) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=334997154054634266)
|-
| 256
| 音频投稿
| 352216850471547670
| [查看](https://t.bilibili.com/352216850471547670) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=352216850471547670)
|-
| 2048
| 分享歌单
| 325805722180163707
| [查看](https://t.bilibili.com/325805722180163707) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=325805722180163707)
|-
| 4300
| 分享视频收藏夹
| 355307388674695344
| [查看](https://t.bilibili.com/355307388674695344) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=355307388674695344)
|-
|colspan=4| 待补充……也许吧……
|}
```
https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=【动态号】
```

* O
    * O `data`:
        * O `card`:
            * O `desc`:
                * `uid`: UID
                * `type`: 动态类型
                * `view`: 查看数
                * `repost`: 转发数
                * `like`: 点赞数
                * `dynamic_id`: 动态号
                * `timestamp`: 发布时间
                * O `user_profile`:
                    * O `info`:
                        * `uid`: UID
                        * `uname`: 昵称
                        * `face`: 头像URL
                    * O `card`:
                        * O `official`:
                            * `type`: -1无 0个人认证 1机构认证
                            * `desc`: 认证说明
                    * O `vip`:
                        * `vipType`: 0非大会员 1大会员 2年度大会员
                    * `sign`: 个签
                    * O `level_info`:
                        * `current_level`: 等级（1~6）
                * `dynamic_id_str`: 动态号
                * `orig_dy_id_str`: 所转发的原动态号
                * `rid_str`: OID
            * `card`: 【【动态卡片的JSON，【这是一个字符串！】 具体见下文】】
            * `extend_json`: 附加信息的JSON（投票etc），暂未研究

### 动态卡片格式

#### 转发动态

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 355295470145652823
| [查看](https://t.bilibili.com/355295470145652823) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=355295470145652823)
|}

* O: 根对象
    * O `user`:
        * `uid`: UID
        * `uname`: 昵称
        * `face`: 头像
    * O `item`:
        * `rp_id`: 动态号
        * `uid`: UID
        * `content`: 文字内容
        * `orig_dy_id`: 原动态号
        * `timestamp`: 转发时间
        * `reply`: 评论数
        * `orig_type`: 原动态类型
    * `origin`: 原动态卡片的JSON，【这是一个字符串！】
    * O `origin_user`:
        * O `info`:
            * `uid`: 原动态发布者UID
            * `uname`: 原动态发布者昵称
            * `face`: 原动态发布者头像URL
        * O `card`:
            * O `official_verify`:
                * `type`: -1无 0个人认证 1机构认证
                * `desc`: 认证说明
        * O `vip`:
            * `vipType`: 0非大会员 1大会员 2年度大会员
        * `sign`: 原动态发布者个签
        * O `level_info`:
            * `current_level`: 原动态发布者等级（1~6）

#### 相册投稿

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 351782199784737587
| [查看](https://t.bilibili.com/351782199784737587) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=351782199784737587)
|}

* O: 根对象
    * O `item`:
        * `id`: 投稿号
        * `description`: 简介
        * A `pictures`:
            * O （某张图片）
                * `img_src`: 图片URL
                * `img_width`: 图片宽度
                * `img_height`: 图片高度
        * `pictures_count`: 图片数量
        * `upload_time`: 发布时间
        * `reply`: 评论数
    * O `user`:
        * `uid`: UID
        * `head_url`: 头像
        * `name`: 昵称
        * O `card`:
            * O `official_verify`:
                * `type`: -1无 0个人认证 1机构认证
                * `desc`: 认证说明
        * O `vip`:
            * `vipType`: 0非大会员 1大会员 2年度大会员

#### 文字动态

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 371794999330051793
| [查看](https://t.bilibili.com/371794999330051793) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=371794999330051793)
|}

* O: 根对象
    * O `user`:
        * `uid`: UID
        * `uname`: 昵称
        * `face`: 头像
    * O `item`:
        * `rp_id`: 动态号
        * `content`: 动态内容
        * `timestamp`: 发布时间
        * `reply`: 评论数

#### 视频投稿

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 355292278981797225
| [查看](https://t.bilibili.com/355292278981797225) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=355292278981797225)
|}

* O: 根对象
    * `aid`: AV号
    * `copyright`: 类型 1自制 2转载
    * `desc`: 视频简介
    * `duration`: 时长
    * `dynamic`: 动态内容
    * O `owner`:
        * `face`: UP主头像
        * `mid`: UID
        * `name`: UP主昵称
    * `pic`: 封面URL
    * `pubdate`: 发布日期
    * O `stat`:
        * `coin`: 硬币数
        * `danmaku`: 弹幕数
        * `favorite`: 收藏数
        * `like`: 点赞数
        * `reply`: 评论数
        * `share`: 转发数
        * `view`: 播放数
    * `title`: 视频标题
    * `tname`: 视频分区
    * `videos`: 分P数
*
*

#### VC小视频投稿

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 354713888622461421
| [查看](https://t.bilibili.com/354713888622461421) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=354713888622461421)
|}

* O: 根对象
    * O `user`:
        * `uid`: UID
        * `head_url`: 头像URL
        * `is_vip`: 0,
        * `name`: 昵称
    * O `item`:
        * `id`: VC号
        * O `cover`:
            * `default`: 封面
            * `unclipped`: 原始宽高比封面
        * A `tags`: <br>标签列表
        * `description`: 简介
        * `video_time`: 时长
        * `upload_time`: 发布时间，格式：年年年年-月月-日日 时时:分分:秒秒
        * `video_playurl`: 视频URL
        * `reply`: 评论数
        * `watched_num`: 播放数

#### 音频投稿

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 352216850471547670
| [查看](https://t.bilibili.com/352216850471547670) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=352216850471547670)
|}


{```
id
```: AU号
**upId** : UP主UID```
title
```: 标题```
upper
```: UP主```
cover
```: 封面URL```
ctime
```: 发布时间
**replyCnt** : 评论数
**playCnt** : 播放数```
intro
```: 简介
**upperAvatar** : UP主头像URL
}

#### 分享歌单

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 325805722180163707
| [查看](https://t.bilibili.com/325805722180163707) [查询](https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail?dynamic_id=325805722180163707)
|}

* O: 根对象
    * `rid`: 动态号
    * O `user`:
        * `uid`: 歌单创建者UID
        * `uname`: 歌单创建者名称
        * `face`: 歌单创建者头像
    * O `sketch`:
        * `title`: 歌单名
        * `desc_text`: "【共曲目数量】首 | 【分区】 · 【二级分区】",
        * `cover_url`: 封面
        * `biz_type`: 歌单类型，131歌单，133合辑
        * A `tags`:
            * O （某个标签）
                * `type`: 标签号
                * `name`: 标签名
                * `color`: 标签颜色，HEX，没有井号

### 标签/话题信息

#### 话题基本信息

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 标签1
| [查看](https://t.bilibili.com/topic/name/1) [查询](https://api.bilibili.com/x/tag/info?tag_id=1)
|-
| #公告#
| [查看](https://t.bilibili.com/topic/name/%E5%85%AC%E5%91%8A) [查询](https://api.bilibili.com/x/tag/info?tag_name=公告)
|}
```
https://api.bilibili.com/x/tag/info?tag_id=【标签ID】
https://api.bilibili.com/x/tag/info?tag_name=【标签名】
```

* O: 根对象
    * O `data`
        * N `tag_id`: 标签ID
        * S `tag_name`: 标签名
        * S `cover`: 标签图标
        * S `head_cover`: 标签封面
        * S `content`: 标签简介
        * S `short_content`: 短简介
        * N `ctime`: 创建日期
        * O `count`
            * N `atten`: 订阅数

#### 话题统计数据及活跃用户列表

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 标签1
| [查看](https://t.bilibili.com/topic/name/1) [查询](https://api.vc.bilibili.com/topic_svr/v1/topic_svr/get_active_users?tag_id=1)
|-
| #公告#
| [查看](https://t.bilibili.com/topic/name/%E5%85%AC%E5%91%8A) [查询](https://api.vc.bilibili.com/topic_svr/v1/topic_svr/get_active_users?tag_name=公告)
|}
```
https://api.vc.bilibili.com/topic_svr/v1/topic_svr/get_active_users?tag_id=【标签ID】
https://api.vc.bilibili.com/topic_svr/v1/topic_svr/get_active_users?tag_name=【标签名】
```

* O: 根对象
    * O `data`
        * N `view_count`: 浏览数
        * N `discuss_count`: 讨论数
        * A `active_users`: 活跃用户列表
            * O
                * N `score`: 活跃程度，计算方式未知
                * O `user_info`: 用户基本信息
                    * N `uid`: UID
                    * S `uname`: 昵称
                    * S `face`: 头像
                    * O `official`: bilibili认证信息
                        * N `type`: -1无 0个人认证 1机构认证
                        * S `title`: 认证说明
                    * O `vip`: 大会原员信息
                        * N `vipType` : 0非大会员 1大会员 2年度大会员
                    * O `pendant`: 头像挂件信息
                        * N `pid`: 挂件ID
                        * S `name`: 挂件名
                        * S `image`: 挂件图
                    * S `sign`: 个性签名
                    * P `level_info`
                        * N `current_level`: 等级（1~6）
        * N `topic_id`: 标签ID

#### 包含话题的动态

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| 标签1
| [查看](https://t.bilibili.com/topic/name/1) [查询](https://api.vc.bilibili.com/topic_svr/v1/topic_svr/topic_new?tag_id=1)
|-
| #公告#
| [查看](https://t.bilibili.com/topic/name/%E5%85%AC%E5%91%8A) [查询](https://api.vc.bilibili.com/topic_svr/v1/topic_svr/topic_new?tag_name=公告)
|}
```
https://api.vc.bilibili.com/topic_svr/v1/topic_svr/topic_new?tag_id=【标签ID】
https://api.vc.bilibili.com/topic_svr/v1/topic_svr/topic_new?tag_name=【标签名】
```

<!--格式同[[#动态|个人空间→动态]]-->
待补充……

### 搜索用户

{|class="wikitable" style="float:right"
|-
!colspan=2| 栗子
|-
| DGCK81LNN
| [查询](https://api.vc.bilibili.com/dynamic_repost/v1/dynamic_repost/name_search?keyword=DGCK81LNN)
|}
```
https://api.vc.bilibili.com/dynamic_repost/v1/dynamic_repost/name_search?keyword=【用户名】
```

此API用于在发表动态时输入“@”后自动联想。与[[#搜索|搜索API]]不同的是，此API只能搜索昵称，并且如果昵称完全匹配，即使是一级号、二级号也能搜到。

此API的整体格式与[[#搜索|搜索API]]相同

* O: 根对象
    * N `code`: 错误代码，没有错误则为0
    * A `result`: 正文
        * O
            * S `uname`: 昵称
            * N `mid`: UID
            * S `upic`: 头像URL
            * N `rank_offset`: 这是第几条结果（?）
            * S `usign`: 个性签名
            * N `videos`: 视频数量
            * N `fans`: 粉丝数
            * N `is_upuser`: 是否是UP主（?）
            * O `official_verify`: bilibili认证信息
                * N `type`: -1无 0个人认证 1机构认证
                * S `desc`: 认证说明
            * N `level`: 等级（1~6）
            * N `gender`: 性别（1=男 2=女 3=保密）
            * A `hit_columns`: 通过哪项信息搜索到的这个结果，如`uname`表示用户名匹配。可以有多项。
                * S
            * N `is_live`: 是否正在直播（0=否 1=是）
            * N `room_id`: 直播间ID（没开通的为0）

## 评论区通用

{|class="wikitable" style="float:right"
|-
!colspan=5| 评论区类型
|-
! 类型号
! 说明
! OID
!colspan=2| 栗子
|-
| 1
| 视频投稿
| AV号
| 59671812
| [查看](https://www.bilibili.com/video/av59671812) [查询](https://api.bilibili.com/x/v2/reply?type=1&oid=59671812&pn=1)
|-
| 5
| VC小视频投稿
| VC号
| 2879073
| [查看](https://vc.bilibili.com/video/2879073) [查询](https://api.bilibili.com/x/v2/reply?type=5&oid=2879073&pn=1)
|-
| 11
| 相册投稿
| 相册投稿号
| 65916366
| [查看](https://h.bilibili.com/65916366) [查询](https://api.bilibili.com/x/v2/reply?type=11&oid=65916366&pn=1)
|-
| 12
| 专栏投稿
| CV号
| 3695898
| [查看](https://www.bilibili.com/read/cv3695898) [查询](https://api.bilibili.com/x/v2/reply?type=12&oid=3695898&pn=1)
|-
| 14
| 音频投稿
| AU号
| 1285217
| [查看](https://www.bilibili.com/audio/au1285217) [查询](https://api.bilibili.com/x/v2/reply?type=14&oid=1285217&pn=1)
|-
| 17
| 其他动态
| 动态号
| 371794999330051793
| [查看](https://t.bilibili.com/371794999330051793) [查询](https://api.bilibili.com/x/v2/reply?type=17&oid=371794999330051793&pn=1)
|-
| 19
| 音频歌单
| AM号
| 10624
| [查看](https://www.bilibili.com/audoi/am10624) [查询](https://api.bilibili.com/x/v2/reply?type=19&oid=10624&pn=1)
|-
|colspan=5| 待补充……
|}
```
https://api.bilibili.com/x/v2/reply?type=【类型】&oid=【OID】&pn=【页码】
```

* O: 根对象
    * O `data`:
        * O `page`:
            * `num`: 页码
            * `size`: 每页条数
            * `count`: 评论数（不含回复）
            * `acount`: 评论数
        * A `replies`:  （全部评论列表）
            * O   （某条评论）
                * `mid`: UID
                * `rcount`: 回复数
                * `ctime`: 发布时间
                * `like`: 点赞数
                * O `member`:
                    * `uname`: 昵称
                    * `sex`: 性别
                    * `sign`: 个签
                    * `avatar`: 头像
                    * O `level_info`:
                        * `current_level`: 等级（1~6）
                    * O `official`:
                        * `type`: -1无 0个人认证 1机构认证
                        * `desc`: 认证说明
                    * O `vip`:
                        * `vipType`: 0非大会员 1大会员 2年度大会员
                * O `content`:
                    * `message`: 评论内容
                    * A `emote`: （表情符号信息）
                        * O `[某表情名称]`:
                            * `text`: "[某表情名称]",
                                * `url`: 表情URL
                                * O `meta`:
                                    * `size`: 显示大小，1小 2大
                    * A `replies`:
                        * O:（某条回复）
                            * `mid`: UID
                            * `ctime`: 发布时间
                            * `like`: 点赞数
                            * O `member`: （同上） },
                                * O `content`:
                                    * `message`: 回复内容
                                    * `emote`: （表情符号信息，同上）
                * `hots`: 热评列表，格式同上，不能翻页，最多10条，没有热评时为null
                * O `upper`:
                    * `mid`: UP主UID
