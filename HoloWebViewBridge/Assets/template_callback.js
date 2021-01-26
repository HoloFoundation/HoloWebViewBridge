// template js

if (!window.bridge.plugin) {
    window.bridge.plugin = {}
}

window.bridge.plugin.{function_name} = function(param, callback) {
    
    window.bridge.js_msgSend("{plugin_identifier}", "{function_name}", param, callback)

}
