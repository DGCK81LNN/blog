---
title: "brainf和Befunge 99Bottles 和 FizzBuzz"
tags: "深奥编程语言"
---

## 99bottles.b

12月22日

```brainfuck
99 bottles of beer
 
获得初始瓶数99
>++++++++++[-<++++++++++>]<-
主循环
[
 
  >[输出当前瓶数（参考 https://esolangs.org/wiki/Brainfuck_algorithms ）]
  +<[>->++++++++++<<[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]>>[-]>>>++++++++++<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]>[-]>>[>++++++[-<++++++++>]<.<<+>+>[-]]<[<[->-<]++++++[->++++++++<]>.[-]]<<++++++[-<++++++++>]<.[-]<<[-<+>]]
 
  输出“ bottle”
  >>++++[-<++++++++>]<.[-] 输出空格并清理
  <++++++++++[->++++++++++>+++++++++++>++++++++++++<<<] 获得100、110、120
  >--.>+.>----..<---.<+++. 上下微调输出“bottle”
  >>[[-]<] 清理
 
  如果瓶数不是1则输出“s”
  <- 减1
  [->+>+<<] 复制两份
  >[-<+>] 其中一份挪回去
  >[[-] if块
    >+++++++++[-<+++++++++++++>]<--.[-] 输出“s”并清理
  ]<<+ 还原
 
  >[输出“ of beer on the wall,\n”]
  ++++[->++++++++<] 获得空格
  ++++++++++[->>++++++++++>+++++++++++>++++++++++++<<<<] 获得100、110、120
  >.>>+.<++.<.>----.+++..>+++.<<.>>---.-.<<.>>>----.<<+++.---.<.>>>+++.<<----.>--..
  >[[-]<] 清理
  >+++++[->+++++++++<]>-.[-] 输出逗号并清理
  ++++++++++.[-]输出换行符并清理
 
  输出当前瓶数
  <<+<[>->++++++++++<<[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]>>[-]>>>++++++++++<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]>[-]>>[>++++++[-<++++++++>]<.<<+>+>[-]]<[<[->-<]++++++[->++++++++<]>.[-]]<<++++++[-<++++++++>]<.[-]<<[-<+>]]
 
  输出“ bottle”
  >>++++[-<++++++++>]<.[-]
  <++++++++++[->++++++++++>+++++++++++>++++++++++++<<<]
  >--.>+.>----..<---.<+++.
  >>[[-]<]
 
  如果瓶数不是1则输出“s”
  <-
  [->+>+<<]
  >[-<+>]
  >[[-]
    >+++++++++[-<+++++++++++++>]<--.[-]
  ]<<+
 
  >[输出“ of beer.\nTake one down, pass it around,\n”]
  ++++++++++[->+++>+++++>++++++++++>+++++++++++>++++++++++++<<<<<] 获得30、50、100、110、120
  >++.>>>+.<++.<<.>>----.+++..>+++.<<----.<<++++++++++.
  >>>-----------------.+++++++++++++.>-------.<++++.<<.>>>++++.-.<.<<.>>-.>+.>-.<-.<<--.<.
  >>>++.<---.>+++..<<<.>>++++++++.>+.<<<.>>--------.>--.---.>--.<-.<+++.<.<<.
  [-]>[[-]>] 清理
 
  瓶数减1
  <<<<<<<-
 
  如果瓶数为0输出“No ”，否则输出瓶数
  >+<[ if块
    [->>>+<<<] 瓶数搬过来，防止输出数字干扰 if else 使用的临时单元格
 >>>>+<[>->++++++++++<<[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]>>[-]>>>++++++++++<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]>[-]>>[>++++++[-<++++++++>]<.<<+>+>[-]]<[<[->-<]++++++[->++++++++<]>.[-]]<<++++++[-<++++++++>]<.[-]<<[-<+>]]
    <[-<<<+>>>] 瓶数搬回去
  <<-<[->>+<<]]>>[-<<+>>]<[ else块
    >>>++++++++++[-<++++++++>>+++++++++++<] 获得80和110
    <--.[-] 输出“N”并清理
    >>+.[-] 输出“o”并清理
  <<<<-] 还原
 
  输出“ bottle”
  >++++[-<++++++++>]<.[-]
  ++++++++++[->++++++++++>+++++++++++>++++++++++++<<<]
  >--.>+.>----..<---.<+++.
  >>[[-]<]
 
  如果瓶数不是1则输出“s”
  <-
  [->+>+<<]
  >[-<+>]
  >[[-]
    >+++++++++[-<+++++++++++++>]
    <--.[-]
  ]<<+
 
  >[输出“ of beer on the wall.\n\n”]
  ++++[->++++++++<] 获得空格
  ++++++++++[->>++++++++++>+++++++++++>++++++++++++<<<<] 获得100、110、120
  >.>>+.<++.<.>----.+++..>+++.<<.>>---.-.<<.>>>----.<<+++.---.<.>>>+++.<<----.>--..
  >[[-]<] 清理
  >+++++[->+++++++++<]>+.[-] 输出句点并清理
  ++++++++++..[-] 输出空格并清理
 
<<<] 继续主循环
 
强行手动输出最后一段
++++++++++[->+>+++>+++++>++++++++>+++++++++>++++++++++>+++++++++++>++++++++++++<<<<<<<<] 获得10、30、50、80、90、100、110、120
>>>>--.>>>+.<<<<<++.>>>>--.>.>----..<---.<+++.>>-.<<<<<<.>>>>>+++.<+.<<<<.>>>>----.+++..>+++.<<<<<.
>>>>>---.-.<<<<<.>>>>>>+.<<+++.---.<<<<.>>>>>>+++.<<----.>--..<<<<------.<<.
>>>.>>>+++.<<<<<.>>>>+.>.>---..<---.<+++.>>-.<<<<<<.>>>>>+++.<+.<<<<.>>>>----.+++..>+++.<<<<++.<<.
>>>-------.>>>---.<<<<<.>>>>>>+.<.<<<<<.>>>>>>.<<+++.---.<<<<.>>>>>>-.+.<.+++.<.<<<--.<.
>>>>---.>>+.++++.<<<<<<.>>>>>>------.<---.--.<+++.<<<<.>>>>>.++.+++.<.<<<.<<.
>>+++++++++++++..<.>>>>---.>---.>+..<---.<+++.>>-.<<<<<<.>>>>>+++.<+.<<<<.>>>>----.+++..>+++.<<<<<.
>>>>>---.-.<<<<<.>>>>>>+.<<+++.---.<<<<.>>>>>>+++.<<----.>--..<<<<-----------.<<.
```

