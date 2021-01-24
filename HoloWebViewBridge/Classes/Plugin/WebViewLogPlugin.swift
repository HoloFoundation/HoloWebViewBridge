//
//  WebViewLogPlugin.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import Foundation

public class WebViewLogPlugin: WebViewPluginProtocol {
    
    public init() {}
    
    // MARK: - LogPlugin method
    
    func log(_ msg: Any) {
        print(msg)
    }
    
    
    // MARK: - WebViewPluginProtocol
    
    public func identifier() -> String {
        return "holo.webView.bridge.log"
    }
    
    public func javascript() -> String {
        if let path = Bundle.init(for: WebViewLogPlugin.self).resourcePath?.appending("/HoloWebViewBridge.bundle"),
           let bundle = Bundle.init(path: path),
           let jsPath = bundle.path(forResource: "log", ofType: "js"),
           let js = try? String(contentsOfFile: jsPath, encoding: .utf8) {
            return js
        }
        return ""
    }
    
    public func didReceiveMessage(_ fun: String, args: [Any]) {
        if fun == "log()", let msg = args.first {
            self.log(msg)
        }
    }
    
}
