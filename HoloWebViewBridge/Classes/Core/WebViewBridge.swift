//
//  WebViewBridge.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import WebKit

public class WebViewBridge: NSObject, WKScriptMessageHandler {
    
    /// inject a plugin
    public func inject(plugin: WebViewPluginProtocol) {
        let identifier = plugin.identifier
        if self.plugins[identifier] != nil {
            self.remove(plugin: identifier)
            debugPrint("[HoloWebViewBridge] You have injected a plugin with the identifier: \(identifier), which will overwrite it.")
        }
        self.plugins[identifier] = plugin
        
        let javascript = plugin.javascript
        if javascript.count > 0 {
            self.inject(source: javascript, injectionTime: .atDocumentEnd)
        }
    }
    
    /// inject a function with a handler
    public func inject(function identifier: String, handler: ResponseHandler?) {
        if !identifier.hasPrefix("window.") {
            debugPrint("[HoloWebViewBridge] The function identifier must begin with 'window.'.")
            return
        }
        let plugin = WebViewTemplatePlugin(function: identifier, handler: handler)
        self.inject(plugin: plugin)
    }
    
    /// inject a function with a callbackHandler
    public func inject(function identifier: String, callbackHandler: ResponseCallbackHandler?) {
        if !identifier.hasPrefix("window.") {
            debugPrint("[HoloWebViewBridge] The function identifier must begin with 'window.'.")
            return
        }
        let plugin = WebViewTemplatePlugin(function: identifier, callbackHandler: callbackHandler)
        self.inject(plugin: plugin)
    }
    
    /// remove a plugin with an identifier
    public func remove(plugin identifier: String) {
        if self.plugins[identifier] == nil {
            debugPrint("[HoloWebViewBridge] No found a plugin with the identifier: \(identifier).")
            return
        }
        self.plugins[identifier] = nil
        self.webView?.configuration.userContentController.removeAllUserScripts()
        self.injectMainJavascript()
        
        self.plugins.values.forEach { (plugin) in
            self.inject(source: plugin.javascript, injectionTime: .atDocumentEnd)
        }
    }
    
    /// remove a function with an identifier
    public func remove(function identifier: String) {
        let key = WebViewTemplatePlugin.identifier(identifier)
        self.remove(plugin: key)
    }
    
    /// remove all plugins and functions
    public func removeAll() {
        self.plugins.removeAll()
        self.webView?.configuration.userContentController.removeAllUserScripts()
        self.injectMainJavascript()
    }
    
    /// invalidate() will be called automatically when a WKWebView is deinited
    public func invalidate() {
        self.removeAll()
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: self.messageName)
    }
    
    deinit {
        self.invalidate()
    }
    
    internal weak var webView: WKWebView?
    
    internal init(webView: WKWebView) {
        self.webView = webView
        super.init()
        
        // should remove while deinit
        self.webView?.configuration.userContentController.add(self, name: self.messageName)
        self.injectMainJavascript()
    }
    
    private var plugins = [String:WebViewPluginProtocol]()
    
    private let messageName = "bridge", identifier = "identifier", selector = "selector", args = "args", flags = "flags", val = "val"
    
    private func injectMainJavascript() {
        if let path = Bundle(for: WebViewBridge.self).resourcePath?.appending("/HoloWebViewBridge.bundle"),
           let bundle = Bundle(path: path),
           let jsPath = bundle.path(forResource: "main", ofType: "js"),
           let mainJS = try? String(contentsOfFile: jsPath, encoding: .utf8) {
            self.inject(source: mainJS, injectionTime: .atDocumentStart)
        }
    }
    
    private func inject(source: String, injectionTime: WKUserScriptInjectionTime) {
        let userScript = WKUserScript(source: source, injectionTime: injectionTime, forMainFrameOnly: false)
        self.webView?.configuration.userContentController.addUserScript(userScript)
    }
    
    private func js_msgSend(_ parameters: [String:Any]) {
        if let identifier = parameters[self.identifier] as? String,
           let selector = parameters[self.selector] as? String,
           let parameters = parameters[self.args] as? [[String:Any]],
           let plugin = self.plugins[identifier] {
            
            let args: [Any] = parameters.map { (element) in
                if let flags = element[self.flags] as? Int, let val = element[self.val] {
                    if flags == 0 {
                        return val
                    } else if flags == 1, let val = val as? Int {
                        let handler: ResponseHandler = { [weak self] params in
                            guard let self = self else { return }
                            var args = ""
                            if let params = params {
                                let paramsArray = [params]
                                if JSONSerialization.isValidJSONObject(paramsArray) == true,
                                   let data = try? JSONSerialization.data(withJSONObject: paramsArray, options: []),
                                   let json = String(data: data, encoding: .utf8) {
                                    args = json
                                    args = String(args.dropFirst())
                                    args = String(args.dropLast())
                                }
                            }
                            let js = String(format: "window.bridge.js_funSend.invoke(%zd, %@)", val, args)
                            self.webView?.evaluateJavaScript(js, completionHandler: nil)
                        }
                        return handler
                    }
                }
                return ""
            }
            plugin.didReceiveMessage(selector, args: args.count > 1 ? args : args.first)
        }
    }
    
    // MARK: - WKScriptMessageHandler
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == self.messageName, let parameters = message.body as? [String:Any] {
            self.js_msgSend(parameters)
        }
    }
    
}
