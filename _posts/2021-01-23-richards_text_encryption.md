---
tags: 编程 日常写代码
redirect_from: [ "/2021/01/23/richards_text_encryption.html" ]
last_modified_at: 2023-08-13T00:38+0800
---

# Richard写的文本加密算法

Richard在他的新作品中使用一种可逆的加密算法来把源代码中的文本加密成乱码。其实质很简单，类似于异或加密——把字符编码&zwnj;_“最高的一个有效位”_&zwnj;（即最高的一个1）以下的每一位都反转，如：


```
     $554A 啊
 v最高有效位
01010101 01001010
↓↓|||||| ||||||||
01101010 10110101
     $6AB5 檵
```
```
     $0052 R
          v最高有效位
00000000 01010010
↓↓↓↓↓↓↓↓ ↓↓||||||
00000000 01101101
     $006D m
```

## 原实现

虽然算法很简单，但由于历史原因，该算法的实现十分阴间。这是Python源代码（我调整了函数的顺序）：

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
    return int(encoded) # ???: 为什么要转成int？？？

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
    return int(binary) # ???: 为什么要转成int？？？

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

JS：
```javascript
function sts(string) {
    var out = "";
    [...string].forEach(char => {
        let codePoint = char.codePointAt(0),
            shifter = -1,
            temp = codePoint;
        while (temp & -2) {
            temp >>= 1;
            shifter <<= 1;
        }
        out += String.fromCodePoint(codePoint ^ ~shifter);
    });
    return out;
}
```

Richard只会Python，所以又给他写了个Python版：

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

```python
def fromBin(bin):
    assert isinstance(bin, str) # 永远不要把二进制数转换成int！！
    dec = 0
    for i in bin:
        dec <<= 1
        if i == "1":
            dec |= 1
    return dec

def toBin(dec):
    assert isinstance(dec, int)
    assert dec > 0
    bin = ""
    while dec:
        bin = str(dec & 1) + bin # 把新的数位追加到bin的开头
        dec >>= 1
    return bin
```

---

{:py: .highlight.language-py}

## 2023-08-12 更新

经过我的学习，`sts` 算法现已有更好的实现。

### 改良 `sts` 第二代

<ul class="nav nav-tabs" role='tablist'>
 <li class="nav-item" role='presentation'>
  <button class="nav-link active" id='v2-tab-py' data-bs-toggle='tab' data-bs-target="#v2-pane-py" type='button' role='tab' aria-controls='v2-pane-py' aria-selected='true'>Python</button>
 </li>
 <li class="nav-item" role='presentation'>
  <button class="nav-link" id='v2-tab-rb' data-bs-toggle='tab' data-bs-target="#v2-pane-rb" type='button' role='tab' aria-controls='v2-pane-rb'>Ruby</button>
 </li>
 <li class="nav-item" role='presentation'>
  <button class="nav-link" id='v2-tab-js' data-bs-toggle='tab' data-bs-target="#v2-pane-js" type='button' role='tab' aria-controls='v2-pane-js'>JavaScript</button>
 </li>
 <li class="nav-item" role='presentation'>
  <button class="nav-link" id='v2-tab-lua' data-bs-toggle='tab' data-bs-target="#v2-pane-lua" type='button' role='tab' aria-controls='v2-pane-lua'>Lua (Scribunto)</button>
 </li>
</ul>
<div class="tab-content" markdown='1'>
  <div class="tab-pane fade show active" id='v2-pane-py' role='tabpanel' aria-labelledby='v2-tab-py' tabindex='0' markdown='1'>
~~~py
def sts(string):
    out = ""
    for char in string:
        codePoint = ord(char)
        bits = codePoint >> 1
        bits |= bits >> 1
        bits |= bits >> 2
        bits |= bits >> 4
        bits |= bits >> 8
        bits |= bits >> 16
        out += chr(codePoint ^ bits)
    return out
~~~
  </div>
  <div class="tab-pane fade" id='v2-pane-rb' role='tabpanel' aria-labelledby='v2-tab-rb' tabindex='0' markdown='1'>
~~~ruby
def sts(string)
  out = String.new(encoding: "UTF-8")
  string.each_codepoint do |codePoint|
    bits = codePoint >> 1
    bits |= bits >> 1
    bits |= bits >> 2
    bits |= bits >> 4
    bits |= bits >> 8
    bits |= bits >> 16
    out << (codePoint ^ bits)
  end
  out
end
~~~
  </div>
  <div class="tab-pane fade" id='v2-pane-js' role='tabpanel' aria-labelledby='v2-tab-js' tabindex='0' markdown='1'>
