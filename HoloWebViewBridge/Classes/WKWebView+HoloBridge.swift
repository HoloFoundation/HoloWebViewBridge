//
//  WKWebView+HoloBridge.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import WebKit

public extension WKWebView {
    
    private static var AssociatedBridgeKey: Void?
    
    var holo: WebViewBridge {
        let webViewBridge: WebViewBridge
        if let bridge = objc_getAssociatedObject(self, &WKWebView.AssociatedBridgeKey) as? WebViewBridge {
            webViewBridge = bridge
        } else {
            let bridge = WebViewBridge(webView: self)
            objc_setAssociatedObject(self, &WKWebView.AssociatedBridgeKey, bridge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            webViewBridge = bridge
        }
        return webViewBridge
    }
    
}
