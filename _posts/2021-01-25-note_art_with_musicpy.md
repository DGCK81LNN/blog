---
tags: 编程 日常写代码 音乐
---

# 用[musicpy](https://github.com/Rainbow-Dreamer/musicpy)制作音符画

musicpy是国人写的一个不错的库，操作音符挺方便的，运算符重载很到位，只是IDE太寒碜了（&times;）（建议开发VSCode插件（

今天呢就用它解决了困扰了我一段时间的问题——按几何图形绘制音符画。之前尝试拿鼠标手动画每个音符，到最后就发现画得一点也不像。现在就可以用musicpy自动画出来。


<figure>
<img src="/blog/assets/note_art_with_musicpy.png" alt="一张屏幕截图，显示钢琴瀑布中有一串紫色音符排列成一段正弦波，还有其他不同颜色的音符">
<figcaption>用一段musicpy代码生成的正弦波（紫色音符）。<br>钢琴瀑布软件：PianoFromAbove</figcaption>
</figure>

为了让音符顺滑，我改了`musicpy.py`源代码，在`write()`的定义里把输出MIDI的分辨率设为了1920：

```diff
- MyMIDI = MIDIFile(track_number, deinterleave=deinterleave)
+ MyMIDI = MIDIFile(track_number, deinterleave=deinterleave, ticks_per_quarternote=1920)
```

我使用的代码：

```python
import musicpy
import math

def achord(*notes):
    return musicpy.chord(notes)

mychord = None
i = 21
while i <= 108:
    j = (math.asin((i - 20) / 44 - 1) - math.asin((i - 21) / 44 - 1)) / (math.pi * 2)
    print((i, j))
    nc = achord(musicpy.degree_to_note(i)) % (j, j)
    if mychord:
        mychord += nc
    else:
        mychord = nc
    i += 1
musicpy.write("up.mid", mychord)
```

以上代码会输出每个音符的音高和时长，并写入上行的半个周期到up.mid。偷了点懒，我把`musicpy.degree_to_note(i)`中的`i`改成`129 - i`，`"up.mid"`改成`"down.mid"`，得到了下行的半个周期。

用类似的思路可以得到其他图形。注意用`&`运算符可以让两个`musicpy.chord`同时播放。