~~~js
function sts(string) {
  let out = ""
  for (let char of string) {
    const codePoint = char.codePointAt(0)
    let bits = codePoint >> 1
    bits |= bits >> 1
    bits |= bits >> 2
    bits |= bits >> 4
    bits |= bits >> 8
    bits |= bits >> 16
    out += String.fromCodePoint(codePoint ^ tmp)
  }
  return out
}
~~~
  </div>
  <div class="tab-pane fade" id='v2-pane-lua' role='tabpanel' aria-labelledby='v2-tab-lua' tabindex='0' markdown='1'>
~~~lua
local bit32 = require("bit32")
local ustring = mw.ustring

local function sts(str)
  local out = ""
  for codePoint in ustring.gcodepoint(str) do
    local bits = bit32.rshift(codePoint, 1)
    bits = bit32.bor(bits, bit32.rshift(bits, 1))
    bits = bit32.bor(bits, bit32.rshift(bits, 2))
    bits = bit32.bor(bits, bit32.rshift(bits, 4))
    bits = bit32.bor(bits, bit32.rshift(bits, 8))
    bits = bit32.bor(bits, bit32.rshift(bits, 16))
    out = out .. ustring.char(bit32.bxor(codePoint, bits))
  end
  return out
end
~~~
  </div>
</div>

运用类似 MSB（最高有效位）算法的一系列按位运算，就可以得到字符编码中需要反转的位掩码（`bits`{: py}，也是第一版改良实现中的 `~shifter`{: py}），无需使用之前的 `while`{: py} 循环。这种 MSB 计算方法要求操作是 32 位整数，否则需要调整 `tmp |= tmp >> N`{: py} 语句的数量；不过因为字符编码最多超不过 21 位，所以实际上不用担心。

此版本虽然在 Python、Ruby 领域已被下文的新版本取代，但在使用 JavaScript、Lua 等没有（或由于某些原因选择不使用）可变长度整数或原生 MSB 函数的编程语言实现时，仍然是最优的方法。

### 改良 `sts` 第三代

<ul class="nav nav-tabs" role='tablist'>
 <li class="nav-item" role='presentation'>
  <button class="nav-link active" id='v3-tab-py' data-bs-toggle='tab' data-bs-target="#v3-pane-py" type='button' role='tab' aria-controls='v3-pane-py' aria-selected='true'>Python</button>
 </li>
 <li class="nav-item" role='presentation'>
  <button class="nav-link" id='v3-tab-rb' data-bs-toggle='tab' data-bs-target="#v3-pane-rb" type='button' role='tab' aria-controls='v3-pane-rb'>Ruby</button>
 </li>
</ul>
<div class="tab-content" markdown='1'>
 <div class="tab-pane fade show active" id='v3-pane-py' role='tabpanel' aria-labelledby='v3-tab-py' tabindex='0' markdown='1'>
~~~py
def sts(string):
    out = ""
    for char in string:
        codePoint = ord(char)
        out += chr(codePoint ^ ~(-1 << (codePoint.bit_length() - 1)))
    return out
~~~
 </div>
 <div class="tab-pane fade" id='v3-pane-rb' role='tabpanel' aria-labelledby='v3-tab-rb' tabindex='0' markdown='1'>
~~~ruby
def sts(string)
  out = String.new(encoding: "UTF-8")
  string.each_codepoint do |codePoint|
    out << (codePoint ^ ~(-1 << (codePoint.bit_length - 1)))
  end
  out
end
~~~
 </div>
</div>

Python、Ruby 中的整型是可变长度的，可以直接通过其 `bit_length` 方法求得长度，于是获得刚才所说的 `bits` 就更简单了，它就是 `~(-1 << (cp.bit_length() - 1))`{: py}，或 `(1 << (cp.bit_length() - 1)) - 1`{: py}。

### 速度测试

在 Python 中用四个版本的 `sts` 对这段示例文本

    经过两个多月的网课，疫情基本结束，学校终于要复课了。
    
    2020.4.20。复课的第一天，我满怀期待地走进了校门。熟悉的景象在我眼前展开，只是所有人都戴了个口罩。顶着大风，仿佛回到了二三月份。
    
    走在我前面的是我的8B班同学Richard。三个多月没看见他，他在我眼中更加高大了。我在网课时曾屡次想念过他，现在，我可以以学习为理由来接近他，和他在一起。
    
    我在上个学期观察过他，他很少和Sunny说话，Sunny也没有去主动找他。但我猜不出他是否已经放弃了Sunny。机不可失时不再来，我得在结课考之前追求到他。

分别进行加密操作测试，结果如下：

{: .table}
|     版本     | 实验次数 | 平均用时（毫秒） |
|:------------:|:--------:|:----------------:|
| Richard 原版 |      500 |            5.688 |
|   改良一代   |     5000 |            0.595 |
|   改良二代   |    50000 |            0.192 |
|   改良三代   |    50000 |            0.116 |
