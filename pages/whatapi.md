---
soulblog-no-not-by-ai: true
soulblog-style: |
  mark { padding: 0 }
  .json-type-icon { display: inline-block; width: 1em; height: 1em; vertical-align: -.125em }
---

{%- capture json_array %}<span><svg class="json-type-icon" title="数组" viewBox="0 0 64 64"><path fill="none" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" d="M24,4H14A6,6,0,008,10V54A6,6,0,0014,60H24M40,60H50A6,6,0,0056,54V10A6,6,0,0050,4H40"/></svg></span>{%- endcapture %}
{%- capture json_object %}<span><svg class="json-type-icon" title="对象" viewBox="0 0 64 64"><path fill="none" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" d="M24,4A10,10,0,0014,14v8A10,10,0,014,32A10,10,0,0114,42v 8A10,10,0,0024,60M40,60A10,10,0,0050,50v-8A10,10,0,0160,32A10,10,0,0150,22v-8A10,10,0,0040,4"/></svg></span>{%- endcapture %}
{%- capture json_number %}<span><svg class="json-type-icon" title="数字" viewBox="0 0 64 64"><path fill="none" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" d="M4,14L8,8V56M18,18A8,9.5,0,1133,21L18,56H34M43,8H60L47,29A10,14,0,1143,53"/></svg></span>{%- endcapture %}
{%- capture json_string %}<span><svg class="json-type-icon" title="字符串" viewBox="0 0 64 64"><path fill="none" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" d="M10,6V22M22,6V22M42,6V22M54,6V22"/></svg></span>{%- endcapture %}
{%- capture json_boolean %}<span><svg class="json-type-icon" title="布尔值" viewBox="0 0 64 64"><path fill="none" stroke="currentColor" stroke-width="8" stroke-linecap="round" stroke-linejoin="round" d="M58,6L6,58M6,8H24M15,8V30M60,36H42V58M42,47H57"/></svg></span>{%- endcapture %}

# WhatAPI 文档
{: .no_toc}

[WhatAPI] 是 [LNNBot] 特有的一个 Koishi 插件，它在 LNNBot 的服务器（lnnbot.哼.site）上提供了一系列 HTTP API，可以用来访问 LNNBot 中的一些数据。从 LNNBot 本机访问（如使用 WhatLang 请求）WhatAPI 时可以直接使用 `127.0.0.1` 作为主机地址。

[WhatAPI]: https://gitee.com/DGCK81LNN/lnnbot-miniplugs/blob/master/plugins/common/-lnnbot-whatapi.js
[LNNBot]: https://wiki.xdi8.top/wiki/LNNBot

## 目录
{: .no_toc}

{:toc .treeview}
* TOC

## 1. WhatLang 相关

以下接口为 [WhatLang] 提供了强大的功能扩展。

[WhatLang]: https://wiki.xdi8.top/wiki/WhatLang

### 1.1. WhatServer

WhatServer 是一个 WhatLang 运行环境，它允许您通过为 LNNBot 定义特殊的 [WhatCommands 指令] 来在服务器收到特定的 HTTP 请求时执行 WhatLang 代码。这些特殊的 WhatCommands 指令由于名称包含空格，无法直接在聊天中使用 `¿¿` 语法调用。

[WhatCommands 指令]: https://wiki.xdi8.top/wiki/LNNBot/WhatCommands指令

#### 1.1. 路由

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

#### 1.2. 输入参数

如果路径中**路由名称之后没有其他内容**，指令的输入参数为 `undef@`{: what}。如果路由名称后**有斜杠**，斜杠之后的内容将以作为一个字符串输入给指令。查询字符串（`?` 及之后的部分）不会被视为输入的一部分，需要通过 `me@`{: what} 函数读取。

例如，请求 `GET /whatfoo/some/data?query=1` 会将 `"some/data"`{: what} 作为输入传递给 `server foo` 指令；请求 `GET /whatfoo` 时，输入是 `undef@`{: what}；请求 `GET /whatfoo/` 时，输入则是空字符串。

#### 1.3. 响应

WhatCommands 指令的输出将作为 HTTP 响应的正文返回。

使用 `send@`{: what} 或 `sends@`{: what} 将进行流式输出；流式输出开启后，将无法修改响应的头部信息。

指令执行过程中如果发生未被捕获的错误，将输出一个 U+000C FORM FEED 字符，后跟“UNCAUGHT”及错误信息，如果当前请求尚未开启流式输出，会返回 `500 Internal Server Error` 错误。

若未使用流式输出，指令成功执行完成后，其返回值如果是：

1. 200 到 599 的整数或其字符串表示；
2. 由上述整数的字符串表示、一个空格和至少一个字符组成的字符串（例如 `404 Not Found`）；或
3. 长度为 1 或 2 的数组，第一项满足条件 1，第二项（若存在）为字符串

