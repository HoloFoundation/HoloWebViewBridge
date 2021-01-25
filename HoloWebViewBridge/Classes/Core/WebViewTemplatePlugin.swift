//
//  WebViewTemplatePlugin.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/25.
//

import Foundation

class WebViewTemplatePlugin: WebViewPluginProtocol {
    
    private init() {}
    
    convenience init(function identifier: String, handler: ResponseHandler?) {
        self.init()
        
        self.function = identifier
        self.handler = handler
    }
    
    
    private var function: String = ""
    private var handler: ResponseHandler?

    // MARK: - LogPlugin method
    
    func log(_ msg: Any) {
        print(msg)
    }
    
    
    // MARK: - WebViewPluginProtocol
    
    public var identifier: String {
        return "holo.webView.bridge.plugin." + self.function
    }
    
    public var javascript: String {
        if let path = Bundle(for: WebViewTemplatePlugin.self).resourcePath?.appending("/HoloWebViewBridge.bundle"),
           let bundle = Bundle(path: path),
           let jsPath = bundle.path(forResource: "template", ofType: "js"),
           var js = try? String(contentsOfFile: jsPath, encoding: .utf8) {
            js = js.replacingOccurrences(of: "{function_name}", with: self.function)
            js = js.replacingOccurrences(of: "{plugin_identifier}", with: self.identifier)
            return js
        }
        return ""
    }
    
    public func didReceiveMessage(_ fun: String, args: [Any]) {
        if fun == self.function {
            self.handler?(args)
        }
    }
    
}
