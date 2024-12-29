---
date: 2024-12-29T23:21:51+08:00
tags: 编程 日常写代码
---

# [![](https://www.uiua.org/assets/uiua-logo.png){: style="height:1em;vertical-align:bottom" .me-1}Uiua](https://uiua.org){: target="_blank"} 99bottles

Uiua 是一门还在迭代开发中的、基于堆栈（stack-based）的阵列编程（array programming）语言，在设计上借鉴了 BQN、APL、J 语言。

~~~uiua
瓶 ← (
  ⍣("No" @s °0|1 "" °1|:@s)
  $"_ bottle_ of beer"
)
墙 ← $"_ on the wall" 瓶
拿 ← ⍣(
  ⍩($"Go to the store, buy some more,\n_" 墙99) °0
| ⍩($"Take one down, pass it around,\n_" 墙-1)
)

⇌⇡100
&p /$"_\n\n_" ≡(□$"_,\n_.\n_." ⊃(墙|瓶|拿))
~~~

[在 Pad 中运行](https://uiua.org/pad?src=0_15_0-dev_1__55O2IOKGkCAoCiAg4o2jKCJObyIgQHMgwrAwfDEgIiIgwrAxfDpAcykKICAkIl8gYm90dGxlXyBvZiBiZWVyIgopCuWimSDihpAgJCJfIG9uIHRoZSB3YWxsIiDnk7YK5ou_IOKGkCDijaMoCiAg4o2pKCQiR28gdG8gdGhlIHN0b3JlLCBidXkgc29tZSBtb3JlLFxuXyIg5aKZOTkpIMKwMAp8IOKNqSgkIlRha2Ugb25lIGRvd24sIHBhc3MgaXQgYXJvdW5kLFxuXyIg5aKZLTEpCikKCuKHjOKHoTEwMAomcCAvJCJfXG5cbl8iIOKJoSjilqEkIl8sXG5fLlxuXy4iIOKKgyjlopl855O2fOaLvykpCg==){: target="_blank"}


{:ua: .highlight.language-uiua}

我以前没有接触过阵列编程语言；花费<abbr title="2024-12-26 14:10—18:09 (中国标准时间)">一个下午</abbr>学习了 Uiua（起因是*预防*在群里分享了一段用 Uiua 合成音频的代码）后我立刻喜欢上了这门语言。

Uiua 中大部分的内置函数和修饰符都有名称和符号形式；编写代码时直接输入名称或缩写，解释器或 IDE 扩展的格式化功能会将名称或缩写转换成对应的符号。

<details class="mb-3" markdown='1'><summary class="btn btn-info user-select-auto">上述代码改用内置函数和修饰符的名称写法，看起来是这样…<div class="text-dark text-opacity-50 small" style="line-height:1">（没有语法高亮，因为我懒得支持名称写法，<div class="d-inline-block text-start" style="font-size:0.5rem;line-height:1.15;vertical-align:-0.1em">是的上面的 Uiua 语法高亮支持是我自己写的，<div style="font-size:0.35rem">人家可是 Rust 项目，哪里会有人给 Ruby 的语法高亮模块提供支持</div></div>）</div></summary>

    瓶 ← (
      try("No" @s un0|1 "" un1|:@s)
      $"_ bottle_ of beer"
    )
    墙 ← $"_ on the wall" 瓶
    拿 ← try(
      case($"Go to the store, buy some more,\n_" 墙99) un0
    | case($"Take one down, pass it around,\n_" 墙-1)
    )

    reverserange100
    &p /$"_\n\n_" rows(box$"_,\n_.\n_." fork(墙|瓶|拿))

</details>

## 99bottles 程序代码剖析

不妨来讲解一下这段代码。

首先我定义了三个函数：`瓶`{: ua}、`墙`{: ua}、`拿`{: ua}。它们都接受一个参数，返回一个结果；对于不熟悉 Uiua 的人，这一点可能很难看出，但在 IDE 中，鼠标悬浮这些函数名可以看到“`|1.1`{: ua}”，这就是函数接受的参数和返回的结果数量，通常是可以通过函数内容推断出来的，因此不需要显式写出。

一开始我用的函数名是 `Br`、`Wl`、`Tk`，但看到 Uiua 的 Discord 群组里有人提到了汉字，我就突然想到用汉字作标识符，好像还挺不错。Uiua 里似乎任何一个没有特殊含义的字符都可以作标识符，汉字或其他语言的字母等字符也可以多个组合为一个标识符。

左箭头表示赋值；编写代码时可以直接输入成等号。圆括号表示函数体，有时可以省略。通常，每行 Uiua 代码从整体上看都是**从右往左执行**的。

### `瓶`{: ua}

~~~uiua
瓶 ← (
  ⍣("No" @s °0|1 "" °1|:@s)
  $"_ bottle_ of beer"
)
~~~

函数 `瓶`{: ua} 实现了输入瓶数，如果是 0，返回“No bottles of beer”；如果是 1，返回“1 bottle of beer”；否则返回“*&lt;瓶数&gt;* bottles of beer”。圆括号中首先映入眼帘的是修饰符 `⍣`{: ua}`try` 与一个函数包——竖线分隔的三个函数 `"No" @s °0`{: ua}、`1 "" °1`{: ua}、`:@s`{: ua}。`⍣`{: ua}`try` 依次尝试执行这三个函数，直到有一个成功执行、没有报错为止。

 1. `"No" @s °0`{: ua}

    `°`{: ua}`un` 是一个一元修饰符，表示逆转一个函数的操作。这里被逆转的是……实数字面量 `0`{: ua}。正常执行时，实数字面量会将实数入栈。而“将实数 0 入栈”的逆操作就是出栈一个值，但如果它不是 0 就会报错。

    因此，在本分支中，如果 `瓶`{: ua} 收到的参数是实数 0，就会将这个 0 出栈，并继续执行本函数的剩余部分 `"No" @s`{: ua}，即将字符字面量 `@s`{: ua}、字符串 `"No"`{: ua} 依次入栈。否则继续尝试下一个分支。这是通过异常处理实现的一种逻辑判断与流程控制，在其他编程语言中可能不是什么好方法，但在 Uiua 这样的语言中我很喜欢。

 2. `1 "" °1`{: ua}

    同理，出栈一个值，如果是数字 1 就会将空字符串和数字 1 入栈；否则报错，继续执行下一分支。

 3. `:@s`{: ua}

    如果参数既不是 0 也不是 1，就将字符字面量 `@s`{: ua} 入栈，然后让栈顶的两个值互换位置——`@s`{: ua} 在下，瓶数在上。

最后是格式化字符串 `$"_ bottle_ of beer"`{: ua}，它其实是一个 <abbr title="接受 2 个参数、返回 1 个结果">`|2.1`{: ua}</abbr> 的函数，会把刚刚入栈的两个值弹出并依次填入两个下划线处。于是，填入第一个空的就是输入的瓶数，但 0 瓶时会填入“No”；第二个空紧跟在“bottle”后面，是 1 瓶时就填入空字符串，否则填入字符 `s`。返回填充后的字符串。

### `墙`{: ua}

~~~uiua
墙 ← $"_ on the wall" 瓶
~~~

函数 `墙`{: ua} 同样接受一个瓶数参数，直接用这个瓶数调用 `瓶`{: ua} 并在结果后面加上空格和“on the wall”然后返回。

### `拿`{: ua}

~~~uiua
拿 ← ⍣(
  ⍩($"Go to the store, buy some more,\n_" 墙99) °0
| ⍩($"Take one down, pass it around,\n_" 墙-1)
)
~~~

又是 `⍣`{: ua}`try` 与一个函数包。第一个函数先 `°0`{: ua}，如果成功（瓶数是 0），就执行一个被 `⍩`{: ua}`case` 修饰的函数。

`⍩`{: ua}`case` 修饰符会执行它的函数，但如果函数报错，错误会**穿过一层** `⍣`{: ua}`try` 而**不被捕获**。在用 `⍣`{: ua}`try` 进行流程控制时经常会使用 `⍩`{: ua}`case` 来区分模式匹配失败与其他异常：将模式匹配放在 `⍩`{: ua}`case` 外面，使异常被 `⍣`{: ua}`try` 捕获，从而在**不匹配时执行下一个** `⍣`{: ua}`try` 分支；将匹配成功后要执行的逻辑放在 `⍩`{: ua}`case` 里面，如果出现异常，使异常**不被** `⍣`{: ua}`try` **捕获，照常报错**。本程序中 `⍩`{: ua}`case` 内的逻辑实际上永远也不会报错，但加上 `⍩`{: ua}`case` 或许是个好习惯（

于是当瓶数是 0 时，执行 `⍩`{: ua}`case` 内的函数：用实数 99 调用 `墙`{: ua}，将结果加在“Go to the store, buy some more,”后面，形成最后一段歌词的后两句。如果第一个函数的模式匹配失败，即瓶数不是 0，转而执行第二个分支，里面也是 `⍩`{: ua}`case` 包裹的逻辑：用减一后的瓶数调用 `墙`{: ua}，加在“Take one down, pass it around,”后面，得到普通段的后两句歌词。

### 主流程

~~~uiua
⇌⇡100
&p /$"_\n\n_" ≡(□$"_,\n_.\n_." ⊃(墙|瓶|拿))
~~~

用整数 100 调用 `⇡`{: ua}`range`，再用 `⇌`{: ua}`reverse` 转换，得到 99 到 0 的整数组成的降序数组。

修饰符 `≡`{: ua}`rows` 对这个数组的每一项调用一元（`|1.1`{: ua}）函数 `□$"_,\n_.\n_." ⊃(墙|瓶|拿)`{: ua}（相当于瓶数从 99 到 0 递减执行），将结果组成一个新的数组：

  * `⊃(墙|瓶|拿)`{: ua}：修饰符 `⊃`{: ua}`fork` 用同一个参数分别调用其函数包里的三个函数，返回三个结果。这里用瓶数分别调用 `瓶`{: ua}、`墙`{: ua}、`拿`{: ua}，分别得到一段歌词的第一句、第二句和后两句。

  * `□$"_,\n_.\n_."`{: ua}：将得到的三个字符串组合在一起，加上标点和换行，然后 `□`{: ua}`box` 装盒返回。由于 Uiua 中字符串就是字符数组，而二维数组中每项的长度必须相同，这里必须将字符串用 box 封装，使 `≡`{: ua}`rows` 形成一个一维 box 数组而非二维字符数组。

得到由 100 段歌词组成的一维 box 数组。修饰符 `/`{: ua}`reduce` 可将数组用一个二元函数累加起来，我们使用格式化字符串 `$"_\n\n_"`{: ua} 作为这个二元函数，也就实现了以两个换行符作为分隔，将 100 个字符串拼合在一起。最后，使用 `&p`{: ua} 函数输出这个字符串（末尾自动加一个换行）。

## 结语

Uiua 语言还有很多有趣的特性没有在本程序中体现：用来操作栈值的行星记法（Planet notation），功能强大的 `⍜`{: ua}`under` 修饰符，内置的一系列测试数据常量（包括两张彩色图片 `Lena`{: ua}、`Cats`{: ua} <small>和 13 种 LGBTQIA+ 骄傲旗的颜色值</small>）……

<small>后面忘了</small>
