---
tags: 编程 日常写代码
---

# [Blockly Games](https://blockly.games) “[池塘](https://blockly.games/pond-duck)”模式我的解法

> ![“池塘”模式图标](https://blockly.games/index/pond-duck.png)
>
> [池塘](https://blockly.games/pond-duck)是一个开放式竞赛，目标是编写出最聪明的鸭子。

我的这个解法基本可以完胜内建的三个敌人。它们的策略分别是：


+ “车（ju）”（Rook）――蹲在中间水平线上扫描上下左右的敌人，找到就停下来攻击
+ “逆时针”（Counter）――总是逆时针扫描前方一定角度内的敌人
+ “狙击手”（Sniper）――蹲在角落扫描敌人，找到了就攻击，没有就换一个角落，但是如果在跑位过程中被敌人挡住就完蛋了

它们都缺乏一个必须的策略：*走位*。在敌人都在瞄准你，而且几乎没有办法预判你的移动的情况下，停在原地就是“找死”。

我的策略是让鸭子按圆弧行进，靠近边界就反弹，同时旋转着扫描敌人，找到了就发射炮弹；如果攻击后又找不到了，可能是转过头了，到达一定阀值后会调转扫描方向。

![程序运行录像（WEBP动图）](https://ftp.bmp.ovh/imgs/2021/04/77ae6196a62c4f99.webp)

```javascript
// 生成 -m 到 m 的随机数
function rand1(m) {
  return (Math.random() * 2 - 1) * m;
}

var sa = 215; // 移动方向
var sad = 2;  // 移动方向 delta
var ca = 0;   // 扫描方向
var cad = 5;  // 扫描方向 delta
var cd = Infinity; // 上次扫描结果
var counter = 0; // 扫描到敌人清零，扫描不到递增
var magic = 3; // 调转扫描方向阀值
while (true) {
  //// “碰撞检测”
  // 扫描前方敌人
  var fa = sa + rand1(30); // 扫描角度
  var fd = scan(fa, 20);
  if (fd < 10)
    sa -= 90; // 前方有敌人就躲开
  // 检测是否靠近边界
  var sr = sa / 180 * Math.PI;   // 移动方向弧度
  // 前方10单位长度处的坐标
  var fx = loc_x() + Math.cos(sr) * 10,
      fy = loc_y() + Math.sin(sr) * 10;
  // 靠近边界就反弹
  if (fx < 0 || fx > 100)
    sa = 180 - sa;
  if (fy < 0 || fy > 100)
    sa = -sa;
  swim(sa += sad);
  //// 扫描敌人
  var _cd = scan(ca, 10);
  if (_cd < cd) {
    counter = 0;
    cannon(ca, _cd);
    // 距离太近就躲开
    if (_cd < 10)
      sa += 180;
    // 距离太远就靠近
    else if (_cd > 70)
      sa = ca;
  }
  else { // 没有扫描到敌人
    ++counter;
    if (counter === magic) // 触发阀值
      cad = -cad; // 调转扫描方向
  }
  cd = _cd;
  ca += cad; // 旋转移动方向
}
```
