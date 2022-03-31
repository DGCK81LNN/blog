!function () {
  /** @type {HTMLLinkElement} */
  var $canonical = document.querySelector("link[rel=canonical]")
  if ($canonical)
    history.replaceState(null, "", $canonical.href + location.search + location.hash)
}()