多次用到了这个代码片段：

```brainfuck
输出当前格的值。中途使用右手边的9个单元格。
>+<[>->++++++++++<<[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]>>[-]>>>++++++++++<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]>[-]>>[>++++++[-<++++++++>]<.<<+>+>[-]]<[<[->-<]++++++[->++++++++<]>.[-]]<<++++++[-<++++++++>]<.[-]<<[-<+>]]<
```


## 99bottles.b93

12月17日

```
v> >:#v_#v #"" oN"# ,,# <   >"s",>052*",llaw eht no reeb fo ">:#,_$v
9     >:.>"elttob",,,,,,:1-#^_   ^ v   _v#!-1:,,,,,,"bottle"<.:<
5* v\*25\0:$_ #!,#:<" of beer."*250<,"s"<  > #,, #"No ""#   ^#_^#!:<
6+v_",erom emos yub ,erots eht ot oG">:#,_$956+*.88*20pv  Befunge-93
 v>",dnuora ti ssap ,nwod eno ekaT">:#,_$1-:!#v_:.v    <>:#,_$25*:,,
 #   "on the wall."0<   _v#!-1:,,,,,,"bottle"< <  <     ^" of beer "
>^99 bottles of beer^,"s"<      > #,, #"No ""#<^ dgck81lnn.github.io
```

输出瓶数模块：

```
{in}>:v_#v #"" oN"# ,,# <   >"s",>{out}
      >:.>"elttob",,,,,,:1-#^_   ^
```

 栈顶 |     输出
----:|-------------
`99` | `99 bottles`
 `2` | `2 bottles`
 `1` | `1 bottle`
 `0` | `No bottles`


## fizzbuzz.b

12月25日

```brainfuck
初始化计数器
>++++++++++[-<++++++++++>]
( N=100 'n=0 )
<[->+
  [->+>+>>>+>>+<<<<<<<]
  ( N '0 n n 0 0 n 0 n )
  >[-<+>]
  >>+
  ( N n 0 n '1 0 n 0 n )
  n模3
  >>>>[
    ->+<[ ->+<[
      ->[-]
    ]]
  <]<[>]
  ( N n 0 n 1 0 n '0 0 {n%3} )
  如果余数为0就输出Fizz
  >+
  >[[-]<->]
  ( N n 0 n 1 0 n 0 {n%3==0?1:0} '0 )
  <[[-]
    <<<<<[-]
    >>>>>>+++++++[-<++++++++++>]<. F
    >+++++[-<+++++++>]<. i
    >++++[-<++++>]<+.. zz
    [-]
  ]
  ( N n 0 {n%3==0?0:n} 1 0 n 0 '0 )
  n模5
  <<[
    ->+<[ ->+<[ ->+<[ ->+<[
      ->[-]
    ]]]]
  <]<[>]
  ( N n 0 {n%3==0?0:n} 1 '0 0 {n%5} )
  如果余数为0就输出Buzz
  >+
  >[[-]<->]
  ( N n 0 {n%3==0?0:n} 1 0 {n%5==0} '0 )
  <[[-]
    <<<[-]
    >>>>++++++[-<+++++++++++>]<. B
    >+++++++[-<+++++++>]<++. u
    +++++.. zz
    [-]
  ]
  ( N n 0 {n%3==0||n%5==0?0:n} 1 0 '0 )
  <<-
  如果模3和模5都不为0就输出数字十进制
  ( N n 0 {n%3==0||n%5==0?0:n} '0 )
  <[
     ->+<[ ->+<[ ->+<[ ->+<[
     ->+<[ ->+<[ ->+<[ ->+<[ ->+<[
       ->[-]>+<
     ]]]]]]]]]
  <]<[>]
  ( N n '0 0 {n%3==0||n%5==0?0:n%10} {n%3==0||n%5==0?0:n/10} )
  >>[>]<[
    >++++++[-<++++++++>]<. 0~9
    [-]
  <]
  ( N n 0 '0 )
  换行
  ++++++++++.[-]
<<<]
```

## fizzbuzz.b93

12月24日

```
v>:3%:v ,,:,,<
1:v\  _1"ziF"^
>^>5%:v ,,:,,<
>|v\  _1"zuB"^
^@>*!#v_:v>*`!
+55:+1< .<^:,:
```

----

<p style="color:white">其实我最近有些个人的负面情绪需要宣泄，但我明白每个人都有自己的烦恼，是吧？我不会在网络上发出来影响大家的心情，即使是在这个几乎不会有人看到的网站上。朋友，如果你读到这里，我要感谢你的无形的陪伴。谢谢。</p>