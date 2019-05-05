// ==UserScript==
// @name         Download Playlist
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  add a button to add to personal playlist.
// @author       You
// @match        https://www.youtube.com/watch?v=*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

var LOCAL = false;

var main_bar;
var target_elem = "#subscribe-button.style-scope.ytd-video-secondary-info-renderer";

function wait_for(elem, func) {
    let t = setInterval( () => {
        let wait_elem = document.querySelector(elem);
        if (wait_elem) {
            console.log(wait_elem);
            clearInterval(t);
            func(wait_elem);
        }
    }, 1000);
}

function add_css() {
    var css = '#add_to_playlist:hover {background-color: #bbb !important}';
    var style = document.createElement('style');
    style.innerHTML = css;
    document.getElementsByTagName('head')[0].appendChild(style);
}

function main_function(elem) {
    let new_btn = document.createElement("input");

    new_btn.id = "add_to_playlist";
    new_btn.setAttribute("type", "button");
    new_btn.setAttribute("value", "Add");

    new_btn.style.border = 0;
    new_btn.style.width = "65px";
    new_btn.style.height = "37px";
    new_btn.style.margin = "7px -1px 0 0";
    new_btn.style.backgroundColor = "lightgrey";
    new_btn.style.borderRadius = "3px";
    new_btn.style.fontSize = "1.4em";
    new_btn.style.cursor = "pointer";
    new_btn.style.outline = "none";
    new_btn.style.transition = "all .1s";

    var g_elem = new_btn;
    new_btn.onclick = function () {
        let xmlHttp = new XMLHttpRequest();
        let url;

        let get_url = location.href;
        let url_ind = get_url.indexOf("&");


        if ( url_ind != -1 )
            get_url = get_url.substring(0, url_ind);

        let suggest = document.querySelector("h1").innerText;
        let filename = prompt("Choose name:", suggest);
        if (!filename) return false;

        get_url = encodeURIComponent(get_url);
        filename = encodeURIComponent(filename);

        url = (LOCAL) ? "https://192.168.1.18/Files/append.php?" : "https://dylansavoia.sytes.net/Files/append.php?";
        url += "f=playlist_update";
        url += "&d=" + get_url + " " + filename + "%0A";
        url += "&a=true";

        xmlHttp.withCredentials = true;
        xmlHttp.onreadystatechange = function() {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                g_elem.disabled = true;
                g_elem.value = xmlHttp.responseText;
                g_elem.style.backgroundColor = "#f1f1f1";
            }
        }
        xmlHttp.open("GET", url, true);
        xmlHttp.send(null);
    }

    elem.parentNode.insertBefore(new_btn, elem);
}

function auto_update_yt() {
    var curr_url = location.href;
    let t1 = setInterval ( () => {
        if ( curr_url != location.href ) {
            let ATP_btn = document.querySelector("#add_to_playlist");
            if (ATP_btn)
                ATP_btn.parentNode.removeChild(ATP_btn);
            curr_url = location.href;
            wait_for(target_elem, main_function);
        }
    }, 1000);
}

wait_for(target_elem, main_function);
add_css();
auto_update_yt();


})();
