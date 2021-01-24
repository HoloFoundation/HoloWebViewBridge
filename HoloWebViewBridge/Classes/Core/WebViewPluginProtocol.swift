//
//  WebViewPluginProtocol.swift
//  HoloWebViewBridge
//
//  Created by 与佳期 on 2021/1/23.
//

import Foundation
import WebKit

public typealias ResponseClosure = ((_ args: [Any]) -> Void)

public protocol WebViewPluginProtocol {
        
    func identifier() -> String
    
    func javascript() -> String
    
    func didReceiveMessage(_ fun: String, args: [Any])
    
}
