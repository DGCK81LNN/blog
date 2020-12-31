---
title: 测试页
projects:
  # not_started - 未启动（缺省）
  # ongoing     - 进行中
  # priority    - 优先进行
  # paused      - 已暂停
  # may_cancel  - 可能弃坑
  # canceled    - 已弃坑
  # done        - 已完成
  -
    id: soul
    desc: 灵魂小站
    url: https://dgck81lnn.github.io/
    projs:
      -
        id: .lab.brainfuck
        desc: 灵魂实验室：brainfuck 在线工具
        url: https://dgck81lnn.github.io/apps/lab/brainfuck.html
        news:
          -
            date: 2020-12-12
            status: ongoing
            progress: .nan
            content: 界面小优化。
          -
            status: ongoing
            progress: .nan
            content: >
              目前本页虽然已基本完工，但我发现它的的性能还存在优化空间，
              所以打算之后尝试改进一下。
      -
        id: .lab.befunge93
        desc: 灵魂实验室 - Befunge-93 在线工具
      -
        id: .lab.lab
        desc: 灵魂实验室
      -
        id: .lab.classic
        desc: 灵魂实验室：经典
        news:
          -
            date: 2020-12-13
            status: may_cancel
            content: >
              此应用的功能可能会被`console`代替。
      -
        id: .lab.console
        desc: 灵魂实验室：控制台
        url: https://dgck81lnn.github.io/apps/lab/console.html
          news:
            -
              date: 2020-12-13
              status: ongoing
              phase: 2
              progress: 50
              content: >
                二期工程启动，开始编写 Richard Markup 解释器。
                由“命令行”更名为“控制台”。
            -
              date: 2020-11-26
              status: done
              progress: 100
              content: >
                已基本完工，不过尚未正式投入使用。
                目前只有一个测试性程序：“Love with Richard under epidemic”。
                目前可以在小站首页找到它的详细信息。
      -
        id: .danceline
        desc: 舞线练习场（第3代）
        news:
          -
            content: 由`dlc`更名为`danceline`
      -
        id: .captoin
        desc: 网页版歌词/字幕编辑器
        news:
          -
            content: 由`capt`更名为`captoin`
      -
        id: .paint
        desc: 网页版绘图软件
        news:
          -
            status: may_cancel
      -
        id: .query
        desc: 外链快速查询（第2代）（哔哩哔哩API快速查询）
  -
    id: osu
    desc: osu!
    projs:
      -
        id: .map.running
        desc: osu! 自制谱：大课间跑步音乐
        url: https://osu.ppy.sh/s/1182532
        news:
          -
            status: paused
          -
            progress: .nan
            status: ongoing
            content: >
              目前Insane难度正在制作中，
              Normal和Hard的节奏点也均已设计完成。
      -
        id: .map.sine:
        desc: osu! 自制谱：-Fm2- - Sine
        url: https://osu.ppy.sh/s/1224989
        news:
          -
            progress: .nan
            status: paused
            content: >
              目前Insane难度已制作完毕，但我不满意（迫真）；
              另外三个难度Easy、Normal、Hard的节奏点也均已设计完成。
      -
        id: .map.xox
        desc: Quree - One Forgotten Night
        url: https://osu.ppy.sh/s/1228904
        news:
          -
            progress: .nan
            status: paused
            content: >
              目前Hard难度已制作完成，但我不满意；
              其他难度尚未进行节奏点设计。
      -
        id: .map.ode
        desc: osu! 自制谱：歌唱祖国
        news:
          -
            progress: .nan
            status: may_cancel
            content: >
              谱面未上传。
              目前Easy、Normal、Hard、Insane难度的节奏点均已设计完毕，
              但尚未开始制谱，只做了Timing。
      -
        id: .skin
        desc: 自制皮肤
        news:
          -
            progress: .nan
            status: paused
            content: >
              未完成。目前std贴图已经基本制作完毕，近期尚不打算开始制作其他模式。
  -
    id: dlfm
    desc: 跳舞的线饭制
    projs:
      -
        id: .template
        desc: LNN跳舞的线饭制模板
        news:
          -
            date: 2020-12-20
            status: ongoing
            content: >
              由“LNN改良冰焰模板”更名为“LNN跳舞的线饭制模板”
          -
            progress: 15
            status: ongoing
            content: >
              目前模板已初具雏形，但仍任重道远（雾）。
              最近打算开始（但尚未开始）制作可按节拍触发动画的Timing系统。
  -
    id: music
    desc: 音乐
    projs:
      -
       id: .midi.sine
        desc: 黑乐谱制作（试水）：-Fm2- - Sine
        news:
          -
            progress: .nan
            status: paused
            content: >
              目前底谱已基本完成，等待黑化（
      -
        id: .chip.running
        desc: FamiTracker 芯片音乐制作（试水）：大课间跑步音乐
        news:
          -
            progress: 40
            status: paused
  -
    id: pone
    desc: B站视频投稿
    projs:
      -
        id: ""
        desc: “转型”为小马UP主的准备工作
        news:
          -
            progress: .nan
            status: paused
---

{%- for namespace in page.projects -%}
{%- if namespace.url -%}
## [{{namespace.id}}]({{namespace.url}})
{%- else -%}
## {{namespace.id}}
{%- endif -%}

{{namespace.desc}}

{%- for project in namespace.projs -%}
{%- if project.url -%}
*   [{{project.id}}]({{project.url}})
{%- else -%}
*   {{project.id}}
{%- endif -%}

    {{project.desc}}

{%- endfor -%}

{-% endfor -%}
