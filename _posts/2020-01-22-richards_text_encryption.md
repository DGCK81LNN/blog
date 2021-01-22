---
title: Richard写的文本加密算法
---

Richard在他的新作品中使用一种可逆的加密算法来把源代码中的文本加密成乱码。其实质很简单，类似于异或加密——把字符编码最高的一个1位以下的每一位都反转，如：

```plaintext
     $554A 啊
 ↓最高的1位
01010101 01001010
↓↓|||||| ||||||||
01101010 10110101
     $6AB5 檵

     $0052 R
          ↓最高的1位
00000000 01010010
↓↓↓↓↓↓↓↓ ↓↓||||||
00000000 01101101
     $006D m
```

## 原实现

虽然算法很简单，但由于历史原因，该算法的实现十分阴间：

(Python)
```python
def sts(str1):
    b=""
    a=stn(str1)
    x=1
    for i in str(a):
        if x==1:
            b+=i
            x=0
        elif i=="0":
            b+="1"
        elif i=="1":
            b+="0"
        else:
            b+="2"
            x=1
    str2=nts(b)
    return str2

def nts(a):
    str1=""
    ls=[]
    for k in str(a):
        if k=="2":
            ls.append(int(str1))
            str1=""
        else:
            str1+=k
    b=""
    for i in ls:
        b+=chr(num2t10(i))
    return b

def num2t10(num):
    num=str(num)
    num1=""
    num2=0
    for i in range(len(num)):
        num1+=num[-i-1]
    for j in range(len(num1)):
        num2+=int(num1[j])*(2**j)
    return num2

def stn(str1):
    a=""
    for i in str1:
        a+=str((num10t2(ord(i))))
        a+="2"
    return int(a)

def num10t2(num):
    str1=""
    str2=""
    while num>0:
        c=num%2
        str1+=str(c)
        num=int(num/2)
    for i in range(len(str1)):
        str2+=str1[-i-1]
    return int(str2)
```

为了方便理解，这是我修改了变量名的版本：

(Python)
```python
# sts()
def 加密解密(原文):
    """
    加密/解密主函数。
    由于实质上是异或加密，所以加密和解密是同一个算法。
    """
    结果编码 = ""
    原文编码 = str(编码(原文))
    是最高位 = True
    for 位 in 原文编码:
        if 是最高位:
            结果编码 += 位
            是最高位 = False
        elif 位 == '0':
            结果编码 += '1'
        elif 位 == '1':
            结果编码 += '0'
        else:
            结果编码 += '2'
            是最高位 = True
    return 解码(结果编码)

# stn()
# 实际上，一开始采用的加密算法是这个函数；
# 由于密文占用的空间太大，才有了现在的版本。
def 编码(明文):
    """
    把每个字符的字符编码转换成二进制数字符串，每个数后用'2'隔开。
    如："ABC" → "100000121000010210000112"
    """
    结果 = ""
    for 字符 in 明文:
        结果 += str(十进制转二进制(ord(字符)));
        结果 += '2'
    return int(结果)
    #      ^^^ 为什么要转成int？？？

# num10t2()
def 十进制转二进制(十进制):
    """
    把正整数用二进制表示。
    """
    倒序二进制 = ""
    二进制 = ""
    while 十进制 > 0:
        倒序二进制 += str(十进制 % 2)
        # 为什么要事后手动倒转字符串，
        # 而不是直接把新增的字符拼接在字符串的开头？
        十进制 = int(十进制 / 2)
    for i in range(len(倒序二进制)):
        二进制 += 倒序二进制[len(倒序二进制) - i - 1]
    return int(二进制)

# nts()
def 解码(密文):
    """
    解码“编码()”生成的密文。
    """
    缓冲区 = ""
    二进制列表 = []
    for 位 in str(密文):
        if 位 == '2':
            二进制列表.append(int(缓冲区))
            缓冲区 = ""
        else:
            缓冲区 += 位
    结果 = ""
    for 二进制 in 二进制列表:
        结果 += chr(二进制转十进制(二进制))
    return 结果

# num2t10()
def 二进制转十进制(二进制):
    """
    解析二进制数。
    """
    二进制 = str(二进制)
    倒序二进制 = ""
    十进制 = 0
    for i in range(len(二进制)):
        倒序二进制 += 二进制[len(二进制) - i - 1]
    for j in range(len(倒序二进制)):
        十进制 += int(倒序二进制[j]) * pow(2, j)
        # 按位运算都不会，非要算2的乘方？^^^^^
        # 就算用乘方，** 运算符不知道？？
    return 十进制
```

我必须吐槽“num10t2”和“num2t10”这两个函数名，人家整数本来就是按二进制存储的，显示出十进制只是为了给人看的；况且好好的按位运算，非要用字符串来实现，白拼接那么多次字符串。于是我重写了一下这个算法。

## 我重写的算法

(JS)
```javascript
function sts(string) {
    var out = "";
    [...string].forEach(char => {
        let codePoint = str.codePointAt(char),
            shifter = -1,
            temp = codePoint;
        while (temp & -2) {
            temp >>>= 1;
            shifter <<= 1;
        }
        out += String.fromCodePoint(codePoint ^ ~shifter);
    });
    return out;
}
```

(Python)
```python
def sts(string):
    out = ""
    for char in string:
        codePoint = ord(char)
        shifter = -1
        temp = codePoint
        while temp & -2:
            temp >>= 1
            shifter <<= 1
        out += chr(codePoint ^ ~shifter)
    return out
```

(Ruby)
```ruby
def sts(str)
    out = ""
    str.each_codepoint do |codePoint|
        shifter = -1
        temp = codePoint
        while !(temp & -2).zero?
            temp >>= 1
            shifter <<= 1
        end
        out << (codePoint ^ ~shifter)
    end
    out
end
```

就算要把正整数表示为二进制和解析二进制数，也应该用按位运算：

(Python)
```python
def toBin(bin):
    assert isinstance(bin, str) # 如果bin不是字符串就报错
    # 永远不要把二进制数转换成int！！
    dec = 0
    for i in bin:
        dec <<= 1
        if i == "1":
            dec |= 1
    return dec

def fromBin(dec):
    assert isinstance(dec, int) # 如果dec不是整数就报错
    assert dec > 0 # 如果“dec>0”不成立就报错
    bin = ""
    while dec: # 即 while dec != 0
        bin = str(dec & 1) + bin # 把数位追加到bin的开头
        dec >>= 1
    return bin
```
