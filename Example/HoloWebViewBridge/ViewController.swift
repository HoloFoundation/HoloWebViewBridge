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
        
    }
    
    @IBAction func pushWebVC(_ sender: UIButton) {
        self.navigationController?.pushViewController(WebViewController(), animated: true)
    }
}

