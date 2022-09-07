---
tags: 编程 日常写代码 音乐
redirect_from: [ "/2021/01/25/note_art_with_musicpy.html" ]
last_modified_at: 2022-09-07T12:45:17+0800
---

# 用[musicpy](https://github.com/Rainbow-Dreamer/musicpy)制作音符画

musicpy是国人写的一个不错的库，操作音符挺方便的，运算符重载很到位，只是IDE太寒碜了（&times;）（建议开发VSCode插件（

今天呢就用它解决了困扰了我一段时间的问题——按几何图形绘制音符画。之前尝试拿鼠标手动画每个音符，到最后就发现画得一点也不像。现在就可以用musicpy自动画出来。


<figure>
<img src="{% link assets/note_art_with_musicpy.png %}" alt="在这张屏幕截图中可以看到，在钢琴瀑布中有一串紫色音符排列成一段正弦波，还有其他不同颜色的音符">
<figcaption>用一段musicpy代码生成的正弦波（紫色音符）。<br>钢琴瀑布软件：PianoFromAbove</figcaption>
</figure>

为了让音符顺滑，我改了`musicpy.py`源代码，在`write()`{: py}的定义里把输出MIDI的分辨率设为了1920：

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

以上代码会输出每个音符的音高和时长，并写入上行的半个周期到up.mid。偷了点懒，我把`musicpy.degree_to_note(i)`{: py}中的`i`{: py}改成`129 - i`{: py}，`"up.mid"`{: py}改成`"down.mid"`{: py}，得到了下行的半个周期。

用类似的思路可以得到其他图形。注意用`&`{: py}运算符可以让两个`musicpy.chord`{: py}同时播放。

## 2022-09-07 更新

虽然由于不太习惯使用 Python 的缘故，音符画的问题我已经改用其他方法解决了，但刚刚我发现 musicpy 更新了一些内容，添加了更多好的功能。特别是音轨和乐曲类型的加入简直是史诗级加强。

现在输出 MIDI 文件的默认分辨率是 960，基本上足够用来做音符画了，并且如果需要的话也可以在调用 `write`{: py} 或 `play`{: py} 时直接指定需要的输出分辨率：

~~~python
write("out.mid", mychord, ticks_per_quarternote=384)
~~~

<aside class="card mt-5 mb-3 p-3 pb-0" markdown='block'>

~~~python
up = N("C4")() @ [1, 2, 3, 1.1] % (1, 1/4)
updown = up // 1 + ~up
~~~

</aside>
{:py: .highlight.language-python}
