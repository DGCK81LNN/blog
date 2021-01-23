---
title: Richard写的文本加密算法
---

Richard在他的新作品中使用一种可逆的加密算法来把源代码中的文本加密成乱码。其实质很简单，类似于异或加密——把字符编码&zwnj;_“最高的一个有效位”_&zwnj;（即最高的一个1）以下的每一位都反转，如：

```
     $554A 啊
 ↓最高有效位
01010101 01001010
↓↓|||||| ||||||||
01101010 10110101
     $6AB5 檵
```
```
     $0052 R
          ↓最高有效位
00000000 01010010
↓↓↓↓↓↓↓↓ ↓↓||||||
00000000 01101101
     $006D m
```

## 原实现

虽然算法很简单，但由于历史原因，该算法的实现十分阴间。这是源代码（我调整了函数的顺序）：

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
def sts(origin): # OPTIMIZE
    """加密/解密主函数。
    
    由于实质上是异或加密，所以加密和解密是同一个算法。
    """
    resultEncoded = ""
    originEncoded = str(stn(origin)) # 第一步是调用stn()，先看stn()的定义
    isHighestBit = True
    for bit in originEncoded: # 这个循环用来进行迫真按位运算
        if isHighestBit:
            resultEncoded += bit
            isHighestBit = False
        elif bit == '0':
            resultEncoded += '1'
        elif bit == '1':
            resultEncoded += '0'
        else:
            resultEncoded += '2'
            isHighestBit = True
    return nts(resultEncoded) # 最后调用nts()，看nts()的定义

def stn(string):
    """把每个字符的字符编码转换成二进制数，然后每个数后用'2'连接。
    
    如："ABC" → "100000121000010210000112"
    """
    # 实际上，一开始采用的加密算法是这个函数；
    # 由于密文的体积太大，才有了现在的版本。
    encoded = ""
    for char in string:
        encoded += str(num10t2(ord(char))); # 对char的代码点调用了num10t2()
        encoded += '2'
    return int(encoded) # HACK: 为什么要转成int？？？

def num10t2(decimal):
    """把正整数用二进制表示。
    """
    reversedBinary = ""
    binary = ""
    while decimal > 0:
        reversedBinary += str(decimal % 2) # OPTIMIZE: 建议改成：decimal & 1
        # OPTIMIZE: 为什么要事后手动倒转字符串，而不是直接把这里新增的字符拼接在字符串的开头？
        decimal = int(decimal / 2) # OPTIMIZE: decimal >>= 1 它不香吗？
    for i in range(len(reversedBinary)):
        binary += reversedBinary[len(reversedBinary) - i - 1]
    return int(binary) # HACK: 为什么要转成int？？？

def nts(encoded):
    """解码“encode()”生成的密文。
    """
    binaryBuffer = "" # 存储一个二进制数，遇到'2'就拿走使用并清空
    binaryList = []
    for bit in str(encoded):
        if bit == '2':
            binaryList.append(int(binaryBuffer)) # HACK: 为什么要转成int？？？
            binaryBuffer = ""
        else:
            binaryBuffer += bit
    decoded = ""
    for binary in binaryList:
        decoded += chr(num2t10(binary)) # 对代码点的二进制调用了num2t10()
    return decoded

def num2t10(binary):
    """解析二进制数。
    """
    # OPTIMIZE
    # 这算法看得我人都傻了
    binary = str(binary)
    reversedBinary = ""
    decimal = 0
    for i in range(len(binary)):
        reversedBinary += binary[len(binary) - i - 1]
    for i in range(len(reversedBinary)):
        decimal += int(reversedBinary[i]) * pow(2, i) # 1 << i 它不香吗？
        # 就算要乘方，** 运算符不知道？？
    return decimal
```

我必须吐槽`num10t2`和`num2t10`这两个函数名，人家整数本来就是按二进制存储的，显示成十进制只是为了给人看的；况且好好的按位运算，非要用字符串来实现，白拼接那么多次字符串。于是我重写了一下这个算法。

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

Richard只会Python，所以又给他写了个Python版：

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

又写了个Ruby版练手：

(Ruby)
```ruby
def sts(string)
    out = ""
    string.each_codepoint do |codePoint|
        shifter = -1
        temp = codePoint
        until (temp & -2).zero?
            temp >>= 1
            shifter <<= 1
        end
        out << (codePoint ^ ~shifter)
    end
    out
end
```

----

顺便用按位运算重新实现了`num10t2()`和`num2t10()`：

(Python)
```python
def toBin(bin):
    assert isinstance(bin, str) # 永远不要把二进制数转换成int！！
    dec = 0
    for i in bin:
        dec <<= 1
        if i == "1":
            dec |= 1
    return dec

def fromBin(dec):
    assert isinstance(dec, int)
    assert dec > 0
    bin = ""
    while dec:
        bin = str(dec & 1) + bin # 把新的数位追加到bin的开头
        dec >>= 1
    return bin
```
