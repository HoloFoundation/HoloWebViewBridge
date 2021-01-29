//
//  WebViewTemplatePlugin.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/25.
//

import Foundation

class WebViewTemplatePlugin: WebViewPluginProtocol {
        
    convenience init(function identifier: String, handler: ResponseHandler?) {
        self.init()
        self.isCallback = false
        
        self.function = identifier
        self.handler = handler
    }
    
    convenience init(function identifier: String, callbackHandler: ResponseCallbackHandler?) {
        self.init()
        self.isCallback = true
        
        self.function = identifier
        self.callbackHandler = callbackHandler
    }
    
    private init() {}
    
    private var function: String = ""
    private var handler: ResponseHandler?
    private var callbackHandler: ResponseCallbackHandler?
    
    private var isCallback = false
    private var callback: ResponseHandler?
    
    
    // MARK: - WebViewPluginProtocol
    
    var identifier: String {
        return "holo.webView.bridge.plugin." + self.function
    }
    
    var javascript: String {
        if let path = Bundle(for: WebViewTemplatePlugin.self).resourcePath?.appending("/HoloWebViewBridge.bundle"),
           let bundle = Bundle(path: path),
           let jsPath = bundle.path(forResource: self.isCallback ? "template_callback" : "template", ofType: "js"),
           var js = try? String(contentsOfFile: jsPath, encoding: .utf8) {
            js = js.replacingOccurrences(of: "{function_name}", with: self.function)
            js = js.replacingOccurrences(of: "{plugin_identifier}", with: self.identifier)
            return js
        }
        return ""
    }
    
    func didReceiveMessage(_ fun: String, args: [Any]) {
        if fun == self.function {
            if self.isCallback {
                for (index, item) in args.reversed().enumerated() {
                    if let handler = item as? ResponseHandler {
                        var callbackArgs = args
                        // args.count - index - 1: because args.reversed()
                        callbackArgs.remove(at: args.count - index - 1)
                        self.callbackHandler?(callbackArgs, handler)
                        break
                    }
                }
            } else {
                self.handler?(args)
            }
        }
    }
    
}
