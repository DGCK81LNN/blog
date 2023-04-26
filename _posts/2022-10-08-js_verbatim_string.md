---
date: 2022-10-08T10:03:44+0800
tags: 编程 日常写代码
last_modified_at: 2023-04-26T19:28+0800
---

# Javascript 版的原义字符串？

~~~js
let s = cts`Hello, ``world``!`() // "Hello, `world`!"
~~~

----

几天前我发现在 Javascript [带标签的模板字符串]<sup markdown=1>[(英文)][tagged_templates]</sup>语法中，标签完全可以由任何表达式充当，包括模板字符串本身。事情是这样的。

[带标签的模板字符串]: https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Template_literals#带标签的模板字符串
[tagged_templates]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates


~~~js
`aaa``bbb`
~~~

当我运行上面这个表达式时，得到的报错信息是

    TypeError: "aaa" is not a function

第一个模板字符串 `` `aaa` ``{: js} 被当作了第二个模板字符串 `` `bbb` ``{: js} 的标签，但因为它不是一个函数，所以得到了“不是函数”的错误。这意味着，即使这样

~~~js
```js
console.log("等等……我们这是在 Markdown 里吗？")
```
~~~
[//]: ↗ 确实（

也是符合 Javascript 语法的，看起来就像是模板字符串里面可以包含双反引号，就像 C# 中的原义字符串一样……只是会报运行时错误罢了。

~~~csharp
string s = @"\反斜杠\不用转义，双引号转义成""两个双引号""";
string s2 = @"""quoted""";
~~~

想到 `String.raw`{: js} 标签的字符串里面没有办法包含反引号（除非前面有奇数个反斜杠），我们或许可以让反引号可以转义成两个反引号。

要想让 ``` `aaa``bbb` ```{: js} 返回 ``"aaa`bbb"``{: js}，第一步是让它不要报错。这简单，只要在前面加个标签函数，让 `` tag`aaa` ``{: js} 返回一个标签函数就好了。

不过，因为字符串里面的反引号数量是不确定的，所以后面的 `` `bbb` ``{: js} 还得继续返回一个标签函数，万一后面还有个 `` `ccc` ``{: js} 呢。

~~~js
tag`aaa``bbb``ccc``ddd` // "aaa`bbb`ccc`ddd"
// 拆开来看就是……
var tag2 = tag`aaa`
var tag3 = tag2`bbb`
var tag4 = tag3`ccc`
var val = tag4`ddd`
~~~

这里 `val`{: js} 仍然得是一个标签函数 `tag5`{: js}，因为 `tag4`{: js} 被调用的时候完全不会知道 `` `ddd` ``{: js} 之后还会不会有 `` `eee` ``{: js}。因为这是一个可以无限延续的“模板字符*串*串”，我们暂且给最前面的标签起名叫“<span lang=en>Continuable Template Strings</span>”——`cts`{: js}。

由于整个*串*串最后的返回值是个函数，我们需要一种方法来取得我们要的字符串。可以给它添加一个 `value`{: js} 成员，重写 `valueOf()`{: js} 和/或 `toString()`{: js} 方法……或者干脆让这个函数在没有参数传入时直接返回字符串。

~~~js
cts`aaa``bbb`.value
cts`aaa``bbb`.valueOf()
cts`aaa``bbb`.toString()
cts`aaa``bbb` + "" // 隐式调用 .valueOf() 转换成字符串
cts`aaa``bbb` + [] // 同上...?
cts`aaa``bbb`() // 还是这个最简短！
~~~

到这里思路就完整了，可以开始写代码了。

~~~js
function cts(...args) {
  let str = String.raw(...args) // 就假装咱们是直接拿 String.raw 当标签
  const tag = function (...args) {
    if (args.length === 0) return str

    str += "`" + String.raw(...args)
    return tag
  }
  return tag
}
~~~

这里还有个更精致些的版本。

~~~js
function cts(...args) {
  const tag = function tag(...args) {
    if (args.length === 0) return tag.value

    tag.value += "`" + String.raw(...args)
    return tag
  }
  Object.defineProperties(tag, {
    value: {
      writable: true,
      value: String.raw(...args),
    },
    toString: {
      value: function () {
        return this.value
      },
    },
  })
  return tag
}
~~~

（说来我还是写这个的时候才知道，在带名称的函数字面量里面可以通过名称来引用函数自身。相当于 `arguments.callee`{: js}。以前一直不知道这里加名称有什么用。）

~~~js
const a = function f() { return f }
a() // a

// 当然，对函数声明无效
function g() { return g }
const h = g
g = "foo"
h() // "foo"
~~~

话说回来，刚才我们实现了“加强版 `String.raw`{: js}”，虽然现在可以包含反引号了，但仍然没办法写出以单个反斜杠结尾的字符串，因为反引号仍然会被反斜杠“假装转义掉”，字符串不会至此就结束。

~~~js
cts`aaa\``() // "aaa\\`"
~~~

看来 `String.raw`{: js} 的古怪特性被原封不动地遗传了下来：由于斜杠也会被斜杠“假装转义掉”，只有紧跟在*奇数个*斜杠后面的反引号不需要双写……

~~~js
cts`
1 个斜杠 \`
2 个斜杠 \\``
3 个斜杠 \\\`
4 个斜杠 \\\\``
5 个斜杠 \\\\\`
`()
~~~

（看起来目前版本的 Rouge 语法高亮不认识模板字符串里的“`\\`”，我得去发个 issue〔或者 PR〕。）

<aside class="card my-3 w-75 mx-auto">
<div class="card-header">2022-12-10 更新</div>
<div class="card-body pb-0" markdown=1>
[我提交的 PR](https://github.com/rouge-ruby/rouge/pull/1878) 已经被合并了。
</div>
</aside>

插值还是可以用的，并且也会被奇数个斜杠“假装转义掉”：

~~~js
cts`${111}`() // "111"
cts`\${111}`() // "\\${111}"
cts`\\${111}`() // "\\\\111"
~~~

如果前面不是奇数个斜杠的话，只能用插值来“转义”了。“`${`”或许需要转义成……`` `${"${"}` ``{: js}？`` `${"$"}{` ``{: js}？`` `$${""}{` ``{: js}？（这真的还算是转义吗？）

这些怪癖都是原义字符串和转义字符串的语法重合导致的，但凡像 C# 那样在语法上作一点区分（原义字符串前加“`@`”）也不至于变成现在的样子。

看来这个东西用处不大，咱们还是不拿它当原义字符串用了吧。看看有没有其他用法。

我记得在 C 语言里，两个字符串字面量之间只有空白的话，是会被合并作一个字符串处理的。不像 Javascript 这样需要用加号处理。

~~~c
#include <stdio.h>
const char* dna =
    "#include <stdio.h>\n"
    "const char* dna =\n"
    "    禁止套娃！;\n"
    "int main() {\n"
    "    // TODO: code a quine\n"
    "}";
int main() {
    // TODO: code a quine
}
~~~

用刚才的思路，要想在 Javascript 里实现这种效果也很简单，只要把 ``"`" +``{: js} 去掉就行了。

不过，我刚才这段 C 代码的字符串里还有 `\n`。我们刚刚获取的可是原义字符串。要想获得“非原义”字符串，完全可以自己把传给标签函数的参数拼起来，比如我写的这个很难看懂的版本：

~~~js
function identity(parts, ...values) {
  if (parts.includes(undefined))
    throw new SyntaxError("Syntax error in template literal")
  return values.reduce((prev, curr, i) => prev + curr + parts[i + 1], parts[0])
}
~~~

不过 MDN 上的做法，是直接把“非原义”字符串放在本来是原义字符串的位置上丢给 `String.raw`{: js} 来处理。简单粗暴。

~~~js
function identity(parts, ...values) {
  return String.raw({ raw: parts }, ...values)
}
~~~

或许我们还可以让 `cts()`{: js} 在第一个参数不是数组的时候把参数视为每两段模板字符串中间要插入的字符（`` ` `` 或空字符串）和用来处理模板字符串的标签函数（`String.raw`{: js} 或 `identity`{: js}），返回一个新的标签函数。

~~~js
function cts(...args) {
  let joiner = "`"
  let underlyingTag = String.raw
  const tag = function (parts, ...interp) {
    {
      const raw = parts.raw
      parts = [...parts]
      parts.raw = [...raw]
    }
    interp = [...interp]
    const tag = function (newParts, ...newInterp) {
      if (!newParts) return underlyingTag(parts, ...interp)

      parts[parts.length - 1] += joiner + newParts[0]
      parts.push(...newParts.slice(1))
      parts.raw[parts.raw.length - 1] += joiner + newParts.raw[0]
      parts.raw.push(...newParts.raw.slice(1))
      interp.push(...newInterp)
      return tag
    }
    return tag
  }

  if (args[0] instanceof Array) return tag(...args)
  joiner = args[0] ?? joiner
  underlyingTag = args[1] ?? underlyingTag
  return tag
}

cts`Hello, ``world``!`()     // "Hello, `world`!"
cts()`Hello, ``world``!`()   // "Hello, `world`!"（同上）
cts("")`Hello, ``world``!`() // "Hello, world!"
cts("111", identity)`Hello, \\``world\\``!`() // "Hello, \\111world\\111!"

cts("")`ABCDEFGHIJKLMNOPQRSTUVWXYZ`
       `abcdefghijklmnopqrstuvwxyz`
       `0123456789+/=`()

cts("\n")
`pipi suno li kama jo e ilo suno.`
`tenpo pimeja la, ona li tawa sama waso.`
`ona li wile mute lukin e jan olin,`
`li alasa e olin.`() // 甚至把 \n 都省去了。
~~~

最后两个例子看起来似乎还不错，可以写出漂亮的多行字符串，并且可以随便缩进。不过 [Prettier 似乎不太喜欢我的这种写法][prettierlink]。

[prettierlink]: https://prettier.io/playground/#N4Igxg9gdgLgprEAucMDOAKAOiLWo4CU+ABgA4CWlABGgK5QTUA2F1A1gIYC2n1AVkzjUKzJvUYA6EqXhQyTStzj8+zTgBpq0NWxicA7nzQ8+RtBGmkdLNgdHDudeCzrsKUasNWeIrKBoyUCSs1JzqJl7a-tIYhCAaIBBkMBTQaMignABO2RAGAAo5CBko4UYAnhmJAEbZnGDscDAAyjxwADIecMgAZuFocLX1jc0tZA0eAObIMNl0QyBw3DVwACZr6x2cUFN0nFNwAGIQ2bwwqbvIIJzOEAkgABYw3MwA6o8U8GgTYHAtJS+FAAbl8KtcwGhqiAPINsjACvUprw+gNFvw0AAPFrTZhwACKdAg8FRzEGiQm2Th1xqnFWzAeZGyHhgbwoaxgj2QAA4AAwUvKDN71MjXJlwOHAnqJACORPgiOSpRuaAAtFA4Ot1g9snA5RRdYiDiikP0yYtBtwKKTySA0LiCfKeqa0Yl9DU2RyuUgAExu+qiaYAYQg3BNSzQAFYHnRBgAVOmlM224ELACSUE2sBaYGZKQAgpmWjAKnibXAAL4VoA "Prettier playground"

~~~js
cts(
  "\n"
)`pipi suno li kama jo e ilo suno.``tenpo pimeja la, ona li tawa sama waso.``ona li wile mute lukin e jan olin,``li alasa e olin.`()
// :(
~~~

没用，散了吧。

我的评价是，不如老老实实用反斜杠转义。

{:js: .highlight.language-javascript}
