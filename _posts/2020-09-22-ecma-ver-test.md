---
title: "鉴别浏览器ECMAScript版本"
tags: "js"
---

所谓ECMAScript（ES），就是JavaScript（JS）的核心部分：语法、基本原理、基本对象，负责核心的语言功能；而DOM（文档对象模型）提供了访问和操作网页内容的方法和接口，BOM（浏览器对象模型）提供了与浏览器交互的方法和接口，ES加上DOM和BOM就是JS。

今天写了个粗略鉴别ES版本的代码。

2020年10月22日 (四) 20:09 (CST)补充：此程序只是粗略鉴别，毕竟浏览器可能会提前实现新的语法。

```js
/**
 * 检测ECMAScript版本
 * 
 * @returns {Number}
 * 3 - ES3 或更旧
 * 5 - ES5
 * 6 - ES6 (ES2015)
 * 7 - ES7 (ES2016)
 * 8 - ES8 (ES2017)
 * 9 - ES9 (ES2018)
 * 10 - ES10 (ES2019)
 * 11 - ES11 (ES2020)
 * 12 - ES2021 或更新
 */
function detectESVersion () {
    var version = 3;
    try {
        new Function("/ /");
        version = 5;
        new Function("_=>0");
        version = 6;
        new Function("0**1");
        version = 7;
        new Function("(a,)=>0");
        version = 8;
        new Function("(...a)=>[...a]");
        version = 9;
        new Function("try { } catch { }");
        version = 10;
        new Function("0n");
        version = 11;
        new Function("class T { #p }");
        version = 12;
    }
    catch (err) { }
    return version;
}
```

附：ES简要更新记录

| 版本 | 内容 |
| --- | --- |
| ES3 | 添加正则表达式，添加`try`/`catch` |
| ES5 | 添加严格模式，添加内置对象JSON，添加`String.prototype.trim`，添加`Array.prototype.isArray`，添加数组遍历方法 |
| ES6 (ES2015) | 添加`let`、`const`语句，支持函数参数默认值，添加`Array.prototype.find` |
| ES7 (ES2016) | 添加乘方运算符`**`，添加`Array.prototype.includes` |
| ES8 (ES2017) | 添加字符串填充到指定长度方法，引入`Promise`，引入共享内存 |
| ES9 (ES2018) | 添加剩余和展开元素，添加异步迭代器，添加`Promise.prototype.finally`，完善正则表达式的功能 |
| ES10 (ES2019) | 添加`Object.fromEntries`，添加字符串方法`trimStart`和`trimEnd`，添加数组扁平化方法，添加`Symbol.prototype.description`，`catch`后可以没有圆括号 |
| ES11 (ES2020) | 添加`import`和`export`语句，添加`bigint`数据类型，添加`RegExp.prototype.matchAll`，添加`globalThis`，添加`Promise.allSettled`，添加`??`运算符，添加`?.`操作符 |
| ES2021 | 计划添加：`String.prototype.replaceAll`，类的私有成员，弱对象引用，`Promise.any` |
