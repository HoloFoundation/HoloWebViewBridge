//
//  WKWebView+HoloBridge.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import WebKit

public extension WKWebView {
    
    static var AssociatedKey = "holo.webView.bridge"
    
    var holo: WebViewBridge {
        let webViewBridge: WebViewBridge
        if let bridge = objc_getAssociatedObject(self, &WKWebView.AssociatedKey) as? WebViewBridge {
            webViewBridge = bridge
        } else {
            let bridge = WebViewBridge(webView: self)
            objc_setAssociatedObject(self, &WKWebView.AssociatedKey, bridge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            webViewBridge = bridge
        }
        return webViewBridge
    }
    
}
