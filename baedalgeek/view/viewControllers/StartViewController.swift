//
//  ViewController.swift
//  baedalgeek
//
//  Created by Nine on 02/07/2019.
//  Copyright © 2019 clouldStone. All rights reserved.
//

import UIKit
import WebKit

class StartViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var mainWebview: WKWebView!
    @IBOutlet weak var splashView: UIView!
    
    var webViewControl:WKWebviewControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webViewControl = WKWebviewControl(self, webviewObj: self.mainWebview)
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.splashView.isHidden = true
        })
    }
}