（状态码的“字符串表示”必须是十进制，且不能有前导零）

则会被视为 HTTP 响应的状态码（和状态文本）返回。否则，响应状态默认为 `200 OK`。流式输出时响应状态总是 `200 OK`。

#### 1.4. 内置函数和特殊变量

内置函数 `me@`{: what} 可用于获取当前请求的相关信息。仿照聊天环境下 `me@`{: what} 返回值的结构，它返回一个包含下列信息的数组：

* 索引 0（消息内容）：请求方法和 URL，包括查询字符串（例如 `GET /whatfoo/some/data?query=1`）。URL 中除 `;/?:@&=+$,#%` 以外的百分号编码字符会被解码。
* 索引 1（消息 ID）：16 位随机的小写十六进制数字
* 索引 2（用户名称）、3（用户 ID）、5（频道 ID）：都是请求的客户端 IP 地址
* 索引 4（用户序号）：如果请求已成功登录（见下文“用户登录”），则为当前登录的用户序号，否则为 `undef@`{: what}
* 索引 6（引用的消息 ID）：总是 `undef@`{: what}

变量 `reqh^`{: what} 是一个数组，包含请求的所有头部信息，其中的每项都是一个数组，第一项为头部名称（保留原始大小写，可能重复），第二项为值。

变量 `reqm^`{: what} 存储请求的方法名称（小写字符串），例如 `get` 或 `post`。

变量 `reqb^`{: what} 存储请求的正文内容，根据请求的 `Content-Type` 头部不同，可能是字符串或字节数组，如果没有正文则为 `undef@`{: what}。

内置函数 `hset@`{: what} 接受两个字符串，设置名称为底值的头部内容为顶值。名称不区分大小写，若已存在同名头部，会覆盖原来的值。

此外，WhatServer 环境还支持下列扩展内置函数：`you@ pr@ cat@ ca@ fetch@ fech@ reesc@ sleep@ nout@ nouts@ send@ sends@ ou@`{: what}。注意，与 Koishi 运行时不同，`send@`{: what}、`sends@`{: what} 在 WhatServer 环境下无返回值，如果要同时兼容两个环境，建议像这样使用：`[send@]_`{: what}、`[0sends@]_`{: what}。

WhatNoter 和 WhatCommands 相关的函数也可以在 WhatServer 环境中使用，但 `notewc@ notewd@ notewe@ notere@ cmdset@ cmdsethelp@ cmdseth@ cmddel@`{: what} 只有请求成功登录时才能使用，否则会报错；`noterc@ noterd@ cmdall@ cmdget@ cmdgethelp@ cmdgeth@ cmd@`{: what} 不需要登录。

#### 1.5. 用户登录

WhatServer 支持通过请求头 `X-Lnnbot-Whatserver-Login-Token` 来作为 bot 用户登录。使用浏览器在 bot 控制台登录后，使用 JavaScript 代码 `JSON.parse(localStorage.getItem("koishi.console.auth"))?.token`{: js} 可以获取到登录令牌，将其作为该请求头的值发送即可。令牌有一定的有效期，过期后需要重新获取。

### 1.2. WhatServer 上的通用路由

这些已定义的 WhatServer 路由提供稳定的 API 接口，适合用来访问 LNNBot 的一些常用数据。

#### 1.2.1. 执行 WhatLang 代码

（任意请求方法） `/what/¿{code}`

“¿”后的路径部分将作为 WhatLang 代码直接执行。

**示例：**

GET <https://lnnbot.哼.site/what/¿%60Hello,%20world!%60>

~~~
Hello, world!
~~~

#### 1.2.2. 读取 WhatNoter public 或 protected note

`GET /whatnoter/{spec}`

`spec` 是用户序号后加字母 `c` 或 `d`，分别代表 public 和 protected note。

**示例：**

GET <https://lnnbot.哼.site/whatnoter/0d>

