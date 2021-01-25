---
tags: esolang
---

# brainfuck二进制转十进制

*欸――朋友们好啊，我是普通的高中生DGCK81LNN。刚才有个朋友问我L老师发生甚么事了，我说怎么回事，给我发过来一……几张截图，我一看，嗷，原来是昨天，有一个同学，塔说，欸……我写了个程序，二进制转十进制：*
```cpp
#include<iostream>
#include<cmath>
using namespace std;
int main() {
    long long a;
    cin>>a;
    int n=0,c=0;
    while(a>=1){
        n=n+(a%10)*pow(2,c);
        a=a/10; 
        c++;
    }
    cout<<n<<endl;
    return 0;
}
```
*但是超过(2^20-1)了就不好用，L老师你能不能教教我更好的方法，帮助治疗一下我的程序。他一说我啪地就站起来了，很快啊！我说你这个没用，我这个有用：*
```cpp
#include <iostream>
using namespace std;
int main() {
    char a = getchar();
    unsigned long long n = 0;
    while (a == '0' || a == '1') {
        n <<= 1;
        if (a == '1')
            n |= 1;
        a = getchar();
    }
    cout << n << endl;
    return 0;
}
```
*当时就流眼泪了，他说L老师对不――对不起，我是……他说他是乱写的，他可不是乱写的啊！取模、乘方、整除，训练有素。后来他说他学过三四个星期算法，啊看来是――有备而来。我劝！这位同学――耗子尾汁，好好反思，以后――不要再犯――这样的聪明*（指把二进制当作十进制读入）*，小聪明啊！*

<!--硬核彩条屏--><div style="height:30rem;width:100%;max-width:50rem"><div style="height:70%"><div style="width:14.2857%;height:100%;display:inline-block;background:#ccc"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#cc1"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#1cc"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#1c1"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#c1c"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#c11"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#11c"> </div></div><div style="height:10%"><div style="width:14.2857%;height:100%;display:inline-block;background:#11c"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#111"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#c1c"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#111"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#1cc"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#111"> </div><div style="width:14.2857%;height:100%;display:inline-block;background:#1c1"> </div></div><div style="height:20%"><div style="width:17.8571%;height:100%;display:inline-block;background:#118"> </div><div style="width:17.8571%;height:100%;display:inline-block;background:#eee"> </div><div style="width:17.8571%;height:100%;display:inline-block;background:#51c"> </div><div style="width:46.4285%;height:100%;display:inline-block;background:linear-gradient(to right,#111,#ccc)"> </div></div></div>

（⬆这是一堆带background-color的&lt;div&gt;，硬核彩条屏）

随后我突发奇想，能不能用brainf写一个二进制转十进制。最后搞出来这么个东西。

由于把读到的数直接存在了一个单元格里，能处理的数据位数取决于单元格的数据类型，如单字节的单元格就最多可以算到255。

```brainfuck
bin2dec

先在这存个负1，稍后作为输出结束的标识。
->>>
【读入二进制数】
{ －1 0 n=0 'a=0 }
只读取一行输入，读到换行符或EOF就离开循环。
++++++++++,----------[ 循环体开始
 现在读到的东西不是换行符，假设它只能是0（48）或1（49）。
 且它已经在上一行被减了10，所以现在只能是38或39。
 { －1 0 n 'a=38\39 }
 因为读到了新的数位，所以把n乘以2。
 <[-<+>] 把n放在左边一格
 { －1 n '0 a }
 <[->++<] 再乘2挪回来
 { －1 '0 n=2n a }
 把a减去38，使它变成0或1。
 >>>++++++[-<------>] 先减6个6
 <-- 再减2
 { －1 0 n 'a=0\1 }
 给n加上a。
 [-<+>]
 { －1 0 n=n＋a '0 }
++++++++++,----------] 循环体结束
{ －1 0 n '0 }
【把得到的数用十进制表示】
<[
 现在n是我们要处理的数。
 把n除以10，余数放在左边一格，商放在右边一格。
 { … 余数=0 'n 商=0 }
 -<+>[ 把n一个一个地挪到左边一格，如果n=0了就停停，这样操作最多9次。
  -<+>[ -<+>[ -<+>[ -<+>[
  -<+>[ -<+>[ -<+>[ -<+>[ 如果完成后n还不是0，
   ->+<<[-] 就再给n减1，把左边一格清零，右边一格加1。
   >>[<] 为防止n为0导致意外退出循环，强行把指针移到一个不是0的格子左边。
   现在如果n为0，指针在n上；否则指针在已经清空的余数格子上。
   由于一定是0，可以安全退出10层循环。
  ]]]]]]]]
 ]
>] 如果n为0了，就把商当作新的n进行同样的操作，否则指针回到n上继续计算。
上面的运算一直进行到商为0为止。
现在内存里是一个负1后面紧跟着得到的十进制数从低到高的每一位。
【输出得到的十进制数】
向左遍历直到负1那里为止。
<<+[-
 给数加上48，得到数字的ASCII。
 >++++++[-<++++++++>]
 输出得到的数位，然后把它清零。
 <.[-]
<+]
最后输出换行符。
++++++++++.
```

*欸――写程序，要以和为贵，要讲码德，不要搞――浪费内存。谢谢朋友们！*



----



DGCK81LNN<br>2020年12月4日 (五) 08:03 (CST)

**参考资料**
* [Brainfuck Base expansion](http://mazonka.com/brainf)





----



```brainfuck
赠品：dec2bin（
与bin2dec大同小异，不加注释了，请对照阅读
->>>
++++++++++,----------[
 <[-<+>]
 <[->++++++++++<]
 >>>++++++[-<------>]
 <--
 [-<+>]
++++++++++,----------]
<[
 -<+>[
  ->+<<[-]
  >>[<]
 ]
>]
<<+[-
 >++++++[-<++++++++>]
 <.[-]
<+]
++++++++++.
```
