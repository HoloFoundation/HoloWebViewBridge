//
//  WebViewBridge.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import WebKit

public class WebViewBridge: NSObject, WKScriptMessageHandler {
    
    public func inject(_ plugin: WebViewPluginProtocol) {
        self.plugins[plugin.identifier()] = plugin
        self.inject(plugin.javascript(), injectionTime: .atDocumentEnd)
    }
    
    public func remove(_ plugin: WebViewPluginProtocol) {
        self.plugins[plugin.identifier()] = nil
        self.webView.configuration.userContentController.removeScriptMessageHandler(forName: plugin.identifier())
    }
    
    public func removeAll() {
        self.plugins.removeAll()
        self.webView.configuration.userContentController.removeAllUserScripts()
    }
    
    
    internal let webView: WKWebView
    
    internal init(webView: WKWebView) {
        self.webView = webView
        super.init()
        
        self.webView.configuration.userContentController.add(self, name: self.messageName)
        self.injectMainJavascript()
    }
    
    private var plugins = [String:WebViewPluginProtocol]()
    
    private let messageName = "bridge", identifier = "identifier", selector = "selector", args = "args", flags = "flags", val = "val"
    
    private func injectMainJavascript() {
        if let path = Bundle.init(for: WebViewBridge.self).resourcePath?.appending("/HoloWebViewBridge.bundle"),
           let bundle = Bundle.init(path: path),
           let jsPath = bundle.path(forResource: "main", ofType: "js"),
           let mainJavascript = try? String(contentsOfFile: jsPath, encoding: .utf8) {
            self.inject(mainJavascript, injectionTime: .atDocumentStart)
        }
    }
    
    private func inject(_ source: String, injectionTime: WKUserScriptInjectionTime) {
        let userScript = WKUserScript.init(source: source, injectionTime: injectionTime, forMainFrameOnly: false)
        self.webView.configuration.userContentController.addUserScript(userScript)
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
                        let closure: ResponseClosure = { params in
                            if JSONSerialization.isValidJSONObject(params) == true,
                               let data = try? JSONSerialization.data(withJSONObject: params, options: []),
                               let json = String.init(data: data, encoding: .utf8) {
                                let js = String(format: "window.bridge.closureDispatcher.invoke(%zd, %@)", val, json)
                                self.webView.evaluateJavaScript(js, completionHandler: nil)
                            }
                        }
                        return closure
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
