---
date: 2024-04-06T01:33:41+08:00
tags: 编程 esolang
---

# brainf 解释器，但它是一个 Python 表达式

```python
(lambda cod, _, inp: (lambda *, _cp = 0, _mp = 0, _ip = 0, _mem = {}, _inp = inp
.encode(), _out = b"": next(__import__("sys").stdout.buffer.write(_out) and None
or None for _ in __import__("itertools").count() if not (_mem.__setitem__(_mp, (
(_mem[_mp] if _mp in _mem else 0) + (1 if cod[_cp] == "+" else -1 if cod[_cp] ==
"-" else 0)) & 255) and 0 or (_mp := _mp + (1 if cod[_cp] == ">" else -1 if cod[
_cp] == "<" else 0)) and 0 or ((_cp := (lambda si, *, _d = 0: next(i for i in (
range(si, len(cod)) if cod[si] == "[" else range(si, -1, -1)) if cod[i] in "[]"
and ((_d := _d + (1 if cod[i] == "[" else -1)) == 0)))(_cp)) if cod[_cp] in "[]"
and bool(_mem[_mp] if _mp in _mem else 0) == bool(cod[_cp] == "]") else 0) and 0
or ((_out := _out + bytes((_mem[_mp],))) if cod[_cp] == "." else _mem.__setitem__
(_mp, _inp[_ip]) and 0 or (_ip := _ip + 1) if cod[_cp] == "," and _ip < len(_inp)
else 0) and 0 or (_cp := _cp + 1) < len(cod))))())(*__import__("sys").stdin.read
().partition("!"))
```


{:py: .highlight.language-python}

~~在群友的怂恿下~~挑战用 Python 但不用 `def` 关键字和 `exec()`{: py}、`eval()`{: py} 函数实现 brainf 解释器，但我决定做得更绝一些。于是就有了这个单个表达式的 brainf 解释器。

此解释器从标准输入读取 brainf 代码和程序输入（用半角叹号分隔），程序输出直接发送到标准输出（在 Python IDLE 中可能无效）；将“`__import__("sys").stdout.buffer.write(_out) and None or None`{: py}”改为“`_out`{: py}”可变为以 `bytes`{: py} 类型返回输出内容。

大量使用了“`and 0 or`{: py}”来分隔“语句”，这相当于一些其他编程语言中的*逗号运算符*。使用赋值运算 `:=`{: py} 和字典的 `__setitem__()`{: py} 方法来进行赋值。循环结构全部用生成器表达式（Generator expressions）实现：使用了 `... for _ in itertools.count()`{: py} 来实现无限循环，并使用 `next(... for ... if ...)`{: py} 的写法来在满足特定条件时跳出循环。

带缩进版：

```python
(lambda cod, _, inp:
  (lambda *, _cp = 0, _mp = 0, _ip = 0, _mem = {}, _inp = inp .encode(), _out = b"": next(
    __import__("sys").stdout.buffer.write(_out) and None or None
    for _ in __import__("itertools").count()
    if not (
      _mem.__setitem__(
        _mp,
        ((_mem[_mp] if _mp in _mem else 0) + (1 if cod[_cp] == "+" else -1 if cod[_cp] == "-" else 0)) & 255
      ) and 0 or
      (_mp := _mp + (1 if cod[_cp] == ">" else -1 if cod[ _cp] == "<" else 0)) and 0 or
      (
        (_cp := (lambda si, *, _d = 0:
          next(i
            for i in (range(si, len(cod)) if cod[si] == "[" else range(si, -1, -1))
            if cod[i] in "[]" and ((_d := _d + (1 if cod[i] == "[" else -1)) == 0)
          )
        )(_cp))
        if cod[_cp] in "[]" and bool(_mem[_mp] if _mp in _mem else 0) == bool(cod[_cp] == "]")
        else 0
      ) and 0 or
      (
        (_out := _out + bytes((_mem[_mp],))) if cod[_cp] == "."
        else _mem.__setitem__(_mp, _inp[_ip]) and 0 or (_ip := _ip + 1) if cod[_cp] == "," and _ip < len(_inp)
        else 0
      ) and 0 or
      (_cp := _cp + 1) < len(cod)
    )
  ))()
)(*__import__("sys").stdin.read ().partition("!"))
```
