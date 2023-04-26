---
date: 2023-04-26T18:55+0800
tags: 编程 日常写代码
---

# JavaScript，但是你可以用 `new int[len]`{: js} 来创建类型化数组

{:js: .highlight.language-javascript}
{:cpp: .highlight.language-cpp}

~~~cpp
int* arr = new int[20];
~~~

🤔…

~~~js
const array = new int[20]
console.log(array) // ==> Int32Array(20)
~~~


----

今天跟 FCC 同学讨论时提到，JavaScript 中调用构造函数时如果不需要传入任何参数，则可以不写调用函数的括号：

~~~js
var map = new Map
~~~

我立刻想到，只要利用 [`Proxy`{: js}][proxy-zh]<sup markdown=1>[(en)][proxy-en]</sup>，就可以创建一个名为 `int`{: js} 的对象，使得 `int[len]`{: js} 返回一个可以被当作构造函数调用的函数，调用后返回一个指定长度的 `Int32Array`{: js}，从而实现用 `new int[len]`{: js} 的语法来创建类型化数组。（C++ 化 JS！）于是当场写了这个。

[proxy-zh]: https://developer.mozilla.org/zh-CN/docs/Web/Javascript/Reference/Global_Objects/Proxy
[proxy-en]: https://developer.mozilla.org/en-US/docs/Web/Javascript/Reference/Global_Objects/Proxy

~~~js
const handler = {
  get(_, prop) {
    return function () {
      return new Int32Array(prop)
    }
  }
}
const int = new Proxy({}, handler)

new int[32] // => Int32Array(32)
~~~

显然这里的 `int[32]`{: js} 只是在对 `int`{: js} 进行索引，这样会调用 `handler.get(int, "32")`{: js}。此时我们就返回一个函数来创建对应长度的类型化数组。然后把 `int[32]`{: js} 的结果当作构造函数来调用，就能得到这个新数组。

又写了一个能创建其他各种数组的版本。`Class`{: js} 只要是一个接受数组长度的构造函数就可以。

~~~js
function ArrayCreator(Class) {
  return new Proxy({}, {
    get(_, length) {
      length = +length
      if (!Number.isSafeInteger(length) || length < 0)
        throw new TypeError(`ArrayCreator(${Class.name}): length must be a non-negative safe integer`)
      return function () {
        return new Class(length)
      }
    },
  })
}

const int = ArrayCreator(Int32Array)
const long = ArrayCreator(BigInt64Array)
const short = ArrayCreator(Int16Array)
const float = ArrayCreator(Float32Array)
const double = ArrayCreator(Float64Array)

console.log(new int[20]) // => Int32Array[20]
console.log(new long[20]) // => BigInt64Array(20)
console.log(new short[20]) // => Int16Array[20]
console.log(new float[20]) // => Float32Array[20]
console.log(new double[20]) // => Float64Array[20]

const any = ArrayCreator(Array) // (?)
console.log(new any[20]) // => Array(20)
~~~

没了。（
