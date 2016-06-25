//
//  WebViewController.swift
//  SensorVisualizer
//
//  Created by Joseph Blau on 6/25/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
