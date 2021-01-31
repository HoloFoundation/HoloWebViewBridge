// define alert function

window.bridge.alert = function(msg) {
    window.bridge.js_msgSend("holo.webview.bridge.example.alert", "alert()", msg)
}

window.bridge.alertConfirm = function(msg, callback) {
    window.bridge.js_msgSend("holo.webview.bridge.example.alert", "alert(confirm)", msg, callback)
}
