//
//  WebViewLogPlugin.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import Foundation
import HoloWebViewBridge

class WebViewLogPlugin: WebViewPluginProtocol {
    
    deinit {
        print("WebViewLogPlugin deinit")
    }
    
    // MARK: - LogPlugin method
    
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
    
    func didReceiveMessage(_ fun: String, args: Any?) {
        if fun == "log()" {
            self.log(args ?? "")
        }
    }
    
}
