// define log method

window.bridge.log = function(msg) {
    window.bridge.js_msgSend("holo.webView.bridge.log", "log()", msg)
}
