//
//  WebViewPluginProtocol.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import Foundation
import WebKit

/// If there are no arguments, `args` is nil;
/// If there is only one argument, then `args` is the argument;
/// If there are multiple arguments, they are wrapped in an array and passed to `args`.
///     
///     args = arguments.count > 1 ? arguments : arguments.first
public typealias ResponseHandler = ((_ args: Any?) -> Void)

/// If the arguments contains a function, then pass the function to the `handler`, then remove the function from the arguments.
/// The remaining parameters are determined again:
/// If there are no arguments, `args` is nil;
/// If there is only one argument, then `args` is the argument;
/// If there are multiple arguments, they are wrapped in an array and passed to `args`.
///
///     if arguments.contains(closure) {
///         handler = closure
///         arguments.remove(closure)
///     }
///     args = arguments.count > 1 ? arguments : arguments.first
public typealias ResponseCallbackHandler = ((_ args: Any?, _ handler: ResponseHandler?) -> Void)


public protocol WebViewPluginProtocol {
    
    /// Unique identity
    /// Make sure that the identity of the plug-in you add is unique
    ///
    ///     Example:
    ///     holo.webView.bridge.log
    var identifier: String { get }
    
    /// JavaScript code
    /// The JavaScript code is going to be injected into the WebView
    ///
    ///     Example:
    ///     window.bridge.log = function(msg) {
    ///         window.bridge.js_msgSend("holo.webView.bridge.log", "log()", msg)
    ///     }
    var javascript: String { get }
    
    /// This method is called when JavaScript executes the injected method
    /// - Parameters:
    ///   - fun: Identifies the method executed by JavaScript
    ///   - args: Parameter passed to the method executed by JavaScript
    ///
    ///         Example 1:
    ///         JS:     window.bridge.log("hello")
    ///         Native: didReceiveMessage("log()", args: "hello")
    ///
    ///         Example 2:
    ///         JS:     window.bridge.log("hello", "word")
    ///         Native: didReceiveMessage("log()", args: ["hello", "word"])
    func didReceiveMessage(_ fun: String, args: Any?)
    
}