~~~
[[mapgeti (\len@range@ (\_,\_0,\_same@)filter@0,\_\_ 3>0$<)] [mapget ...
~~~

#### 1.2.3. 获取 WhatCommands 指令列表

`GET /whatcommands`

返回由指令名字符串组成的 JSON 数组。

**示例：**

GET <https://lnnbot.哼.site/whatcommands>

```jsonc
[
  "",
  "\b",
  "$【W/C",
  "(k.)",
  ",.",
  "136code",
  "20dice",
  "3ps",
  // ...
]
```

#### 1.2.4. 获取 WhatCommands 指令定义

`GET /whatcommands/{name}`

返回包含指令各属性的 JSON 对象：

{: .treeview}
* {{ json_object }} 根对象
  * {{ json_string }} `name`: 名称
  * {{ json_string }} `code`: 代码
  * {{ json_string }} `h`: 短描述
  * {{ json_string }} `help`: 长帮助信息

**示例：**

GET <https://lnnbot.哼.site/whatcommands/echo>

~~~json
{
  "name": "echo",
  "help": "用法：¿¿echo <文本...>",
  "h": "输出给定内容",
  "code": "."
}
~~~

#### 1.2.5. 调用 WhatCommands 指令

`GET /whatwc/{name}`  
`GET /whatwc/{name}/{arg}`

使用给定的参数调用 WhatCommands 指令，参数缺省为空。如果指令使用了 Koishi 运行时支持而 WhatServer 不支持的内置函数会报错。

**示例：**

GET <https://lnnbot.哼.site/whatwc/echo/FooBar>

~~~
FooBar
~~~

### 1.3. 旁加载字体声明

`GET /lnnbot-sideload-fonts`

获取旁加载字体的声明 CSS 代码，在 LNNBot 上配合 WhatLang 的 `outhtml@`{: what}、`outsvg@`{: what} 函数用来引用旁加载字体。

**Query 参数：**

* `family`: 字体族名，该参数可以指定多次。未指定时返回所有旁加载字体。

**示例：**

（此 API 只在 LNNBot 上使用才有意义，因此建议使用环回 IP 127.0.0.1）

GET <http://127.0.0.1/lnnbot-sideload-fonts?family=Minecraft%20Seven%20v2&family=Unifont>

~~~css
@font-face {
  font-family: 'Minecraft Seven v2';
  src: url('file:///root/koishi-app/assets/fonts/Minecraft%20Seven%20v2.ttf')
}
@font-face {
  font-family: 'Unifont';
  src: url('file:///root/koishi-app/assets/fonts/Unifont.otf')
}
~~~

## 2. 机器人状态与统计

### 2.1. 机器人运行状态

`GET /api/status`

返回一个 JSON 对象：

{: .treeview}
* {{ json_object }} 根对象
  * {{ json_array }} `memory`: 内存占用情况
    * {{ json_number }} `0`: Koishi 占用内存比例
    * {{ json_number }} `1`: 系统总占用内存比例
  * {{ json_array }} `cpu`:  CPU 占用情况
    * {{ json_number }} `0`: Koishi 占用 CPU 时间比例
    * {{ json_number }} `1`: 系统总占用 CPU 时间比例
  * {{ json_array }} `bots`: 当前 bot 在各平台的登录情况
    * {{ json_object }} 登录信息
      * {{ json_string }} `adapter`: 适配器名称
      * {{ json_string }} `platform`: 平台名称
      * {{ json_number }} `status`: 登录状态（0=离线，1=在线，2=连接中，3=断开中，4=重连中）
      * {{ json_object }} `user`: 机器人账号信息
        * {{ json_string }} `id`: 账号 ID
        * {{ json_string }} `name`: 用户名
        * {{ json_string }} `avatar`: 头像 URL

~~~jsonc
{
  "memory": [0.280391, 0.718084],
  "cpu": [0.02698, 0.058163],
  "bots": [
    {
      "adapter": "qq",
      "platform": "qq",
      "status": 1,
      "user": {
        "id": "11371375051710912874",
        "name": "真魂bot",
        "avatar": "..."
      }
    },
    // ...
  ]
}
~~~

### 2.2. 使用量统计数据

这些 API 可获取 LNNBot 近期的一些使用量统计信息。

#### 2.2.1. 指令日均调用次数

`GET /api/analytics/command`

获取近 7 天（不含当天）各指令平均每天被调用的次数。

**示例：**

GET <https://lnnbot.哼.site/api/analytics/command>

~~~jsonc
{
  "says": 520.571428571429,
  "checkin": 46.4285714285714,
  "whatcmd": 43.5714285714286,
  "xdi8": 40.5714285714286,
  "evaluate": 32.7142857142857,
  // ...
}
~~~

#### 2.2.2. WhatCommands 指令日均调用次数

`GET /api/analytics/whatcmd`

获取近 7 天（不含当天）各 WhatCommands 指令平均每天被调用的次数。

**Query 参数：**

* `whatserver`: 只统计（`only`）或不统计（`no`）通过 WhatServer 调用的次数

**示例：**

GET <https://lnnbot.哼.site/api/analytics/whatcmd?whatserver=no>

~~~jsonc
{
  "translate": 9.285714285714286,
  "lrcsrc": 9.285714285714286,
  "wsatn": 5.571428571428571,
  "图片描述": 4.857142857142857,
  "rubyt": 4,
  // ...
}
~~~

### 2.3. 赞助者信息

`GET /api/patrons`

返回所有已登记的 LNNBot 赞助者用户序号、名称和首次登记赞助时间。响应体是一个 JSON 对象，其中以用户序号为键：

{: .treeview}
* {{ json_object }} 根对象
  * {{ json_object }} `{id}`: 赞助者信息（键为用户序号）
    * {{ json_string }} `name`: 名称
    * {{ json_string }} `ctime`: 首次登记赞助时间（ISO 格式，UTC 时间）

~~~jsonc
{
  "17": {
    "name": "氢氧化钠",
    "ctime": "2025-12-12T13:31:10.680Z"
  },
  "23": {
    "name": "江大橋BridgeRiver",
    "ctime": "2025-05-03T09:41:38.252Z"
  },
  // ...
}
~~~

## 3. 其他用户生成内容与动态加载代码

### 3.1. 微指令

此 API 可实时获取 LNNBot 上已定义的[微指令]源代码。

[微指令]: https://www.npmjs.com/package/koishi-plugin-microcommands

#### 3.1.1. 获取微指令列表

`GET /api/microcommands`

返回由指令名字符串组成的 JSON 数组。

**示例：**

GET <https://lnnbot.哼.site/api/microcommands>

~~~jsonc
[
  "-jz-xiaoliuren",
  "-lnn-imgdesc",
  "-lnn-kanji-to-simplified-hanzi",
  "-lnn-pjsk-chibi-circle-test",
  // ...
  "5k",
  "6dice",
  "aconv",
  "ai声聊",
  // ...
]
~~~

#### 3.1.2. 获取 WhatCommands 指令定义

`GET /api/microcommands/{name}`

返回指令的 JavaScript 源代码。

**示例：**

GET <https://lnnbot.哼.site/api/microcommands/greet>

~~~js
signature("[name]")
action((_, name) => name ? h.i18n(".greeting-specific", [name]) : h.i18n(".greeting"))
ctx.i18n.define("zh-CN", "commands." + name, { description: "你好世界", messages: { "greeting-specific": "你好，{0}！", greeting: "你好，世界！" } })
ctx.i18n.define("en-US", "commands." + name, { description: "Hello World", messages: { "greeting-specific": "Hello, {0}!", greeting: "Hello, World!" } })
~~~

### 3.2. `eval` 数据存储

`GET /api/evalstorage/{path*}`

以 JSON 格式获取 `eval` 指令中 `storage` 对象上的数据。`path` 指定要获取的值路径，未指定 `path` 时获取整个 `storage` 对象。

**示例：**

GET <https://lnnbot.哼.site/api/evalstorage/lnn/uiua>

这将获取 `storage.lnn.uiua`{: js} 的值，并以 JSON 返回。

### 3.3. `sletscript` 虚拟文件系统

此 API 可读取 `sletscript` 指令的虚拟文件系统。

#### 3.3.1. 列举文件夹内容

`GET /api/sletstorage/{path*}/`

返回一个 JSON 数组，包含指定文件夹下的所有文件和子文件夹信息：

{: .treeview}
* {{ json_array }} 根数组
  * {{ json_object }} 文件或子文件夹信息
    * {{ json_string }} `name`: 文件名
    * {{ json_string }} `type`: `file` 或 `directory`
    * {{ json_string }} `ctime`: 创建日期（ISO 格式，UTC 时间）
    * {{ json_string }} `mtime`: 修改日期（ISO 格式，UTC 时间）
    * {{ json_string }} `url`: 读取该文件或文件夹内容的 API 路径

**示例：**

GET <https://lnnbot.哼.site/api/sletstorage/home/>

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

#### 3.3.2. 读取文件

`GET /api/sletstorage/{path*}`

读取虚拟文件系统中指定的文件，直接返回文本内容。如果给定的路径是文件夹，请求会被重定向到末尾有斜杠的路径。

{:js: .highlight.language-javascript}
{:what: .highlight.language-whatlang}

### 3.4. 全局名人名言

`GET /api/says`

获取 says 功能的全局名言列表。返回一个 JSON 对象：

{: .treeview}
* {{ json_object }} 根对象
  * {{ json_array }} `data`: 名言列表
    * {{ json_object }} 名言信息
      * {{ json_string }} `id`: 名言 ID
      * {{ json_string }} `author`: 作者昵称（对于匿名名言为 `null`{: js}）
      * {{ json_string }} `gid`: 来源平台及群组 ID（对于早期未记录来源群组的名言，为空字符串）
      * {{ json_string }} `ctime`: 创建时间（ISO 格式，UTC 时间；对于早期未记录创建时间的名言，为 `null`{: js}）
      * {{ json_string }} `content`: 名言内容
  * {{ json_string }} `next`: 获取下一页结果的 `next` 参数值，如果没有下一页则无此属性

**Query 参数：**

* `order`: 排序方式，`asc`（从旧到新）或 `desc`（从新到旧），默认为 `asc`
* `limit`: 每页结果数量，默认为 20，最大为 500
* `next`: 起始 ID，配合 `order` 参数使用以进行翻页

**示例：**

GET <https://lnnbot.哼.site/api/says?order=desc&limit=2&next=12383>

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
