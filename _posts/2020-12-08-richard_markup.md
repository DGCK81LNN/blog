---
title: "Richard Markup 帮助文档"
soulblog-footer-links:
  -
    href: "https://github.com/DGCK81LNN/LoveWithRichard"
    text: "LoveWithRichard 旧版本"
  -
    href: "https://dgck81lnn.github.io/apps/lab/console.html?path=/res/down/SoulLC/LoveWithRichard.soullc.mjs"
    text: "LoveWithRichard V3 网页版"
---

**Richard Markup** 是我专为 Richard （[@天府灵山行者](https://space.bilibili.com/300711293)）的互动式小说设计的一种文本标记语言，它注重剧情逻辑，而数据存储、用户界面由解释器完成。

## 文件结构

Richard Markup 存储为`.richard`扩展名的文件，格式与 HTML 和 XML 有些相似，使用 UTF-8 或 GB-18030 编码。

文件的开头是头部信息：
```html
<?richard-markup v1 ?>
```
其中`v1`是文件格式的版本号。

随后的内容是正文，由**文本**、**元素**、**注释**组成。

**文本**是除元素、注释外的文字内容，它会逐字显示在控制台上，一般每显示完一行后用户可以按任意键继续，并可以在逐字显示的过程中按任意键跳过。

**元素**会改变文本的行为。在 Richard Markup 中，元素有**类型**、**属性**、**内容**，其中只有类型是必须的。
**内容**一般是文本，但也可以包含其他元素。
每个**属性**又有**属性键**和**属性值**，属性键是必须的。如果没有值，直接写属性键即可；如果有值，用`属性键="属性值"`表示，如果属性值中没有空格，可以省略引号。

当元素没有内容时，用**自闭合标签**`<类型 />`表示，如果有属性，它们依次跟在类型之后，用空格隔开：
```html
<类型 属性 属性... />
```
如果元素有内容，就把内容写在**开始标签**`<类型>`和**结束标签**`</类型>`之间，如果有属性，就写在开始标签的类型之后，用空格隔开：
```html
<类型 属性 属性...>内容</类型>
```
当然，也可以让开始标签和结束标签单独占一行：
```html
<类型 属性 属性...>
    内容
</类型>
```
解释器会在运行前先去掉多余的换行和空格：行首的空格会被忽略，并且如果一个自闭合标签、开始标签或结束标签或注释独占一行，那么紧挨在它们前面的换行会被忽略。

在 Richard Markup 中，每种元素要么必须有内容，要么不能有内容。所以对于不能有内容的元素类型， Richard Markup 规定它们的自闭合标签中的斜杠可以省略：`<类型>`。

**注释**会被 Richard Markup 解释器直接忽略。与 HTML 和 XML 一样，它这样表示：
```html
<!-- 注释内容 -->
```

## Richard Markup 中的元素

### `<s>`元素

`<s>`元素代表文本片段，它必须有内容。

可以有一个`name`属性，指定片段的名称。也可以指定`color`属性来改变片段中文字的颜色：

```html
<s name="welcome">
    欢迎来到<s color="#33bfab">灵魂小站</s>！
</s>
```

### `<a>`元素

`<a>`元素代表锚点（Anchor），它不能有内容。

可以有一个`name`属性指定锚点的名称。另外也可以有一个`goto`属性，值是另一个元素的`name`。这样一来，程序运行到此锚点后就会跳转到指定的元素处继续运行：

```html
<a name="dead-loop">
    禁止死循环！
<a goto="dead-loop">
```

也可以把`goto`的值设为`_exit`来退出程序。

### `<choices>`和`<choice>`元素

`<choices>`代表一个互动选择题，它的内容是一行文本（可省略）后加若干个`<choice>`。可以给`<choices>`指定`name`属性。

`<choice>`表示一个选项，它的内容是选项的文案。可以有一个`goto`属性，指定当选项被选定后要跳转到的位置。

----

至此，已经完全可以制作一个简单的互动了：
```html
<?richard-markup v1 ?>
Hello, world!
<choices>
    Are you...
    <choice goto="roy">Roy</choice>
    <choice goto="richard">Richard</choice>
    <choice>Neither</choice>
</choices>
Hello... whoever you are!
<a goto="_exit" name="roy">
<!-- ↑ 从其他地方跳转到这里时，这里的goto不会执行 -->
Hi, <s color=12>Roy</s>!
<a goto="_exit" name="richard">
Hello <s color=15>Richard</s>!
```

另外，还可以用`<script>`元素来嵌入JavaScript代码。

## 赋值属性和条件属性

除了上文提到的属性之外，还可以给元素添加**赋值属性**和**条件属性**。每个元素最多添可以加一个赋值属性、一个条件属性。

**赋值属性**用来存储和修改变量。变量名可以由英文字母、数字、下划线组成，但不能以数字开头。目前变量只能是浮点数。赋值属性像这样表示：`set="变量名 := 表达式"`（`:=`表示赋值）。

赋值属性单独不会对剧情造成影响，要配合**条件属性**使用。条件属性用来控制元素是否会运行。条件属性有`if="表达式"`、`elif="表达式"`和`else`。带`elif`的元素必须紧跟在带`if`的元素后面，带`else`的元素必须跟在带`if`或`elif`的元素后面。

如果给定的条件成立（表达式的结果不是0），元素的内容、上面的`goto`和赋值属性会正常运行；否则整个元素会被跳过。如果是`<choice>`，则控制的是这个选项是否会显示。

元素上的属性总是按“条件属性——赋值属性——`goto`”的顺序执行，无论它们出现的顺序。

表达式中可以使用**数字字面量**（如`123`）、其他变量、**运算符**和圆括号。可用的运算符有：

1. 乘除运算符：乘法`*`、除法`/`、模`%`；
2. 加减运算符：加法`+`、减法`-`；
3. 比较运算符：相等`=`、大于`>`、小于`<`、不小于`>=`、不小于`<=`、不等`<>`，成立时得1，不成立得0；
4. 逻辑运算符：与`and`（如果左手边是0就得0，否则得右手边），或`or`（如果左手边不是0就得左手边，否则得右手边）。（例如`1 and 2`得2，`5 or 0`得5。）

在不加括号的情况下，运算顺序就按以上四类的顺序进行。

如果一个变量还没有创建，默认它的值是0。

```html
<a set="crap := 20">
<choices>
    这是一道选择题
    <choice set="crap := crap + 40">az</choice>
    <choice set="crap := crap * 4">az</choice>
    <choice set="crap := crap - 10">az</choice>
</choices>
<s if="crap < 20">
    crap现在小于20
</s>
<s elif="crap < 60">
    crap现在大于或等于20，小于60
</s>
<s else>
    crap现在大于或等于60
</s>
```

建议使用一个`_choice`变量来存储刚选择的选项，代替`goto`：

```html
<choices>
    Are you...
    <choice set="_choice := 1">Roy</choice>
    <choice set="_choice := 2">Richard</choice>
    <choice set="_choice := 3">Neither</choice>
</choices>
<s if="_choice = 1">
Hi, <s color=12>Roy</s>!
</s>
<s elif="_choice = 2">
Hello <s color=15>Richard</s>!
</s>
<s else>
Hello... whoever you are!
</s>
```

以上就是 Richard Markup 帮助文档的全部内容了。由于解释器还没有实现，此文档以后还可能会修改。