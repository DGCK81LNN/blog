---
tags: 编程 日常写代码
---

# 用自动脚本整理 [Derpibooru](https://derpibooru.org) 图集

我在 Derpibooru 做了一个图集“[M6就要整整齐齐]”，里面的图片都是每6张为一组。我今天写了一个自动脚本来给这个图集的图片整理排序。

Derpibooru 官方没有提供修改图集内图片顺序的 API；我通过浏览器开发者工具找到了这个 API。它的工作原理很迷，我没有看懂……<del>废话，我不会 [Elixir]。</del>[这是它的源代码][perform_reorder]。


以下代码需要在 Derpibooru 页面上用开发组工具的控制台运行，因为它使用了相对路径的 API 网址和全局对象 `booru`。在其他基于 <span lang=en>[Philomena]</span> 的图站上应该也可以运行，但要记得修改 `filterId`。

[M6就要整整齐齐]: https://derpibooru.org/galleries/14196
[Philomena]: https://github.com/derpibooru/philomena
[Elixir]: https://elixir-lang.org/
[perform_reorder]: https://github.com/derpibooru/philomena/blob/355ce491accae4702f273334271813e93a261e0f/lib/philomena/galleries.ex#L277:L339
*[API]: 应用程序编程接口

```js
(async () => {
  const galleryId = 14196; // 图集ID
  const perSet = 6; // 每个图组的图片数量
  const perPage = 50; // 获取图集内所有图片时，每页返回多少张（最高50）
  const filterId = 56027; // 图片过滤器编号（这里使用的是 Everything）

  const listImagesApi = `/api/v1/json/search/images?q=gallery_id:${galleryId}&sf=gallery_id:${galleryId}&sd=asc&filter_id=${filterId}&per_page=${perPage}&page=`;
  const orderImagesApi = `/galleries/${galleryId}/order`;

  // main procedure
  var current = await getImgList();
  console.log("original data: ", current);
  var sorted = sortImgs(current);
  console.log("sorted data: ", sorted);
  await submitOrder([...sorted].reverse());

  /**
   * 获取图集内图片
   * @returns {number[]} 图片ID列表
   */
  async function getImgList() {
    console.log("GET IMAGE LIST...");
    /** @type {number[]} */ var result = [];
    let i = 1;
    do {
      var data = JSON.parse(await (await fetch(listImagesApi + i)).text());
      result.push(...data["images"].map((i) => i["id"]));
      console.log(`✓ page ${i} of ${Math.ceil(data["total"] / perPage)}`);
    } while (i++ * perPage < data["total"]);
    console.log(`FETCH COMPLETE!`);
    return result;
  }

  /**
   * 排序图片：每个图组内图片按ID排序，图组按首张图片ID排序
   * @param {number[]} current 当前图片ID列表
   * @returns {number[]} 排序后的图片ID列表
   */
  function sortImgs(current) {
    /** @type {number[][]} */ var sets = [];
    for (let i = 0; i < current.length; i += perSet) {
      let set = current.slice(i, i + perSet);
      set.sort((a, b) => a - b);
      sets.push(set);
    }
    sets.sort((a, b) => a[0] - b[0]);
    return sets.flat();
  }

  /**
   * 提交新的图片顺序到服务器
   * @param {number[]} sorted
   */
  function submitOrder(sorted) {
    console.log("SUBMITTING DATA...");
    var xhr = new XMLHttpRequest();
    xhr.open("PATCH", orderImagesApi);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.setRequestHeader("x-csrf-token", window.booru.csrfToken);
    xhr.send(
      JSON.stringify({
        image_ids: [...sorted],
        _method: "PATCH"
      })
    );
    return new Promise((resolve, reject) => {
      xhr.onload = () => {
        console.log("DONE!");
        resolve();
      };
      xhr.onerror = () => {
        reject("REQUEST FAILED!");
      };
    });
  }
})().catch((err) => console.error(err));
```
