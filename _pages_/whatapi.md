---
soulblog-no-not-by-ai: true
soulblog-style: |
  mark { padding: 0 }
---

# WhatAPI 文档

[WhatAPI] 是 [LNNBot] 特有的一个 Koishi 插件，它在 LNNBot 的服务器（lnnbot.哼.site）上提供了一系列 HTTP API，可以用来访问 LNNBot 中的一些数据。从 LNNBot 本机访问（如使用 WhatLang 请求）WhatAPI 时可以直接使用 `127.0.0.1` 作为主机地址。

[WhatAPI]: https://gitee.com/DGCK81LNN/lnnbot-miniplugs/blob/master/plugins/common/-lnnbot-whatapi.js
[LNNBot]: https://wiki.xdi8.top/wiki/LNNBot

## 目录

1. [WhatServer](#1-whatserver)
2. [微指令](#2-微指令)
3. [获取赞助者列表](#3-获取赞助者列表)
4. [获取旁加载字体声明](#4-获取旁加载字体声明)
5. [读取 `eval` 数据存储](#5-读取-eval-数据存储)
6. [读取 `sletscript` 虚拟文件系统](#6-读取-sletscript-虚拟文件系统)
7. [查询 bot 登录状态](#7-查询-bot-登录状态)
8. [获取全局名言列表](#8-获取全局名言列表)

## 1. WhatServer

WhatServer 是一个 [WhatLang] 运行环境，它允许您通过为 LNNBot 定义特殊的 [WhatCommands 指令] 来在服务器收到特定的 HTTP 请求时执行 WhatLang 代码。这些特殊的 WhatCommands 指令由于名称包含空格，无法直接在聊天中使用 `¿¿` 语法调用。

关于 WhatLang 的具体用法请参考 [WhatLang 文档]。

[WhatLang]: https://wiki.xdi8.top/wiki/WhatLang
[WhatCommands 指令]: https://wiki.xdi8.top/wiki/LNNBot/WhatCommands指令
[WhatLang 文档]: https://esolangs.org/wiki/WhatLang

### 1.1. 路由

WhatServer 接管 LNNBot 服务器上的所有以 `/what` 开头的 HTTP 请求，并根据请求路径调用相应的 WhatCommands 指令。`/what` 之后到下一个斜杠之间（没有斜杠则到路径末尾）的部分称为**路由名称**。

| 请求方法及路径 | WhatCommands 指令名 |
| -------------- | ------------------- |
| <code>GET /what<mark>路由名称</mark></code> | <code>server <mark>路由名称</mark></code> |
| <code>HEAD /what<mark>路由名称</mark></code> | <code>serverhead <mark>路由名称</mark></code> |
| <code>POST /what<mark>路由名称</mark></code> | <code>serverpost <mark>路由名称</mark></code> |
| <code>PUT /what<mark>路由名称</mark></code> | <code>serverput <mark>路由名称</mark></code> |
| <code>DELETE /what<mark>路由名称</mark></code> | <code>serverdelete <mark>路由名称</mark></code> |
| <code>PATCH /what<mark>路由名称</mark></code> | <code>serverpatch <mark>路由名称</mark></code> |
{: .table .w-auto}

如果请求的路由名称的所有方法指令都不存在，访问该路由时 WhatServer 会返回 `404 Not Found` 错误。当特定方法的 WhatCommands 指令不存在时，WhatServer 还会尝试调用 **<code>serverall <mark>路由名称</mark></code>** 指令；如果 <code>serverall <mark>路由名称</mark></code> 也不存在，但存在其他请求方法的指令，会返回 `405 Method Not Allowed` 错误。

例如，假设存在下列 WhatCommands 指令：

* `server foo`
* `serverall foo`
* `serverpost bar`

那么：

* 请求 `GET /whatfoo` 会调用指令 `server foo`。
* 请求 `POST /whatfoo` 会调用指令 `serverall foo`。
* 请求 `GET /whatbar` 会返回 `405 Method Not Allowed`。
* 请求 `POST /whatbar` 会调用指令 `serverpost bar`。
* 请求 `GET /whatbaz` 会返回 `404 Not Found`。

### 1.2. 输入参数

如果路径中**路由名称之后没有其他内容**，指令的输入参数为 `undef@`{: what}。如果路由名称后**有斜杠**，斜杠之后的内容将以作为一个字符串输入给指令。查询字符串（`?` 及之后的部分）不会被视为输入的一部分，需要通过 `me@`{: what} 函数读取。

例如，请求 `GET /whatfoo/some/data?query=1` 会将 `"some/data"`{: what} 作为输入传递给 `server foo` 指令；请求 `GET /whatfoo` 时，输入是 `undef@`{: what}；请求 `GET /whatfoo/` 时，输入则是空字符串。

### 1.3. 响应

WhatCommands 指令的输出将作为 HTTP 响应的正文返回。

使用 `send@`{: what} 或 `sends@`{: what} 将进行流式输出；流式输出开启后，将无法修改响应的头部信息。

指令执行过程中如果发生未被捕获的错误，将输出一个 U+000C FORM FEED 字符，后跟“UNCAUGHT”及错误信息，如果当前请求尚未开启流式输出，会返回 `500 Internal Server Error` 错误。

若未使用流式输出，指令成功执行完成后，其返回值如果是：

1. 200 到 599 的整数或其字符串表示；
2. 由上述整数的字符串表示、一个空格和至少一个字符组成的字符串（例如 `404 Not Found`）；或
3. 长度为 1 或 2 的数组，第一项满足条件 1，第二项（若存在）为字符串

（状态码的“字符串表示”必须是十进制，且不能有前导零）

则会被视为 HTTP 响应的状态码（和状态文本）返回。否则，响应状态默认为 `200 OK`。流式输出时响应状态总是 `200 OK`。

### 1.4. 内置函数和特殊变量

内置函数 `me@`{: what} 可用于获取当前请求的相关信息。仿照聊天环境下 `me@`{: what} 返回值的结构，它返回一个包含下列信息的数组：

* 索引 0（消息内容）：请求方法和 URL，包括查询字符串（例如 `GET /whatfoo/some/data?query=1`）。URL 中除 `;/?:@&=+$,#%` 以外的百分号编码字符会被解码。
* 索引 1（消息 ID）：16 位随机的小写十六进制数字
* 索引 2（用户名称）和索引 3（用户 ID）：都是请求的客户端 IP 地址
* 索引 4（用户序号）：如果请求已成功登录（见下文“用户登录”），则为当前登录的用户序号，否则为 `undef@`{: what}
* 索引 5（频道 ID）：总是 `"__WHATSERVER__"`{: what}
* 索引 6（引用的消息 ID）：总是 `undef@`{: what}

变量 `reqh^`{: what} 是一个数组，包含请求的所有头部信息，其中的每项都是一个数组，第一项为头部名称（保留原始大小写，可能重复），第二项为值。

变量 `reqm^`{: what} 存储请求的方法名称（小写字符串），例如 `get` 或 `post`。

变量 `reqb^`{: what} 存储请求的正文内容，根据请求的 `Content-Type` 头部不同，可能是字符串或字节数组，如果没有正文则为 `undef@`{: what}。

内置函数 `hset@`{: what} 接受两个字符串，设置名称为底值的头部内容为顶值。名称不区分大小写，若已存在同名头部，会覆盖原来的值。

此外，WhatServer 环境还支持下列扩展内置函数：`you@ pr@ cat@ ca@ fetch@ fech@ reesc@ sleep@ nout@ nouts@ send@ sends@ ou@`{: what}。

WhatNoter 和 WhatCommands 相关的函数也可以在 WhatServer 环境中使用，但 `notewc@ notewd@ notewe@ notere@ cmdset@ cmdsethelp@ cmdseth@ cmddel@`{: what} 只有请求成功登录时才能使用，否则会报错；`noterc@ noterd@ cmdall@ cmdget@ cmdgethelp@ cmdgeth@ cmd@`{: what} 不需要登录。

### 1.5. 用户登录

WhatServer 支持通过请求头 `X-Lnnbot-Whatserver-Login-Token` 来作为 bot 用户登录。使用浏览器在 bot 控制台登录后，使用 JavaScript 代码 `JSON.parse(localStorage.getItem("koishi.console.auth")).token`{: js} 可以获取到登录令牌，将其作为该请求头的值发送即可。令牌有一定的有效期，过期后需要重新获取。

### 1.6. 通用路由

这些已定义的 WhatServer 路由提供稳定的 API 接口，适合用来访问 LNNBot 的一些常用数据。

#### 执行 WhatLang 代码

（任意请求方法） `/what/¿{code}`

“¿”后的路径部分将作为 WhatLang 代码直接执行。

**示例：**

GET https://lnnbot.哼.site/what/¿%60Hello,%20world!%60

~~~
Hello, world!
~~~

#### 读取 WhatNoter public 或 protected note

`GET /whatnoter/{spec}`

`spec` 是用户序号后加字母 `c` 或 `d`，分别代表 public 和 protected note。

**示例：**

GET https://lnnbot.哼.site/whatnoter/0d

#### 获取 WhatCommands 指令列表

`GET /whatcommands`

返回由指令名字符串组成的 JSON 数组。

**示例：**

GET https://lnnbot.哼.site/whatcommands

#### 获取 WhatCommands 指令定义

`GET /whatcommands/{name}`

返回包含指令各属性的 JSON 对象：

* *object* 根对象
  * `name` *string* 名称
  * `code` *string* 代码
  * `h` *string* 短描述
  * `help` *string* 长帮助信息

**示例：**

GET https://lnnbot.哼.site/whatcommands/echo

~~~json
{
  "name": "echo",
  "help": "用法：¿¿echo <文本...>",
  "h": "输出给定内容",
  "code": "."
}
~~~

#### 调用 WhatCommands 指令

`GET /whatwc/{name}`  
`GET /whatwc/{name}/{arg}`

使用给定的参数调用 WhatCommands 指令，参数缺省为空。如果指令使用了 Koishi 运行时支持而 WhatServer 不支持的内置函数会报错。

**示例：**

GET https://lnnbot.哼.site/whatwc/echo/FooBar

~~~
FooBar
~~~

## 2. 微指令

此 API 可实时获取 LNNBot 上已定义的[微指令]源代码。

[微指令]: https://www.npmjs.com/package/koishi-plugin-microcommands

### 获取微指令列表

`GET /microcommands`

返回由指令名字符串组成的 JSON 数组。

**示例：**

GET https://lnnbot.哼.site/microcommands

#### 获取 WhatCommands 指令定义

`GET /microcommands/{name}`

返回指令的 JavaScript 源代码。

**示例：**

GET https://lnnbot.哼.site/microcommands/greet

## 3. 获取赞助者列表

`GET /patrons`

返回所有已登记的 LNNBot 赞助者用户序号、名称和首次登记赞助时间。响应体是一个 JSON 对象，其中以用户序号为键：

* *object* 根对象
  * `{id}` *object* 赞助者信息（键为用户序号）
    * `name` *string* 名称
    * `ctime` *string* 首次登记赞助时间（ISO 格式，UTC 时间）

## 4. 获取旁加载字体声明

`GET /lnnbot-sideload-fonts`

获取旁加载字体的声明 CSS 代码，在 LNNBot 上配合 WhatLang 的 `outhtml@`{: what}、`outsvg@`{: what} 函数用来引用旁加载字体。

**Query 参数：**

* `family` 字体族名，该参数可以指定多次。未指定时返回所有旁加载字体。

**示例：**

（此 API 只在 LNNBot 上使用才有意义，因此建议使用环回 IP 127.0.0.1）

GET http://127.0.0.1/lnnbot-sideload-fonts?family=Minecraft%20Seven%20v2&family=Unifont&family=Unifont%20CSUR

~~~css
@font-face{font-family:'Minecraft Seven v2';src:url('file:///root/koishi-app/assets/fonts/Minecraft%20Seven%20v2.ttf')}
@font-face{font-family:'Unifont CSUR';src:url('file:///root/koishi-app/assets/fonts/Unifont%20CSUR.otf')}
@font-face{font-family:'Unifont';src:url('file:///root/koishi-app/assets/fonts/Unifont.otf')}
~~~

## 5. 读取 `eval` 数据存储

`GET /eval-storage/{path*}`

以 JSON 格式获取 `eval` 指令中 `storage` 对象上的数据。`path` 指定要获取的值路径，未指定 `path` 时获取整个 `storage` 对象。

**示例：**

GET https://lnnbot.哼.site/evalstorage/musicjsX/aj

这将获取 `storage.musicjsX.aj`{: js} 的值，并以 JSON 返回。

## 6. 读取 `sletscript` 虚拟文件系统

此 API 可读取 `sletscript` 指令的虚拟文件系统。

### 列举文件夹内容

`GET /sletstorage/{path*}/`

返回一个 JSON 数组，包含指定文件夹下的所有文件和子文件夹信息：

* *array* 根数组
  * *object* 文件或子文件夹信息
    * `name` *string* 文件名
    * `type` *string* `file` 或 `directory`
    * `ctime` *string* 创建日期（ISO 格式，UTC 时间）
    * `mtime` *string* 修改日期（ISO 格式，UTC 时间）
    * `url` *string* 读取该文件或文件夹内容的 API 路径

**示例：**

GET https://lnnbot.哼.site/sletstorage/home/

~~~json
[
  {
    "name": "lnn",
    "type": "directory",
    "ctime": "2025-11-13T16:58:56.548Z",
    "mtime": "2025-12-28T08:13:56.453Z",
    "url": "/sletstorage/home/lnn/"
  }
]
~~~

### 读取文件

`GET /sletstorage/{path*}`

读取虚拟文件系统中指定的文件，直接返回文本内容。如果给定的路径是文件夹，请求会被重定向到末尾有斜杠的路径。

{:js: .highlight.language-javascript}
{:what: .highlight.language-whatlang}

## 7. 查询 bot 登录状态

`GET /api/bots`

返回一个 JSON 数组，包含当前 bot 在各平台的登录情况：

* *array* 根数组
  * *object* 登录信息
    * `adapter` *string* 适配器名称
    * `platform` *string* 平台名称
    * `status` *number* 登录状态（0=离线，1=在线，2=连接中，3=断开中，4=重连中）
    * `user` *object* 机器人账号信息
      * `id` *string* 账号 ID
      * `name` *string* 用户名
      * `avatar` *string* 头像 URL

## 8. 获取全局名言列表

`GET /api/says`

获取 says 功能的全局名言列表。返回一个 JSON 对象：

* *object* 根对象
  * `data` *array* 名言列表
    * *object* 名言信息
      * `id` *string* 名言 ID
      * `author` *string* 作者昵称（对于匿名名言为 `null`{: js}）
      * `gid` *string* 来源平台及群组 ID（对于早期未记录来源群组的名言，为空字符串）
      * `ctime` *string* 创建时间（ISO 格式，UTC 时间；对于早期未记录创建时间的名言，为 `null`{: js}）
      * `content` *string* 名言内容
  * `next` *string* 获取下一页结果的 `next` 参数值，如果没有下一页则无此属性

**Query 参数：**

* `order` 排序方式，`asc`（从旧到新）或 `desc`（从新到旧），默认为 `asc`
* `limit` 每页结果数量，默认为 20，最大为 500
* `next` 起始 ID，配合 `order` 参数使用以进行翻页

**示例：**

GET https://lnnbot.哼.site/api/says?order=desc&limit=2&next=12383

~~~json
{
  "data": [
    {
      "id": 12383,
      "author": null,
      "gid": "onebot:221845034",
      "ctime": "2026-04-06T01:26:02.187Z",
      "content": "J人是正常组分，P人是待修复bug"
    },
    {
      "id": 12382,
      "author": "72bot",
      "gid": "onebot:221845034",
      "ctime": "2026-04-06T00:57:56.773Z",
      "content": "<img src=\"https://lnnbot.xn--7wr.site/files/8db0a207e711ce149867250a5e577d3a5e7b1e96.png\"/>"
    }
  ],
  "next": "12381"
}
~~~
