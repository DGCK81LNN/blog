---
tags: python ruby js
---

# 再谈自产生程序

之前那篇关于自产生程序的博客表述不清，现决定重新讲解一下。

这里的“自产生程序”是指输出自身源代码的程序。自产生程序有几种不同的思路，而我使用的这种思路可以类比为……“噬菌体”。

我们知道，噬菌体是一种简单的病毒，它专门感染细菌，在结构上由蛋白质外壳和遗传物质（一般是DNA）组成。这些遗传物质记录了整个蛋白质外壳的内容，而在蛋白质外壳的帮助下，噬菌体才能去感染细菌，并生产出新的DNA和蛋白质外壳，从而繁殖出新的噬菌体。

我们的自产生程序就像是噬菌体。当噬菌体感染了一个宿主细菌，细菌会复制噬菌体的DNA，同时根据这个DNA制作出新的蛋白质外壳，然后外壳和DNA组装成新的噬菌体。在自产生程序的代码中硬编码了一些数据（DNA），数据记录了源代码中其余的部分（蛋白质外壳）；程序根据“DNA”得到“蛋白质外壳”，然后把“DNA”安在“蛋白质外壳”中正确的位置，从而输出自己的源代码。

请看以下Python代码：

```python
dna = 'dna = %r\nprint(dna %% dna)'
print(dna % dna)
```

第一行代码中的字符串即是“DNA”，其余代码则是“蛋白质外壳”。可以看到，“DNA”字符串的内容就是整个程序源代码，只是字符串本身的位置变成了`%r`。在Python和一些其他语言中，对字符串使用模运算符`%`会进行文本格式化。这里，`dna % dna`会把`dna`字符串源代码塞到`dna`中`%r`的位置上，也就是把DNA组装到了蛋白质外壳里。`%%`是转义的`%`。

Ruby没有`%r`，可用`dna % dna.inspect`代替：

```ruby
dna = "dna = %s\nputs dna %% dna.inspect"
puts dna % dna.inspect
```

这个JavaScript实现也是大同小异，只是JS没有文本格式化：

```js
var dna = "var dna = $1;\nconsole.log(dna.replace('$1', JSON.stringify(dna)));";
console.log(dna.replace('$1', JSON.stringify(dna)));
```

JS中用`JSON.stringify()`可以达到跟` dna.inspect`类似的效果，而`.replace()`则代替`%`运算符，把转义后的字符串塞到第一个`$1`的位置上。

这一次我也成功写出了之前没能实现的C语言版：

```c
#include <stdio.h>
char *dna = (
"#include <stdio.h>\n"
"char *dna = (\n"
"\32\n"
");\n"
"int main() {\n"
"for (int i = 0; dna[i]; ++i) {\n"
"  if (dna[i] == 032) { // placeholder\n"
"    putchar(34); // quote\n"
"    for (int j = 0; dna[j]; ++j) {\n"
"      if (dna[j] == 032) { // placeholder\n"
"        putchar(92); putchar(51); putchar(50); // backslash 32\n"
"      } else if (dna[j] == 10) { // newline\n"
"        putchar(92); putchar(110); putchar(34); putchar(10); // backslash n quote newline\n"
"        putchar(34); // quote\n"
"      } else putchar(dna[j]);\n"
"    }\n"
"    putchar(34); // quote\n"
"  }\n"
"  else putchar(dna[i]);\n"
"}\n"
"putchar(10); // newline\n"
"return 0;\n"
"}"
);
int main() {
for (int i = 0; dna[i]; ++i) {
  if (dna[i] == 032) { // placeholder
    putchar(34); // quote
    for (int j = 0; dna[j]; ++j) {
      if (dna[j] == 032) { // placeholder
        putchar(92); putchar(51); putchar(50); // backslash 32
      } else if (dna[j] == 10) { // newline
        putchar(92); putchar(110); putchar(34); putchar(10); // backslash n quote newline
        putchar(34); // quote
      } else putchar(dna[j]);
    }
    putchar(34); // quote
  }
  else putchar(dna[i]);
}
putchar(10); // newline
return 0;
}
```

这段代码看起来与前面三个例子相去甚远，但总体思路是完全一样的，只是“把字符串变回字符串的源代码”和“把字符串的源代码塞进‘蛋白质外壳’”这两件事需要手动进行。

使用`putchar()`纯粹是为了避免向“DNA”中引入引号和反斜杠，这样我就只需要转义换行符了。使用了`'\32'`作为在“蛋白质外壳”中为“DNA”预留位置的占位符，注意它和数字`032`都是八进制。`char *dna =`后的括号只是为了好看。

----

如果亲自尝试按这种思路编写自产生程序，不难发现，“DNA”是最后写进去的，因为它的内容是程序其余部分的代码。如果要对局部代码进行一些小修改，我会直接修改“DNA”，然后运行程序，得到的“子一代”的“蛋白质外壳”就也变成了修改后的版本。这让我想起生物课上讲的“基因突变”。事实上，我正是在生物课上讲“DNA的复制”时想出本文反复提到的“噬菌体模型”的。~~我真后悔六选三没选生物而选了地理~~ 竟然能从大自然的创造中获得计算机编程的灵感，多么奇妙啊！
