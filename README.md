# HoloWebViewBridge

[![CI Status](https://img.shields.io/travis/gonghonglou/HoloWebViewBridge.svg?style=flat)](https://travis-ci.org/gonghonglou/HoloWebViewBridge)
[![Version](https://img.shields.io/cocoapods/v/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)
[![License](https://img.shields.io/cocoapods/l/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)
[![Platform](https://img.shields.io/cocoapods/p/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### Type 1: 

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
        if let path = Bundle(for: ViewController.self).path(forResource: "log", ofType: "js"),
           let js = try? String(contentsOfFile: path, encoding: .utf8) {
            return js
        }
        return ""
    }
    
    func didReceiveMessage(_ fun: String, args: [Any]) {
        if fun == "log()", let msg = args.first {
            self.log(msg)
        }
    }
}
```

3, Define log function in log.js
```javascript
window.bridge.log = function(msg) {
    window.bridge.js_msgSend("holo.webView.bridge.log", "log()", msg)
}
```

4, Call method in JS
```javascript
window.bridge.log("hello world")
```


### Type 2: 

1, Inject function
```swift
let webView = WKWebView()
webView.holo.inject(function: "window.bridge.print") { (args) in
    if let msg = args.first {
        print(msg)
    }
}
```

2, Call method in JS
```javascript
window.bridge.log("hello world")
```

## Installation

HoloWebViewBridge is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HoloWebViewBridge'
```

## Author

gonghonglou, gonghonglou@icloud.com

## License

HoloWebViewBridge is available under the MIT license. See the LICENSE file for more info.


