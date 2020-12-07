---
published: false
title: "Richard Markup 帮助文档（草稿）"
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
```xml
<?richard-markup v1 ?>
```
其中`v1`是文件格式的版本号。

随后的内容是正文，由**文本**、**标签**、**注释**组成。

**文本**是除标签、注释外的文字内容，它会逐字显示在控制台上，一般每显示完一行后用户可以按任意键继续，并可以在逐字显示的过程中按任意键跳过。

**标签**会改变文本的行为。在 Richard Markup 中，标签有**类型**、**属性**、**内容**，其中只有类型是必须的。
**内容**一般是文本，但也可以包含其他标签。
每个**属性**又有**属性键**和**属性值**，属性键是必须的。如果没有值，直接写属性键即可；如果有值，用`属性键="属性值"`表示，如果属性值中没有空格，可以省略引号。

当标签没有内容时，用**自闭合标签**`<类型 />`表示，如果有属性，它们依次跟在类型之后，用空格隔开：
```xml
<类型 属性 属性... />
```
如果标签有内容，就把内容写在**开始标签**`<类型>`和**结束标签**`</类型>`之间，如果有属性，就写在开始标签的类型之后，用空格隔开：
```xml
<类型 属性 属性...>内容</类型>
```
当然，也可以让开始标签和结束标签单独占一行：
```xml
<类型 属性 属性...>
    内容
</类型>
```
解释器会在运行前先去掉多余的换行和空格：行首的空格会被忽略，并且如果一个自闭合标签、开始标签或结束标签或注释独占一行，那么紧挨在它们前面的换行会被忽略。

在 Richard Markup 中，每种标签要么必须有内容，要么不能有内容。所以对于不能有内容的标签类型， Richard Markup 规定它们的自闭合标签中的斜杠可以省略：`<类型>`。

**注释**会被 Richard Markup 解释器直接忽略。与 HTML 和 XML 一样，它这样表示：
```xml
<!-- 注释内容 -->
```

## Richard Markup 中的标签

### `<s>`标签

`<s>`标签代表文本片段，它必须有内容。

可以有一个`name`属性，指定片段的名称。也可以指定`color`属性来改变片段中文字的颜色：

```xml
<s name="welcome">
    欢迎来到<s color="#33bfab">灵魂小站</s>！
</s>
```

### `<a>`标签

`<a>`标签代表锚点（Anchor），它不能有内容。

可以有一个`name`属性指定锚点的名称。另外也可以有一个`goto`属性，值是另一个标签的`name`。这样一来，程序运行到此锚点后就会跳转到指定的标签处继续运行：

```xml
<a name="dead-loop">
    禁止死循环！
<a goto="dead-loop">
```

也可以把`goto`的值设为`_exit`来退出程序。

### `<choices>`和`<choice>`标签

`<choices>`代表一个互动选择题，它的内容是一行文本（可省略）后加若干个`<choice>`。可以给`<choices>`指定`name`属性。

`<choice>`表示一个选项，它的内容的选项的文案。可以有一个`goto`属性，指定当选项被选定后要跳转到的位置。

----

至此，已经完全可以制作一个简单的互动了：
```xml
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
