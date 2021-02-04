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
        
        self.functionId = identifier
        self.handler = handler
    }
    
    convenience init(function identifier: String, callbackHandler: ResponseCallbackHandler?) {
        self.init()
        self.isCallback = true
        
        self.functionId = identifier
        self.callbackHandler = callbackHandler
    }
    
    static func identifier(_ functionId: String) -> String {
        return "holo.webView.bridge.plugin." + functionId
    }
    
    private init() {}
    
    private var functionId = ""
    private var handler: ResponseHandler?
    private var callbackHandler: ResponseCallbackHandler?
    
    private var isCallback = false
    private var callback: ResponseHandler?
    
    
    // MARK: - WebViewPluginProtocol
    
    var identifier: String {
        return WebViewTemplatePlugin.identifier(self.functionId)
    }
    
    var javascript: String {
        var define = "// define js function\n\n"
        var fun = ""
        let arr = self.functionId.split(separator: ".")
        arr.forEach { (item) in
            fun.append(String(item))
            if item != arr.first && item != arr.last {
                define = define.appending("if (!\(fun)) { \(fun) = {} }\n\n")
            }
            if item != arr.last {
                fun.append(".")
            }
        }
        
        if let path = Bundle(for: WebViewTemplatePlugin.self).resourcePath?.appending("/HoloWebViewBridge.bundle"),
           let bundle = Bundle(path: path),
           let jsPath = bundle.path(forResource: self.isCallback ? "template_callback" : "template", ofType: "js"),
           var js = try? String(contentsOfFile: jsPath, encoding: .utf8) {
            js = js.replacingOccurrences(of: "{function_name}", with: self.functionId)
            js = js.replacingOccurrences(of: "{plugin_identifier}", with: self.identifier)
            return define + js
        }
        return ""
    }
    
    func didReceiveMessage(_ fun: String, args: Any?) {
        if fun == self.functionId {
            if self.isCallback, var args = args as? [Any] {
                for (index, item) in args.reversed().enumerated() {
                    if let handler = item as? ResponseHandler {
                        // args.count - index - 1: because args.reversed()
                        args.remove(at: args.count - index - 1)
                        self.callbackHandler?(args.count > 1 ? args : args.first, handler)
                        break
                    }
                }                
            } else {
                self.handler?(args)
            }
        }
    }
    
}
