---
date: 2026-04-08T21:24:10+08:00
tags: 编程 日常写代码 esolang
---

# 奇怪的AV号-BV号转换程序增加了！REMASTERED

是的，[时隔六年]({% link _posts/2020-08-27-eso_av2bv.md %})，我决定重制一下本博客的第一篇文章。

2020年3月，B站推出了 bvid（BV号）来代替之前的 aid（AV号）作为每个视频的唯一编号。bvid 长 12 个字符，开头固定为“BV1”，之后 9 位为 58 进制编码，可通过算法与 aid 相互转换。

时过境迁啊，当初最早被披露的算法已不适用于后来 aid 值较大的视频。这次我用我们的老朋友**文言**和新朋友 **WhatLang**、**Uiua** 三种语言了实现番号转换，三种语言各有特点，一起来看看吧！


## [文言 wenyan](https://github.com/wenyan-lang/wenyan)

~~~wenyan
注曰。『庚子年春。嗶站易視頻之標識。廢舊之亞號。立新號曰彼號。
凡十二字。首三字恆為「BV1」。後九字以五十八進制編碼。可依算法與舊號互易轉化。』

吾嘗觀「位經」之書。方悟「異或」「補零右移」之義。
吾嘗觀「列經」之書。方悟「索一」之義。

注曰。『數之極大。「位經」之法不可算其全。乃一分爲二。各算異或。銜之而得全。』
吾有一數。曰四二九四九六七二九六。名之曰「大數界」。
吾有一術。名之曰「大異或」。欲行是術。必先得二數。曰「甲」曰「乙」。乃行是術曰。
  施「異或」於「甲」於「乙」。施「補零右移」於其於零。名之曰「下」。
  除「甲」以「大數界」。除「乙」以「大數界」。取二以施「異或」。名之曰「上」。
  乘「上」以「大數界」。加「下」於其。乃得矣。
是謂「大異或」之術也。

吾有一言。曰『FcwAPNKTMug3GV5Lj7EJnHpWsx4tb8haYeviqBz6rkCy12mUSDQX9RdoZf』。名之曰「字母表」。
吾有一列。名之曰「亂序表」。充「亂序表」以三。以五。以七。以六。以八。以四。以九。以二。以一。
吾有一數。曰二二七五二四二六四一四七六八二七。名之曰「異或數」。

今有一術。名之曰「亞號至彼號」。欲行是術。必先得一數。曰「亞號」。乃行是術曰。
  施「大異或」於「亞號」於「異或數」。名之曰「數」。
  吾有一列。名之曰「數位」。
  為是九遍。
    除「數」以五十八。所餘幾何。名之曰「餘」。
    充「數位」以「餘」。
    減「數」以「餘」。除其以五十八。昔之「數」者。今其是矣。
  云云。
  吾有一言。曰『BV1』。名之曰「彼號」。
  凡「亂序表」中之「序」者。
    夫「數位」之「序」。加其以一。夫「字母表」之其。加其於「彼號」。昔之「彼號」者。今其是矣。
  云云。
  乃得「彼號」。
是謂「亞號至彼號」之術也。

今有一術。名之曰「彼號至亞號」。欲行是術。必先得一言。曰「彼號」。乃行是術曰。
  吾有一列。名之曰「數位」。
  吾有一數。曰四。名之曰「位」。
  凡「亂序表」中之「序」者。
    夫「彼號」之「位」。名之曰「字」。
    施「索一」於「字母表」於「字」。減其以一。昔之「數位」之「序」者。今其是矣。
    加「位」以一。昔之「位」者。今其是矣。
  云云。
  吾有二數。曰零曰九。名之曰「數」曰「位」。
  為是九遍。
    夫「數位」之「位」。名之曰「餘」。
    乘「數」以五十八。加其以「餘」。昔之「數」者。今其是矣。
    減「位」以一。昔之「位」者。今其是矣。
  云云。
  施「大異或」於「數」於「異或數」。乃得矣。
是謂「彼號至亞號」之術也。

施「亞號至彼號」於「114771575769869」。書之。
施「彼號至亞號」於『BV1MugkzCEBn』。加其於『AV』。書之。
~~~

文言的默认编译目标 JavaScript 并不支持超过 32 位整数的按位运算，不过好在 B 站视频的 aid 仍然在 64 位浮点数能够正确处理的整数范围内，为此我引入了一个`大異或`{: lang="lzh"}函数来实现：

~~~javascript
function bigXor(a, b) {
  const low = (a ^ b) >>> 0 // 直接计算异或（只保留低 32 位）并转为无符号
  const high = (a / 4294967296) ^ (b / 4294967296) // 相当于 a、b 都右移 32 位后计算异或
  return high * 4294967296 + low // 搞半天还要自己拼
}
~~~

## [<ruby>WhatLang<rp>（</rp><rt>啥语言</rt><rp>）</rp></ruby>](https://esolangs.org/wiki/WhatLang)

