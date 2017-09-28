//
//  ViewController.swift
//  ios-monaco-editor
//
//  Created by Yuanyuan Liu on 28/9/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.navigationDelegate = self
        guard let resURL = Bundle.main.resourceURL else {
            return
        }
        
        let htmlURL = resURL.appendingPathComponent("static/main.html");
        let dirURL = resURL.appendingPathComponent("static");
        
        webView.loadFileURL(htmlURL, allowingReadAccessTo: dirURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func printContent(_ sender: Any) {
    }
    
    @IBAction func runJS(_ sender: Any) {
    }
}


extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
    }
}
