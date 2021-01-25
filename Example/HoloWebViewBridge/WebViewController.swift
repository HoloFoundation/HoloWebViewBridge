//
//  WebViewController.swift
//  HoloWebViewBridge_Example
//
//  Created by 与佳期 on 2021/1/25.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import HoloWebViewBridge

class WebViewController: UIViewController {
    
    deinit {
        print("WebViewController deinit")
        self.webView.holo.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.webView)
        
        if let path = Bundle(for: ViewController.self).path(forResource: "demo", ofType: "html"),
           let html = try? String(contentsOfFile: path, encoding: .utf8) {
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }


    lazy var webView: WKWebView = {
        let _configuration = WKWebViewConfiguration()
        let _webView = WKWebView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 400), configuration: _configuration)
        
        _webView.holo.inject(plugin: WebViewLogPlugin())
        _webView.holo.inject(plugin: WebViewAlertPlugin())
        
        return _webView
    }()

}
