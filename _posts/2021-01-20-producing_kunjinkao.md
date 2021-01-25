---
title: 实 验 室 制 取 锟 斤 拷
tags: ruby
---

Ruby

```ruby
encodeOpt = { :invalid => :replace, :undef => :replace }
str = "你好，世界！"
str.encode!('gbk', encodeOpt)
str.force_encoding('utf-8')
str.encode!('utf-8', encodeOpt)
str.force_encoding('gbk')
puts str.encode('utf-8', encodeOpt)
```

```
锟斤拷茫锟斤拷锟斤拷纾�
```

## 实 验 室 制 取 烫 烫 烫

```ruby
str = String.new(encoding: 'ascii-8bit')
str << 0xcc
str *= 20
str.force_encoding('gbk')
puts str.encode('utf-8')
```

```
烫烫烫烫烫烫烫烫烫烫
```
