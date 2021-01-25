//
//  WebViewBridge.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import WebKit

public class WebViewBridge: NSObject, WKScriptMessageHandler {
    
    public func inject(plugin: WebViewPluginProtocol) {
        let identifier = plugin.identifier
        let javascript = plugin.javascript
        if self.plugins[identifier] != nil {
            debugPrint("has the identifier: \(identifier)")
        }
        self.plugins[identifier] = plugin
        self.inject(source: javascript, injectionTime: .atDocumentEnd)
    }
    
    public func remove(plugin identifier: String) {
        if self.plugins[identifier] == nil {
            debugPrint("no found plugin: \(identifier)")
            return
        }
        self.plugins[identifier] = nil
        self.webView?.configuration.userContentController.removeAllUserScripts()
        self.injectMainJavascript()
        
        self.plugins.values.forEach { (plugin) in
            self.inject(source: plugin.javascript, injectionTime: .atDocumentEnd)
        }
    }
    
    public func removeAllPlugins() {
        self.plugins.removeAll()
        self.webView?.configuration.userContentController.removeAllUserScripts()
        self.injectMainJavascript()
    }
    
    public func invalidate() {
        self.removeAllPlugins()
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: self.messageName)
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
                            if JSONSerialization.isValidJSONObject(params) == true,
                               let data = try? JSONSerialization.data(withJSONObject: params, options: []),
                               let json = String(data: data, encoding: .utf8) {
                                let js = String(format: "window.bridge.closureDispatcher.invoke(%zd, %@)", val, json)
                                self.webView?.evaluateJavaScript(js, completionHandler: nil)
                            }
                        }
                        return handler
                    }
                }
                return ""
            }
            plugin.didReceiveMessage(selector, args: args)
        }
    }
    
    // MARK: - WKScriptMessageHandler
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == self.messageName, let parameters = message.body as? [String:Any] {
            self.js_msgSend(parameters)
        }
    }
    
}
