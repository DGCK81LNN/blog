---
date: 2022-01-18T17:04:31+0800
last_modified_at: 2022-01-18T17:04:31+0800
tags: 编程 esolang
---

# “文言”编程语言能读取标准输入了

前不久我给[“文言”][wenyan]写了个扩展库，让它能够通过 Node.js 读取标准输入。现已被收入“文言”的包管理系统[“文淵閣”][wyg]。

研究过这门深奥编程语言的朋友可能知道，“文言”中没有原生的办法来读取标准输入。我猜测这大概也是[洛谷网][luogu]不再支持这门语言的原因之一。

[wenyan]: https://wy-lang.org/
[luogu]: https://www.luogu.com.cn/
[wyg]: https://wyg.wy-lang.org/


<aside class="card my-3 p-3 pb-0">
 <figure>
  <blockquote>
   <p><b lang=en>Esoteric programming language</b>，简称<span>Esolang</span>，它们的设计被用于测试计算机语言设计的极限，作为一个概念的证明，或仅仅是一个玩笑。<span lang=en>Esolang</span>创作者［……］几乎不会在意语言的可用性，甚至恰恰相反，会故意增加使用难度。</p>
  </blockquote>
  <figcaption>
   <cite>—— 张凯强<a href="https://cloud.tencent.com/developer/article/1560964">《文言文编程火了，可我完全学不懂》</a></cite>
   </figcaption>
 </figure>
</aside>

“文言”被洛谷网移除前，不乏有人用这门语言来解算法题，这就不得不用到嵌入 JavaScript 代码的 hack。由于“文言”代码需要先编译成 JavaScript代码才能运行，而编译器没有很严格地检查代码是否符合正常语法，我们可以轻松地注入 JavaScript 表达式：

```wenyan
施「(str=>process.stdout.write(str))」於『問天地好在』。
```

在这句代码中直接嵌入了一个 JavaScript 箭头函数 `str => process.stdout.write(str)`{: js}。利用这种方法，我们可以调用 Node.js 环境下的标准库来实现读取输入。但问题是，如果直接读取 `/dev/stdin` 的内容，就必须一次读取完整个输入数据，而无法在命令行进行人机交互。

如果是 Node.js 开发，一般会采用原生的 `readline` 模块来读取用户输入。但它是异步运行的，要想用它来给“文言”程序读取输入，修改整个“文言”编译器的代码，让它编译出支持异步的程序，这似乎不太现实。于是我通过查阅各种资料，摸索出来了不使用异步操作读取命令行输入的办法：

```js
// gets.js

const fs = require("fs")
const SEGMENT_LEN = 1024
const EOL_BUFFER = Buffer.from(require("os").EOL)

function gets() {
  // 缓冲区，以及已读入的字节数
  var buffer = Buffer.alloc(SEGMENT_LEN), len = 0

  while (true) {
    // 读取一字节，如果 EOF 就停止读入
    if (fs.readSync(0, buffer, len, 1) === 0) break
    ++len

    // 如果已经换行就停止读入
    if (buffer.subarray(len - EOL_BUFFER.length, len).equals(EOL)) break

    // 如果缓冲区已经写满就扩容
    if (len === buffer.length) {
      var oldBuffer = buffer
      buffer = Buffer.alloc(oldBuffer.length + SEGMENT_LEN)
      buffer.set(oldBuffer)
    }
  }

  return buffer.subarray(0, len).toString()
}
```

这里声明了一个 `gets()`{: js} 函数，可以读取一行用户输入。方法稍显笨拙：每次用 `fs.readSync(0)`{: js} 读取一个字节，这里如果用户还没有输入完成并按下回车，就会阻塞程序，等待用户输入；用户按下回车后，程序就会逐字节地读取输入的内容，直到遇到换行符为止。

<aside markdown='block' class="card my-3 p-3 pb-0">
注意我传给 `fs.readSync()`{: js} 的第一个参数 `0`{: js} 实际上是标准输入的文件描述符 `process.stdin.fd`{: js}，由于这样写有时会出问题就改成了直接的 `0`{: js}。
</aside>

原型有了，就可以用“文言”来实现了。我定义了一个 `「閱行」`{: wy} 函数，并给它创建了语法糖 `閱一行`{: wy}、`閱二行`{: wy}、`閱三行`{: wy} ……一直到 `閱九行`{: wy}，分别对应调用函数 `「閱行」`{: wy} 一次至九次。这样一来，我们就可以很方便地连续读取多行输入：

```wenyan
閱三行。名之曰「甲」曰「乙」曰「丙」。
```

这就相当于：

```wenyan
施「閱行」。施「閱行」。施「閱行」。名之曰「甲」曰「乙」曰「丙」。
```

不过，在解算法题的时候，我们往往需要从输入中读入数字、字符、单词，而不是读取一整行，所以我还添加了这些读取特定类型数据的方法：`「閱數」`{: wy}、`「閱字」`{: wy}、`「閱言」`{: wy}，并为它们定义了相应的语法糖。

这样一来，用“文言”来解 [A+B Problem][aplusb] 就可以这样写：

```wenyan
閱二數。名之曰「甲」曰「乙」。
加「甲」以「乙」。書之。
```

当然，要想得到正确的输出，我们不能直接用“文言”的解释器来运行这个程序，因为这样会输出中文数字；需要先把程序编译成 JavaScript，再调用 Node.js 运行编译出的代码。

```shell
wenyan -c program.wy > compiled.js
node compiled.js < input.txt > output.txt
```

在“文言”编程中，输出被称作“**書**{: lzh}”，那么读取输入不妨叫做 “**閱**{: lzh}”；许多第三方的扩展库都叫做“某某**秘術**{: lzh}”，因此我决定把我的这个库命名为“**閱文秘術**{: lzh}”。

[这里][src]是“**腳本秘術**{: lzh}”的 GitHub 仓库。

[aplusb]: https://www.luogu.com.cn/problem/P1001
[src]: https://github.com/DGCK81LNN/wenyan-stdin
{:lzh: lang='lzh-Hant'}
{:wy: .highlight.language-wenyan}
{:js: .highlight.language-javascript}

<aside markdown='block' class="card my-3 p-3 pb-0">
![“腳本秘術”的代码中用到了很多嵌入的 JavaScript 表达式，它们跟“文言”代码的古汉语结合在一起，整体看起来十分怪异。]({%link assets/2022-01-18-1.jpg %})

![我节选了“腳本秘術”的一部分代码发给朋友，他形象地称嵌入的 JavaScript 表达式为“来自西洋巫术的神秘咒语”。]({%link assets/2022-01-18-2.jpg %})
</aside>

