<template>
  <b-navbar variant="light" class="shadow soul-header">
    <b-navbar-brand href="/blog">
      <img
        src="https://dgck81lnn.github.io/site_icon.png"
        class="align-middle"
        style="height: 40px"
      />
      LNN的博客！
    </b-navbar-brand>
    <b-navbar-nav align="right">
      <b-nav-item href="/">主站</b-nav-item>
    </b-navbar-nav>
  </b-navbar>
</template>

<style>
.soul-header {
  padding: 8px 10%;
  border-bottom: 1px solid var(--soul-color-border-1);
}
@media screen and (max-width: 575px) {
  .soul-header {
    padding: 8px;
  }
}
</style>