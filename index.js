function $$$(id) { return document.getElementById(id) }

const liveEl = $$$("linf")
const h26El = $$$("linf-h26")
const dateEl = $$$("linf-date")
const timeEl = $$$("linf-time")
function updateDateTime() {
  var ts = Date.now() - 10800000
  var h26 = false
  var date = Intl.DateTimeFormat("zh-Hans", {
    timeZone: "PRC",
    dateStyle: "medium"
  }).format(ts)
  var time = Intl.DateTimeFormat("en", {
    timeZone: "PRC",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hourCycle: "h23"
  }).format(ts)
    .replace(/\d+/, function (s) {
      var h = parseInt(s) + 3
      if (h >= 24) h26 = true
      return String(h).padStart(2, "0")
    })
  h26El.hidden = !h26
  dateEl.textContent = date
  timeEl.textContent = time
}

updateDateTime()
liveEl.hidden = false
setInterval(updateDateTime, 250)

_aqiFeed({
  lang: "cn",
  city: "tianjin/yuejinlu",
  container: "linf-aqi",
  callback: function (response) {
    var el = document.createElement("div")

    el.innerHTML = response.aqit
    var aqi = parseInt(el.textContent)

    el.style.cssText = response.style
    var bgColor = el.style.backgroundColor,
      textColor = el.style.color

    var cityname = response.cityname,
      impact = response.impact,
      attribution = response.attribution,
      url = response.url

    var details = []
    /*el.innerHTML = response.details
    var detailsNl = el.querySelectorAll("tr")
    for (var i = 0; i < detailsNl.length; ++i) {
      var itemEl = detailsNl[i]
      var itemNl = itemEl.querySelectorAll("td")
      if (itemNl.length < 3) continue

      var itemNameEl = itemNl[0].querySelector("span"),
        itemGraphEl = itemNl[1].querySelector("img")
      if (!(itemNameEl && itemNameEl.firstChild)) continue

      details.push({
        name:  itemNameEl.firstChild.nodeValue.trim(),
        value: itemNl[2].textContent.trim(),
        graph: itemGraphEl && itemGraphEl.src
      })
    }*/

    console.log(aqi)
    console.log(bgColor)
    console.log(textColor)
    console.log(cityname)
    console.log(impact)
    console.log(details)
    console.log(attribution)
    console.log(url)
    el = null

    $$$("linf-aqi-cityname").textContent = cityname
    var vel = $$$("linf-aqi-value")
    vel.textContent = aqi + " " + impact
    vel.style.backgroundColor = bgColor
    vel.style.color = textColor
    $$$("linf-aqi-link").href = url
    $$$("linf-aqi").hidden = false
  }
})
