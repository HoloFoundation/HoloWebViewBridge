// main.js

if (!window.bridge) {
    window.bridge = {};
}

window.bridge.closureDispatcher = {
    __count: 0,
    cache: {},
    invoke: function invoke(id, args) {
        var key = "" + id;
        var func = window.bridge.closureDispatcher.cache[key];
        func(args);
    },
    push: function push(func) {
        var index = -1;
        if (func != null) {
            window.bridge.closureDispatcher.__count += 1;
            index = window.bridge.closureDispatcher.__count;
            window.bridge.closureDispatcher.cache["" + index] = func;
     }
     return index;
    }
};

window.bridge.js_msgSend = function(id, selector) {
    var length = arguments.length, args = Array(length > 2 ? length - 2 : 0)
    for (key = 2; key < length; key++) {
        args[key - 2] = arguments[key];
    }

    args = args.map(function(elt) {
        if (typeof elt === "function") {
            return { flags: 1, val: window.bridge.closureDispatcher.push(elt) };
        } else {
            return { flags: 0, val: elt };
        }
    })
    
    window.webkit.messageHandlers.bridge.postMessage({
        identifier: id,
        selector: selector,
        args: args
    })
};
