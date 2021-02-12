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
        
    // MARK: - AlertPlugin method
        
    func alert(_ msg: String) {
        let alertVC = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm", style: .cancel, handler: nil)
        alertVC.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    func alertConfirm(_ msg: String, responseHandler: ResponseHandler?) {
        let alertVC = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm", style: .cancel) { (action) in
            responseHandler?("confirm")
        }
        alertVC.addAction(action)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
    }
    
    
    // MARK: - WebViewPluginProtocol
    
    public var identifier: String {
        return "holo.webview.bridge.example.alert"
    }
    
    public var javascript: String {
        if let path = Bundle(for: WebViewAlertPlugin.self).path(forResource: "alert", ofType: "js"),
           let js = try? String(contentsOfFile: path, encoding: .utf8) {
            return js
        }
        return ""
    }
    
    func didReceiveMessage(_ fun: String, args: Any?) {
        if fun == "alert()" {
            if let msg = args as? String {
                self.alert(msg)
            }
            return
        }
        
        if fun == "alert(confirm)" {
            if let args = args as? [Any], let msg = args.first as? String, let handler = args.last as? ResponseHandler {
                self.alertConfirm(msg, responseHandler: handler)
            }
            return
        }
    }
    
    
}
