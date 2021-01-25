---
soulblog-footer-links:
  -
    href: "https://github.com/DGCK81LNN/LoveWithRichard"
    text: "LoveWithRichard 旧版本"
  -
    href: "https://dgck81lnn.github.io/apps/lab/console.html?path=/res/down/SoulLC/LoveWithRichard.soullc.mjs"
    text: "LoveWithRichard V3 网页版"
---

# Richard Markup 帮助文档 v2

**Richard Markup** 是我专为 Richard （[@天府灵山行者](https://space.bilibili.com/300711293)）的互动式小说设计的一种文本标记语言，它注重剧情逻辑，而数据存储、用户界面由解释器完成。

Richard Markup **v2** 抛弃了形似 HTML 的“标签”语法，混合使用缩进和大括号来表示文档结构。

## 文件结构

Richard Markup 存储为`.richard`扩展名的文件。

文件的开头是头部信息，它写在`<?` `?>`之间：

```
<?richard-markup v2 target=soullc charset=gb18030?>
```

其中`v2`是文件格式的版本号，`target=soullc`表示此 Richard Markup 文件是用来在*灵魂实验室控制台*运行的剧情文件，`charset=gb18030`表示文件使用 GB-18030 字符编码存储。

随后的内容是正文，由**文本**、**元素**、**注释**组成。

**文本**是除元素、注释外的文字内容，它会逐字显示在控制台上，一般每显示完一行后用户可以按任意键继续，并可以在逐字显示的过程中按任意键跳过。

**元素**会改变文本的行为。每个元素都有一个**类型**，还可能有若干个**属性**和一些**内容**。

在 Richard Markup v2 中元素有两种写法，**块状**和**行内**：

```
一个块状 s 元素：
@s: 这是块状 s 元素的内容。
    这也是。
    这还是。

一个行内 s 元素：{@s|这是行内 s 元素的内容。}
```

这里的两个`s`元素分别是块状元素和行内元素。

有一种元素类型――`a`，它不可以有内容，因此写法也有些不同：

```
一个块状 a 元素：
@a

一个行内 a 元素：{@a}
```

块状元素的内容可以包含另一个块状元素，而行内元素则不行；而块状和行内元素的内容都可以包含行内元素。

```
第一个块状 s 元素：
@s:
    这行文本属于第一个块状 s 元素。
    第二个块状 s 元素在第一个块状 s 元素里面：
    @s:
        {@s|{@s|{@s|{@s|禁止套娃！{@a}}}}}
        这行文本属于第二个块状 s 元素。
    @a
    这行文本还是属于第一个块状 s 元素。
```

如果元素有**属性**，它们写在元素的类型之后：

```
@s name=myElement color=red:
    这个块状 s 元素有一个 name 属性，属性的值为 myElement；
    还有一个 color 属性，值为 red。

{@s name=anotherElement|这个行内 s 元素有一个 name 属性。}
```

每个属性的**名称**和**值**用等于号分隔；如果值里有空格等引起歧义的字符，要用单引号或双引号围起来。有的属性没有值，这时不用写等号。

块状元素的属性还可以这样写：

```
@s
    if="myVariable == 1"
    set="myVariable = 0"
    name=myElement
    color=red bgcolor=white
:
    这个 s 元素有很多属性。

@a
    else if="myVariable == 2"
    call=myElement
```

以井号开头的一行是**注释**，会被 Richard Markup 解释器忽略：

```
# 这是注释。
```

注意 Richard Markup 中的注释必须独占一行，不能写在一行正文的末尾。

## 元素和属性串讲

### `s`元素

`s`元素代表文本片段，它必须有内容。

可以有一个`name`属性，指定片段的名称。也可以指定`color`属性来改变片段中文字的颜色。

```
@s name=welcome:
    欢迎来到{@s color=#33bfab|灵魂小站}！
```

### `a`元素

`a`元素代表锚点（Anchor）。上文中已经讲过，它不能有内容。

可以有一个`name`属性指定锚点的名称。另外也可以设置一个`call`属性，值是另一个有内容的元素的`name`，这样来重复使用那个元素。例如：

```
Love with {@s name=richard color=#baf|Richard} under epidemic
8B班同学{@a call=richard}。
```

块状`a`元素应当`call`一个块状元素，行内`a`元素应当`call`一个行内元素。

### `def`元素

`def`元素专门用来定义需要重复使用的子程序（函数）。可以直接在它里面写若干个有`name`属性的元素，然后在其他地方用`call`属性来调用。如果程序在正常按顺序运行时，中途遇到`def`元素，会直接跳过。

```
@def:
    {@s name=richard color=#baf|Richard}
    {@s name=sunny color=#daf|Sunny}
    @s name=separator:
        Love with {@a call=richard} under epidemic
        ♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡♡
```

### `choices`、`choice`和`prompt`元素

`choices`代表一个互动选择题，它的内容是一个可省略的`prompt`和若干个`choice`。可以给`choices`指定`name`属性。

`prompt`表示选择题的提示文本；`choice`表示一个选项，它的内容是选项的文案。可以有一个`goto`属性，指定当选项被选定后要跳转到的位置。

```
Hello, world!
@choices:
    {@prompt|Are you...}
    {@choice call=youare_roy|Roy}
    {@choice call=youare_richard|Richard}
    {@choice call=youare_neither|Neither}
@def:
    @s name=youare_roy:
        Hi, {@s color=12|Roy}!
    @s name=youare_richard:
        Hello {@s color=15|Richard}!
    @s name=youare_neither:
        Hello... whoever you are!
```

----

另外，还可以用`script`元素来嵌入JavaScript代码。

## `if`、`else`和`set`属性

除了上文提到的属性之外，还可以给元素添加`if`、`else`和`set`属性。

`set`属性用来存储和修改变量。变量名可以由英文字母、数字、下划线组成，但不能以数字开头。目前变量只能是浮点数。`set`属性像这样表示：`set="变量名 = 表达式"`。

`set`属性单独不会对剧情造成影响，要配合`if`和`else`属性使用。这两个属性用来控制元素是否会运行。`else`属性没有值，直接在开始标签中写`else`即可；`if`属性的值是一个表达式，像这样：`if="表达式"`。带`else`的元素必须跟在带`if`的元素后面；可以连用`else`和`if`来达到“elif”的效果。

如果给定的条件成立（表达式的结果不是0），元素的内容、上面的`call`和`set`属性会正常运行；否则整个元素会被跳过。如果是`choice`，则控制的是这个选项是否会显示。

元素上的属性总是按“`else`——`if`——`set`——`call`”的顺序执行，无论它们实际出现的顺序。

表达式中可以使用**数字字面量**（如`123`）、其他变量、**运算符**和圆括号。可用的运算符有：

1. 乘除运算符：乘`*`、除`/`、取模`%`；
2. 加减运算符：加`+`、减`-`；
3. 比较运算符：等于`==`、大于`>`、小于`<`、大于或等于`>=`、小于或等于`<=`、不等于`!=`；
4. 逻辑运算符：与`and`、或`or`。

在不加括号的情况下，运算顺序就按以上四类的顺序进行，且`and`比`or`先进行。

如果一个变量还没有创建，默认它的值是0。

```
@a set="crap = 20";
@choices:
    {@prompt:这是一道选择题}
    {@choice set="crap = crap + 40"|az}
    {@choice set="crap = crap * 4"|az}
    {@choice set="crap = crap - 10"|az}
@s if="crap < 20":
    crap现在小于20
@s else if="crap < 60":
    crap现在大于或等于20，小于60
@s else:
    crap现在大于或等于60
```

建议使用一个`_choice`变量来存储选择的选项，代替`goto`：

```
@choices:
    {@prompt:Are you...}
    {@choice set="_choice = 1"|Roy}
    {@choice set="_choice = 2"|Richard}
    {@choice set="_choice = 3"|Neither}
@s if="_choice == 1":
    Hi, {@s color=12|Roy}!
@s else if="_choice == 2":
    Hello {@s color=15|Richard}!
@s else:
    Hello... whoever you are!
```
