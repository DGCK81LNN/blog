document.styleSheets[0].insertRule(`
@font-face {
  font-family: LNNCrypt;
  src: url(/blog/assets/LNNCrypt.woff);
}
`);
document.styleSheets[0].insertRule(`
#out {
  font-family: LNNCrypt, monospace;
}
`);
text.oninput = () => {
    var reg = /\\([^][^])|([^])/g;
    var arr = [], match = null;
    while (match = reg.exec(text.value))
        arr.push(match[1] || match[2]);
    out.value = arr.map(o => ({
        "0": "\uE000",
        "1": "\uE001",
        "2": "\uE002",
        "3": "\uE003",
        "4": "\uE004",
        "5": "\uE005",
        "6": "\uE006",
        "7": "\uE007",
        "8": "\uE008",
        "9": "\uE009",
        "xa": "\uE00A",
        "xb": "\uE00B",
        "xc": "\uE00C",
        "xd": "\uE00D",
        "xe": "\uE00E",
        "xf": "\uE00F",
        "a": "\uE010",
        "o": "\uE011",
        "e": "\uE012",
        "i": "\uE013",
        "u": "\uE014",
        "y": "\uE015",
        "eh": "\uE016",
        "ai": "\uE017",
        "ei": "\uE018",
        "ao": "\uE019",
        "ou": "\uE01A",
        "t0": "\uE01B",
        "t1": "\uE01C",
        "t2": "\uE01D",
        "t3": "\uE01E",
        "t4": "\uE01F",
        "b": "\uE020",
        "p": "\uE021",
        "m": "\uE022",
        "f": "\uE023",
        "d": "\uE024",
        "t": "\uE025",
        "n": "\uE026",
        "l": "\uE027",
        "g": "\uE028",
        "k": "\uE029",
        "ng": "\uE02A",
        "h": "\uE02B",
        "j": "\uE02C",
        "q": "\uE02D",
        "w": "\uE02E",
        "x": "\uE02F",
        "zh": "\uE030",
        "ch": "\uE031",
        "r": "\uE032",
        "sh": "\uE033",
        "z": "\uE034",
        "c": "\uE035",
        "v": "\uE036",
        "s": "\uE037",
        "th": "\uE038",
        "of": "\uE039",
        "on": "\uE03A",
        "in": "\uE03B",
        "to": "\uE03C",
        " ": "\u2003",
        "shy": "\xad",
    })[o] || (o.length == 1 && o.charCodeAt(0) < 0x7f && o.charCodeAt(0) > 0x20 ? String.fromCharCode(o.charCodeAt(0) + 0xfee0) : o)).join("")
}