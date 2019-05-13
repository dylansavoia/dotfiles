// ==UserScript==
// @name         Google Tab
// @namespace    http://tampermonkey.net/
// @version      0.1
// @author       You
// @match        https://www.youtube.com/*
// @match        https://www.google.it/*
// @match        https://duckduckgo.com/*
// @grant        none
// ==/UserScript==

var ind = 0,
    color = location.href.indexOf("duckduckgo") != -1 ? "#555" : "#ddd",
    elem = null;

bar = document.querySelector("input[type=text][tabindex]");
console.log(bar);
bar.addEventListener("keydown", (e) => {
    if ( e.keyCode == 9 ) {
        e.preventDefault();
        // try {
        if (elem) {
            elem.style.backgroundColor = "initial";
        }
        elem = document.querySelectorAll("li[role=presentation], .acp")[ind++];
        elem.style.backgroundColor = color;
    } else if ( e.keyCode == 13 ) {
        bar.value = elem.innerText.replace(/^Remove/, "");
    } else {
        ind = 0;
    }
}, false);
