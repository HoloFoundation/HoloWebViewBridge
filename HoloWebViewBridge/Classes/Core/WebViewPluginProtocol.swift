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
    
    var identifier: String { get }
    
    var javascript: String { get }
    
    func didReceiveMessage(_ fun: String, args: [Any])
    
}
