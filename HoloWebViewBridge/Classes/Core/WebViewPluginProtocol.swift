//
//  WebViewPluginProtocol.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import Foundation
import WebKit

public typealias ResponseHandler = ((_ args: [Any]) -> Void)

public typealias ResponseCallbackHandler = ((_ args: [Any], _ callback: ResponseHandler?) -> Void)

public protocol WebViewPluginProtocol {
    
    /// Unique identity
    /// Make sure that the identity of the plug-in you add is unique
    ///
    /// Example:
    /// holo.webView.bridge.log
    var identifier: String { get }
    
    /// JavaScript code
    /// The JavaScript code is going to be injected into the WebView
    ///
    /// Example:
    /// window.bridge.log = function(msg) {
    ///     window.bridge.js_msgSend("holo.webView.bridge.log", "log()", msg)
    /// }
    var javascript: String { get }
    
    /// This method is called when JavaScript executes the injected method
    /// - Parameters:
    ///   - fun: Identifies the method executed by JavaScript
    ///   - args: Parameter passed to the method executed by JavaScript
    ///
    /// Example:
    /// JS:         window.bridge.log("hello")
    /// Native:     didReceiveMessage("log()", args: ["hello"])
    func didReceiveMessage(_ fun: String, args: [Any])
    
}
