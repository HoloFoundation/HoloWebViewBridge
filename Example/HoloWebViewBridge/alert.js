window.bridge.alert = function(msg, callback) {
    
    window.bridge.js_msgSend("holo.webview.bridge.example.alert", "alert(confirm)", msg, callback)
}
