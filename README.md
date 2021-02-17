# HoloWebViewBridge

[![CI Status](https://img.shields.io/travis/HoloFoundation/HoloWebViewBridge.svg?style=flat)](https://travis-ci.org/HoloFoundation/HoloWebViewBridge)
[![Version](https://img.shields.io/cocoapods/v/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)
[![License](https://img.shields.io/cocoapods/l/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)
[![Platform](https://img.shields.io/cocoapods/p/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### Type 1

1, Inject function
```swift
let webView = WKWebView()
webView.holo.inject(function: "window.bridge.log") { (args) in
    print(args ?? "")
}
```

2, Call function in JS
```javascript
window.bridge.log("hello world")
```

### Type 2

1, Inject plugin
```swift
let webView = WKWebView()
webView.holo.inject(plugin: WebViewLogPlugin())
```

2, Define plugin by `WebViewPluginProtocol`
```swift
class WebViewLogPlugin: WebViewPluginProtocol {

    func log(_ msg: Any) {
        print(msg)
    }
    
    // MARK: - WebViewPluginProtocol
    var identifier: String {
        return "holo.webView.bridge.log"
    }
    
    var javascript: String {
        if let path = Bundle(for: WebViewLogPlugin.self).path(forResource: "log", ofType: "js"),
           let js = try? String(contentsOfFile: path, encoding: .utf8) {
            return js
        }
        return ""
    }
    
    func didReceiveMessage(_ fun: String, args: Any?) {
        if fun == "log()" {
            self.log(msg ?? "")
        }
    }
}
```

3, Define log function in `log.js`
```javascript
window.bridge.log = function(msg) {
    window.bridge.js_msgSend("holo.webView.bridge.log", "log()", msg)
}
```

4, Call function in JS
```javascript
window.bridge.log("hello world")
```

## Installation

HoloWebViewBridge is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HoloWebViewBridge'
```

## Thanks

[OCTWebViewBridge](https://github.com/octree/OCTWebViewBridge)

## Author

gonghonglou, gonghonglou@icloud.com

## License

HoloWebViewBridge is available under the MIT license. See the LICENSE file for more info.


