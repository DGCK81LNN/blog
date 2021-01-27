/**
 * @class
 * @name SoulBlogHeader
 * @extends VueComponent
 * 博客站页头。
 */
Vue.component('soul-blog-header', {
    template: `
    <b-navbar
    variant=light
    class="shadow soul-header">
        <b-navbar-brand href="/">
            <img
            src="https://dgck81lnn.github.io/site_icon.png"
            class="align-middle"
            style="height:40px">
            LNN的博客！
        </b-navbar-brand>
        <b-navbar-nav align=right>
            <b-nav-item href="/">主站</b-dropdown-item>
        </b-navbar-nav>
    </b-navbar>`
});

/**
 * @class
 * @name SoulBlogFoooter
 * @extends VueComponent
 * 博客站页脚。
 */
Vue.component('soul-blog-footer', {
    props: {
        'links': Array
    },
    template: `<div class="soul-footer" height="auto">
    <soul-shit-flex class="soul-footer-flex">
        <section class="soul-footer-col" v-if="links">
            <h5>相关链接</h5>
            <ul class="soul-footer-col-list">
                <li v-for="(link, i) in links" :key="i">
                    <a :href="link.href" target="_blank">{{link.text}}</a>
                </li>
            </ul>
        </section>
        <section class="soul-footer-col">
            <h5>关于我</h5>
            <ul class="soul-footer-col-list">
                <li><a href="https://space.bilibili.com/328066747" target="_blank">B站账号</a></li>
                <li><a href="https://github.com/DGCK81LNN" target="_blank">GitHub</a></li>
                <li><a href="https://zh.moegirl.org.cn/User:DGCK81LNN" target="_blank">萌娘百科用户页</a></li>
            </ul>
        </section>
        <section class="soul-footer-col">
            <h5>©2020 DGCK81LNN.</h5>
            <p>
                <a href="https://github.com/DGCK81LNN/blog"><img src="https://img.shields.io/badge/-在GitHub上查看-222222?logo=github" alt="在GitHub上查看源代码"></a>
                <img src="https://img.shields.io/badge/许可证-CC_BY--SA_4.0-orange" alt="许可证：CC BY-SA 4.0">
            </p>
            <p>
                本站（LNN的博客！）内容除另有声明外，<br>均采用<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/deed.zh" target="_blank">CC BY-SA 4.0 国际许可协议</a>进行许可。<br>
                <a href="http://creativecommons.org/licenses/by-sa/4.0/deed.zh" target="_blank"><img alt="知识共享许可协议" style="border-width:0" src="/cc_by-sa_4.0_88x31.png"/></a>
            </p>
        </section>
    </soul-shit-flex>
</div>`
});
