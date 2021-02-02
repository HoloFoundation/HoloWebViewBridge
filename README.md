# HoloWebViewBridge

[![CI Status](https://img.shields.io/travis/gonghonglou/HoloWebViewBridge.svg?style=flat)](https://travis-ci.org/gonghonglou/HoloWebViewBridge)
[![Version](https://img.shields.io/cocoapods/v/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)
[![License](https://img.shields.io/cocoapods/l/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)
[![Platform](https://img.shields.io/cocoapods/p/HoloWebViewBridge.svg?style=flat)](https://cocoapods.org/pods/HoloWebViewBridge)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

### Type 1: Inject plugin

#### 1.1 Define plugin by WebViewPluginProtocol

```Swift
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

define log function in log.js
```JavaScript
window.bridge.log = function(msg) {
    window.bridge.js_msgSend("holo.webView.bridge.log", "log()", msg)
}
```

#### 1.2 Inject plugin

```Swift
let webView = WKWebView()
webView.holo.inject(plugin: WebViewLogPlugin())
```

#### 1.3 Call method in JS

```JavaScript
window.bridge.log("hello world")
```


### Type 2: Inject function directly

#### 2.1 Inject function
```Swift
let webView = WKWebView()
_webView.holo.inject(function: "window.bridge.print") { (args) in
    if let msg = args.first {
        print(msg)
    }
}
```

#### 2.2 Call method in JS
```JavaScript
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