~~~whatlang
(2>|:&&:&\/flr@:&*-]<)divmod=_
(2>:< bxor@ \(4294967296/)#\_<bxor@ 4294967296*+)bigxor=_
(
  2275242641476827bigxor@
  58divmod@\ 58divmod@\ 58divmod@\ 58divmod@\ 58divmod@\ 58divmod@\ 58divmod@\ 58divmod@\ 9>
  2,\8,2\;\8\; 4,\7,4\;\7\; reverse@\_
  ("FcwAPNKTMug3GV5Lj7EJnHpWsx4tb8haYeviqBz6rkCy12mUSDQX9RdoZf"\,)#\_ ""join@\_ "BV1"\+
)av2bv=_
(
  [(^BV1?)]""repl@ ("FcwAPNKTMug3GV5Lj7EJnHpWsx4tb8haYeviqBz6rkCy12mUSDQX9RdoZf"\in@)#\_
  reverse@\_ 2,\8,2\;\8\; 4,\7,4\;\7\;
  |58*+ 58*+ 58*+ 58*+ 58*+ 58*+ 58*+ 58*+]01-,\_
  2275242641476827bigxor@
)bv2av=_

114771575769869 av2bv@. `\n`
"BV1MugkzCEBn" bv2av@. `\n`
~~~

WhatLang 实现的基本思路与文言大差不差，用到了来自 *LNN 函数库*的经典函数 `divmod` 来进行进制转换，也定义了一个相同的 `bigxor` 函数。秉持函数内尽量避免使用变量（因为变量都是全局的）的原则，在进制转换部分我直接把操作写 8 遍，而非使用循环；排列数位顺序使用了倒序再进行两次交换的方法，而非直接查表。正则表达式在 WhatLang 中十分常用，因此在 bvid 转 aid 时，我顺手利用正则替换让输入的字符串可以省略前缀 `BV1`，或只省略 `BV` 保留一个 `1` 也可以。（文言和 Uiua 实现都必须带上 `BV1` 前缀，其实纯粹是懒了）

## [Uiua](https://uiua.org)

~~~uiua
┌─╴Bvid
  Digits ↚ "FcwAPNKTMug3GV5Lj7EJnHpWsx4tb8haYeviqBz6rkCy12mUSDQX9RdoZf"
  Mask   ↚ ⋯2275242641476827
  Order  ↚ 2_4_6_5_7_3_8_1_0
  Call   ← ⊂"BV1" ˜⊏Digits ⬚0⊏Order ⊥58 ⍜⋯(⌅(⬚0≠|⬚0≠)Mask)
└─╴
Bvid 114771575769869
°Bvid "BV1MugkzCEBn"
~~~

作为阵列编程（array programming）语言，Uiua 这边的画风完全不一样了。整个 `Bvid~Call`{: ua} 函数最复杂的部分居然是计算按位异或：常量 `Mask`{: ua} 为异或常数的二进制展开，`⌅(⬚0≠|⬚0≠)`{: ua} 即不论正着还是反着运行，都对相对应的二进制位进行“不等于”运算，位数较短的补零。58 进制的转换也是用一个内置函数（`⊥ base`{: ua}）就搞定了，剩下排列数位顺序和对应字母表两次查表，最后在开头补上 `"BV1"`{: ua} 完事。

得益于 Uiua 的反函数机制，这个函数正着跑是 aid 转 bvid，反着跑（`° un`{: ua}）就是 bvid 转 aid，除了按位异或的部分需要手动定义反函数以外全都可以自动完成，十分舒适。

{:ua: .highlight.language-uiua}

## 最后还是附上完整的 JavaScript 实现

~~~javascript
const TABLE = "FcwAPNKTMug3GV5Lj7EJnHpWsx4tb8haYeviqBz6rkCy12mUSDQX9RdoZf"
const MASK = 2275242641476827n

function av2bv(aid) {
  const digits = []
  let n = BigInt(aid) ^ MASK
  for (let i = 0; i < 9; i++) {
    digits.push(TABLE[Number(n % 58n)])
    n /= 58n
  }
  ;[digits[2], digits[8]] = [digits[8], digits[2]]
  ;[digits[4], digits[7]] = [digits[7], digits[4]]
  digits.reverse()
  return "BV1" + digits.join("")
}
function bv2av(bvid) {
  bvid = bvid.replace(/^BV1?/, "")
  const digits = bvid.split("", 9).reverse()
  ;[digits[2], digits[8]] = [digits[8], digits[2]]
  ;[digits[4], digits[7]] = [digits[7], digits[4]]
  let n = 0n
  for (let i = 0; i < 9; i++) {
    n += BigInt(TABLE.indexOf(digits[i]) * (58 ** i))
  }
  return Number(n ^ MASK)
}
~~~

不使用 BigInt：

~~~javascript
const TABLE = "FcwAPNKTMug3GV5Lj7EJnHpWsx4tb8haYeviqBz6rkCy12mUSDQX9RdoZf"
const MASK = 2275242641476827
function bigXor(a, b) {
  const low = (a ^ b) >>> 0
  const high = (a / 4294967296) ^ (b / 4294967296)
  return high * 4294967296 + low
}

function av2bv(aid) {
  const digits = []
  let n = bigXor(aid, MASK)
  for (let i = 0; i < 9; i++) {
    digits.push(TABLE[n % 58])
    n = Math.floor(n / 58)
  }
  ;[digits[2], digits[8]] = [digits[8], digits[2]]
  ;[digits[4], digits[7]] = [digits[7], digits[4]]
  digits.reverse()
  return "BV1" + digits.join("")
}
function bv2av(bvid) {
  bvid = bvid.replace(/^BV1?/, "")
  const digits = bvid.split("", 9).reverse()
  ;[digits[2], digits[8]] = [digits[8], digits[2]]
  ;[digits[4], digits[7]] = [digits[7], digits[4]]
  let n = 0
  for (let i = 0; i < 9; i++) {
    n += TABLE.indexOf(digits[i]) * (58 ** i)
  }
  return bigXor(n, MASK)
}
~~~
