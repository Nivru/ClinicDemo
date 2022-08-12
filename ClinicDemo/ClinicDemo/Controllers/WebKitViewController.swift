//
//  WebKitViewController.swift
//  ClinicDemo
//
//  Created by Nivrutti on 12/08/22.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    
    var webView: WKWebView!
    var strPetInfoURL = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: strPetInfoURL)!

        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}

extension WebKitViewController : WKNavigationDelegate {
    
}
