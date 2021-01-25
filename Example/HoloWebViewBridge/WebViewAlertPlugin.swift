//
//  WebViewAlertPlugin.swift
//  HoloWebViewBridge_Example
//
//  Created by 与佳期 on 2021/1/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import HoloWebViewBridge

class WebViewAlertPlugin: WebViewPluginProtocol {
    
    deinit {
        print("WebViewAlertPlugin deinit")
    }
    
    public init() {}
    
    // MARK: - AlertPlugin method
    
    var responseClosure: ResponseClosure?
    
    func alert(_ msg: String) {
        let alertVC = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm", style: .cancel) { [weak self] (action) in
            guard let self = self else { return }
            self.responseClosure?(["hello", "world", 1])
        }
        alertVC.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    
    // MARK: - WebViewPluginProtocol
    
    func identifier() -> String {
        return "holo.webview.bridge.example.alert"
    }
    
    func javascript() -> String {
        if let path = Bundle(for: ViewController.self).path(forResource: "alert", ofType: "js"),
           let js = try? String(contentsOfFile: path, encoding: .utf8) {
            return js
        }
        return ""
    }
    
    func didReceiveMessage(_ fun: String, args: [Any]) {
        if fun == "alert(confirm)", let msg = args.first as? String, let closure = args.last as? ResponseClosure {
            self.responseClosure = closure
            self.alert(msg)
        }
    }
    
    
}
