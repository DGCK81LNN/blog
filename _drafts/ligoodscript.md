# ligoodscript



替换JS的token

token|alternative
:---:|---
`;`|`啊`<br>`好吧`<br>`对吧`<br>`行吧`
`,`|`还有`
`(`...`)`|`先看`...`这事`<br>`没有什么要说的`
`[`...`]`|`里面的`...`这一项`<br>`都有`...`这几个`
`{`...`}`|`所以的话`..`没问题吧`
`...`|`打开`
`:`|`这就是`
`.`|`的`
`+`|`加上`<br>`正的`
`-`|`减去`<br>`负的`
`*`|`乘上`
`/`|`除以`<br>`比上`
`%`|`模`
`=`|`就变成了`
`===`|`等于`
`!==`|`不等于`
`>`|`大于`<br>`严格大于`
`<`|`小于`<br>`严格小于`
`>=`|`大于等于`
`<=`|`小于等于`
`?`...`:`|`的话就是`...`不然就是`
`var`|`有一个`
`if`|`你要明白`
`else`|`扯远了`
`do`|`咱们看`
`while`|`我再强调一下`
`for`|`我就说一件事`
`continue`|`一会我简单说一说`
`break`|`我不再说了`
`function`|`这题`
`return`|`这题得`
`=>`|`然后让你求一下`

some shit:

(ive added spaces between tokens but they are optional)

```
有一个 width 就变成了 0
  还有 d 就变成了 code 的 split 先看 "\n" 这事 的 map 先看 line 然后让你求一下 所以的话
    你要明白 先看 width 严格小于 line 的 width 这事
      width 就变成了 line 的 width 好吧
    这题得 都有 打开 line 这几个 的 map 先看 char 然后让你求一下
      一个新的 BefungeCell 先看 char 这事
    这事 啊
  没问题吧 这事
  还有 height 就变成了 d 的 length 行吧
d 的 forEach 先看 line 然后让你求一下 所以的话
  我再强调一下 先看 line 的 width 严格小于 width 这事
    line 的 push 先看 一个新的 BefungeCell 没有什么要说的 这事 对吧
没问题吧 这事 啊
d 的 forEach 先看 先看 line 还有 i 这事 然后让你求一下 所以的话
  我就说一件事 先看 有一个 j 就变成了 0 啊 j 严格小于 width 对吧 j 就变成了 j 加上 1 这事 所以的话
    line 里面的 j 这一项 的 attachCellDown 先看 d 里面的 i 加上 1 严格小于 height 的话就是 i 加上 1 不然就是 0 这一项 里面的 j 这一项 这事 对吧
    line 里面的 j 这一项 的 attachCellRight 先看 line 里面的 j 加上 1 严格小于 width 的话就是 j 加上 1 不然就是 0 这一项 这事 对吧
  没问题吧
没问题吧 这事 啊
```
