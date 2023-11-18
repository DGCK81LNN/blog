---
tags: 编程 日常写代码
redirect_from: [ "/2021/01/23/richards_text_encryption.html" ]
last_modified_at: 2023-11-18T10:41+0800
---

# Richard写的文本加密算法

Richard在他的新作品中使用一种可逆的加密算法来把源代码中的文本加密成乱码。其实质很简单，类似于异或加密——把字符编码&zwnj;_“最高的一个有效位”_&zwnj;（即最高的一个1）以下的每一位都反转，如：


```
     $554A 啊
 V最高有效位
01010101 01001010
VV|||||| ||||||||
01101010 10110101
     $6AB5 檵
```
```
     $0052 R
          V最高有效位
00000000 01010010
VVVVVVVV VV||||||
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

<ul class="nav nav-underline px-2 " role='tablist'>
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
    out += String.fromCodePoint(codePoint ^ bits)
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

运用类似 MSB（最高有效位）算法的一系列按位运算，就可以得到字符编码中需要反转的位掩码（`bits`{: py}，也是第一版改良实现中的 `~shifter`{: py}），无需使用之前的 `while`{: py} 循环。这种 MSB 计算方法要求操作是 32 位整数，否则需要调整 `bits |= bits >> N`{: py} 语句的数量；不过因为字符编码最多超不过 21 位，所以实际上不用担心。

此版本虽然在 Python、Ruby 领域已被下文的新版本取代，但在使用 JavaScript、Lua 等没有（或由于某些原因选择不使用）可变长度整数或原生 MSB 函数的编程语言实现时，仍然是最优的方法。

### 改良 `sts` 第三代

<ul class="nav nav-underline px-2 " role='tablist'>
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

{: title="原 汤 化 原 食"}
    经过两个多月的网课，疫情基本结束，学校终于要复课了。
    
    2020.4.20。复课的第一天，我满怀期待地走进了校门。熟悉的景象在我眼前展开，只是所有人都戴了个口罩。顶着大风，仿佛回到了二三月份。
    
    走在我前面的是我的8B班同学Richard。三个多月没看见他，他在我眼中更加高大了。我在网课时曾屡次想念过他，现在，我可以以学习为理由来接近他，和他在一起。
    
    我在上个学期观察过他，他很少和Sunny说话，Sunny也没有去主动找他。但我猜不出他是否已经放弃了Sunny。机不可失时不再来，我得在结课考之前追求到他。

分别进行加密操作测试，结果如下：

{: .table .w-auto}
|     版本     | 实验次数 | 平均用时（毫秒） |
|:------------:|:--------:|:----------------:|
| Richard 原版 |      500 |            5.688 |
|   改良一代   |     5000 |            0.595 |
|   改良二代   |    50000 |            0.192 |
|   改良三代   |    50000 |            0.116 |

## 2023-11-18 更新

8 月 28 日，我发现 `sts` 算法具有一个问题：由于字符编码 `D800` 至 `DFFF` 为 UTF-16 代理字，用于在 UTF-16 中编码 `U+10000` 及以上的字符，这个范围内的编码不是合法的 Unicode 字符；这意味着 `A000` 至 `A7FF` 范围内的字符经过 `sts` 编码后，会得到不正确的 Unicode 文本；轻则出现问号替代字符，重则直接报错。

不过，`A000` 至 `A7FF` 范围内的字符显然完全不是我们会用到的（见下表），上述问题其实可以不用解决。考虑这个问题只是~~因为太闲了~~{:.text-secondary}为了严谨。

<div class="table-responsive" markdown='1'>

{:.table .w-auto .text-nowrap}
| 范围             | 名称             | 英文名称              |
|------------------|------------------|-----------------------|
| `U+A000..U+A48F` | 彝文音节         | Yi Syllables          |
| `U+A490..U+A4CF` | 彝文部首         | Yi Radicals           |
| `U+A4D0..U+A4FF` | 老傈僳文         | Lisu                  |
| `U+A500..U+A63F` | 瓦伊语文字       | Vai                   |
| `U+A640..U+A69F` | 西里尔字母扩展-B | Cyrillic Extended-B   |
| `U+A6A0..U+A6FF` | 巴姆穆文字       | Bamum                 |
| `U+A700..U+A71F` | 声调修饰符号     | Modifier Tone Letters |
| `U+A720..U+A7FF` | 拉丁文扩展-D     | Latin Extended-D      |

</div>

在 Python 实现中，只要不试图将包含 UTF-16 代理字的密文以默认的 UTF-8 编码存入文件或直接输出，就不会出现异常，因为 Python 中的字符串是以代码点为单位存储，而不是以编码过的字节序列形式存储的，只有在输出、写入到文件等操作的过程中，字符串才会被编码。如果确实需要将 `sts` 密文保存成文件，可以考虑自己实现 UTF-8 编解码。

后来我发现这种编码方法还有另一个问题：Unicode 第 16 平面上的字符（`U+100000..U+10FFFF`）是肯定没办法编码的，因为这个范围经过 `sts` 会变成 `U+1F0000..U+1FFFFF`，是根本不存在的。第 16 平面内的字符全部属于**补充私人使用区-B**（*Supplementary Private Use Area-B*），如此偏远的区段基本很少会用到；但由于问题的存在，`sts` 目前的所有实现都已经不完美了。

<aside class="card my-3 p-3 pb-0" markdown='1'>

关于 Unicode 代码点的最大值为什么是 `U+10FFFF` 这样一个奇怪的数（每 65536 个代码点为一个平面，平面序号从 0 到 16，共 ***17*** 个平面），我看到一个叫 [tomatofrommars](https://github.com/tomatofrommars) 的人在[一篇博文](https://lunawen.com/basics/20201129-luna-tech-unicode-plane/ "Unicode - 平面（Plane）的概念 — Luna Wen")下的评论说得很好：

> 划分 17 个平面是受限于 UTF-16 编码空间的结果。
>
> 1990 年的 Unicode 还只有 16 位，彼时的另一大标准 ISO 的*通用字符集*要发布一个 32 位的方案——ISO/IEC 10646，能编码更多字符，但也更耗空间。
> 
> 同是 Unicode 联盟成员的各大软件公司都反对这个方案。为了计算机的未来，双方就协商出了一个相互兼容的方案——*UTF-16*。
> 
> UTF-16 编码的**扩展平面**字符占 32 位，减去固定高位代理（110110）和固定低位代理（110111）所占位数 12 位，剩余 20 位，按照单个平面 65536 个字符设定，20 位可划分的平面数为 2^20 / 65536 = 16 个平面，再加上 1 个基本平面，就是 17 个平面。
>
> 代理数值的确定：个人猜测，这里的高位代理和低位代理要求成对出现，排除基本平面内已经分配了的空间，连续且空间最大的范围就只剩 0xD800 ~ 0xDFFF 了，即 `11011000 00000000` ~ `11011111 00000000`。

~~所以 `sts` 有“BUG”归根结底都是 UTF-16 害的~~

</aside>

为了解决以上问题，我们可以直接在 UTF-8 编码的字节序列的层面上编写 `sts` 算法。

<ul class="nav nav-underline px-2" role='tablist'>
 <li class="nav-item" role='presentation'>
  <button class="nav-link active" id='utf8-tab-rb' data-bs-toggle='tab' data-bs-target="#utf8-pane-rb" type='button' role='tab' aria-controls='utf8-pane-rb' aria-selected='true'>Ruby</button>
 </li>
 <li class="nav-item" role='presentation'>
  <button class="nav-link" id='utf8-tab-lua' data-bs-toggle='tab' data-bs-target="#utf8-pane-lua" type='button' role='tab' aria-controls='utf8-pane-lua'>Lua (Scribunto)</button>
 </li>
 <li class="nav-item" role='presentation'>
  <button class="nav-link" id='utf8-tab-py' data-bs-toggle='tab' data-bs-target="#utf8-pane-py" type='button' role='tab' aria-controls='utf8-pane-py'>Python</button>
 </li>
 <li class="nav-item" role='presentation'>
  <button class="nav-link" id='utf8-tab-js' data-bs-toggle='tab' data-bs-target="#utf8-pane-js" type='button' role='tab' aria-controls='utf8-pane-js'>JavaScript</button>
 </li>
</ul>
<div class="tab-content" markdown='1'>
  <div class="tab-pane fade show active" id='utf8-pane-rb' role='tabpanel' aria-labelledby='utf8-tab-rb' tabindex='0' markdown='1'>

~~~ruby
def sts_utf8(string)
  bytes = string.bytes
  zero = false
  bytes.map! do |byte|
    bits =
      case
      when byte >= 0xf8 then raise ArgumentError, "invalid byte sequence in UTF-8"
      when byte >= 0xf0 then        byte & 0x07
      when byte >= 0xe0 then        byte & 0x0f
      when byte >= 0xc0 then        byte & 0x1f
      when byte >= 0x80 then zero ? byte & 0x3f : 0x40
      else                          byte
      end
    zero = bits.zero?
    byte ^ ~(-1 << (bits.bit_length - 1))
  end
  bytes.pack("C*")
end

def sts_encode(string)
  sts_utf8(string.encode("UTF-8"))
end

def sts_decode(string)
  sts_utf8(string).force_encoding("UTF-8")
end
~~~

  </div>
  <div class="tab-pane fade" id='utf8-pane-lua' role='tabpanel' aria-labelledby='utf8-tab-lua' tabindex='0' markdown='1'>

~~~lua
local bit32 = require("bit32")

local function sts(str)
  local bytes = { str:byte(1, #str) }
  local zero = false
  for i, byte in ipairs(bytes) do
    local bits
    if     byte >= 0xf8 then error("bad utf-8 string in 'sts'")
    elseif byte >= 0xf0 then bits = bit32.band(byte, 0x07)
    elseif byte >= 0xe0 then bits = bit32.band(byte, 0x0f)
    elseif byte >= 0xc0 then bits = bit32.band(byte, 0x1f)
    elseif byte >= 0x80 then
      if zero then           bits = bit32.band(byte, 0x3f)
      else                   bits = 0x40
      end
    else                     bits = byte
    end
    zero = bits == 0

    bits = bit32.rshift(bits, 1)
    bits = bit32.bor(bits, bit32.rshift(bits, 1))
    bits = bit32.bor(bits, bit32.rshift(bits, 2))
    bits = bit32.bor(bits, bit32.rshift(bits, 4))
    bytes[i] = bit32.bxor(byte, bits)
  end
  return string.char(unpack(bytes))
end
~~~

  </div>
  <div class="tab-pane fade" id='utf8-pane-py' role='tabpanel' aria-labelledby='utf8-tab-py' tabindex='0' markdown='1'>

~~~py
def sts_utf8(data: bytes):
    out = []
    zero = False
    for byte in data:
        if   byte >= 0xf8: raise UnicodeDecodeError("invalid start byte")
        elif byte >= 0xf0: bits = byte & 0x07
        elif byte >= 0xe0: bits = byte & 0x0f
        elif byte >= 0xc0: bits = byte & 0x1f
        elif byte >= 0x80: bits = byte & 0x3f if zero else 0x40
        else:              bits = byte
        zero = bits == 0
        out.append(byte ^ ~(-1 << (bits.bit_length() - 1)))
    return bytes(*out)

def sts_encode(string: str):
    return sts_utf8(string.encode(encoding='utf-8'))

def sts_decode(data: bytes):
    return sts_utf8(data).decode(encoding='utf-8')
~~~

  </div>
  <div class="tab-pane fade" id='utf8-pane-js' role='tabpanel' aria-labelledby='utf8-tab-js' tabindex='0' markdown='1'>

~~~js
/** @type {TextEncoder} */
let textEncoder
/** @type {TextDecoder} */
let textDecoder

/** @param {Uint8Array} bytes */
function stsUTF8(bytes) {
  bytes = bytes.slice(0)
  let zero = false
  for (let i = 0; i < bytes.length; i++) {
    const byte = bytes[i]
    let bits = byte
    if      (byte >= 0xf8) throw new RangeError("Invalid byte")
    else if (byte >= 0xf0) bits =        byte & 0x07
    else if (byte >= 0xe0) bits =        byte & 0x0f
    else if (byte >= 0xc0) bits =        byte & 0x1f
    else if (byte >= 0x80) bits = zero ? byte & 0x3f : 0x40
    zero = bits === 0

    bits >>= 1
    bits |= bits >> 1
    bits |= bits >> 2
    bits |= bits >> 4
    bytes[i] = byte ^ bits
  }
  return bytes
}

/** @param {string} string */
function stsEncode(string) {
  textEncoder ||= new TextEncoder()
  return stsUTF8(textEncoder.encode(string))
}

/** @param {Uint8Array} bytes */
function stsDecode(bytes) {
  textDecoder ||= new TextDecoder()
  return textDecoder.decode(stsUTF8(bytes))
}
~~~

  </div>
</div>

另外，以 UTF-16 为基础进行编码也未尝不是一种思路。在 JavaScript 中实现这种方法尤为容易：

~~~js
/** @param {string} string */
function stsUTF16(string) {
  let out = ""
  for (let i = 0; i < string.length; i++) {
    const charCode = string.charCodeAt(i)
    let bits = charCode >> 1
    bits |= bits >> 1
    bits |= bits >> 2
    bits |= bits >> 4
    bits |= bits >> 8
    out += String.fromCharCode(charCode ^ bits)
  }
  return out
}
~~~
