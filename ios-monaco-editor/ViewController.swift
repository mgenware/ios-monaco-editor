//
//  ViewController.swift
//  ios-monaco-editor
//
//  Created by Yuanyuan Liu on 28/9/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let WebViewMessageEditorLoaded = "editorLoaded"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        guard let resURL = Bundle.main.resourceURL else {
            return
        }
        
        let htmlURL = resURL.appendingPathComponent("static/main.html");
        let dirURL = resURL.appendingPathComponent("static");
        webView.configuration.userContentController.add(self, name: WebViewMessageEditorLoaded)
        
        webView.loadFileURL(htmlURL, allowingReadAccessTo: dirURL)
        
        // animate the indicator
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.labelText = "Initializing monaco editor..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func printContent(_ sender: Any) {
        webView.evaluateJavaScript("printValue()", completionHandler: nil);
    }
    
    @IBAction func setContent(_ sender: Any) {
        webView.evaluateJavaScript("setValue(\"['Monaco', 'Editor', 'is', 'great'].join(' ');\")", completionHandler: nil);
    }
    
    @IBAction func runJS(_ sender: Any) {
        webView.evaluateJavaScript("runJS()") { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
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

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == WebViewMessageEditorLoaded {
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
}

