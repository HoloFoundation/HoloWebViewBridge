//
//  ViewController.swift
//  HoloWebViewBridge
//
//  Created by gonghonglou on 01/23/2021.
//  Copyright (c) 2021 gonghonglou. All rights reserved.
//

import UIKit
import WebKit
import HoloWebViewBridge

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(self.webView)
        
        if let path = Bundle.init(for: ViewController.self).path(forResource: "demo", ofType: "html"),
           let html = try? String(contentsOfFile: path, encoding: .utf8) {
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }


    lazy var webView: WKWebView = {
        let _configuration = WKWebViewConfiguration()
        let _webView = WKWebView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 400), configuration: _configuration)
        _webView.backgroundColor = .lightGray
        
        _webView.holo.inject(WebViewLogPlugin())
        _webView.holo.inject(WebViewAlertPlugin())
        
        return _webView
    }()

}

