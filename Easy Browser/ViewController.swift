//
//  ViewController.swift
//  Easy Browser
//
//  Created by Yohannes Wijaya on 8/4/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

    import UIKit
    import WebKit

    class ViewController: UIViewController, WKNavigationDelegate {
        
        // MARK: - Stored properties
        
        var webView: WKWebView!
        var progressView: UIProgressView!
        let websites: Array<String> = ["techmeme.com", "google.com", "duckduckgo.com"]
        
        // MARK: - Superclass methods override
        
        override func loadView() {
            self.webView = WKWebView()
            self.webView.navigationDelegate = self
            self.view = self.webView
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: UIBarButtonItemStyle.Plain, target: self, action: "openTapped")
            self.progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
            self.progressView.sizeToFit()
            let progressButton = UIBarButtonItem(customView: self.progressView)
            let spacerBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
            let refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self.webView, action: "reload" )
            self.toolbarItems = [progressButton, spacerBarButtonItem, refreshBarButtonItem]
            self.navigationController?.toolbarHidden = false
            self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
            if let url = NSURL(string: "https://" + self.websites[0]) {
                self.webView.loadRequest(NSURLRequest(URL: url))
                self.webView.allowsBackForwardNavigationGestures = true
            }
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [NSObject : AnyObject]?, context: UnsafeMutablePointer<Void>) {
            if keyPath == "estimatedProgress" { self.progressView.progress = Float(self.webView.estimatedProgress) }
        }
        
         // MARK: - Delegate methods
        
        func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
            self.title = self.webView.title!
        }
        
        func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
            let url = navigationAction.request.URL!
            if let host = url.host {
                for site in self.websites {
                    if host.rangeOfString(site) != nil {
                        decisionHandler(WKNavigationActionPolicy.Allow)
                        return
                    }
                }
            }
            decisionHandler(WKNavigationActionPolicy.Cancel)
        }

        // MARK: - Local methods
        
        func openTapped() {
            let alertController = UIAlertController(title: "Open page...", message: "Tap the page you want to access", preferredStyle: UIAlertControllerStyle.ActionSheet)
            for site in self.websites {
                alertController.addAction(UIAlertAction(title: site, style: UIAlertActionStyle.Default, handler: openPage))
            }
            alertController.addAction(UIAlertAction(title: "Cancel...", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        func openPage(alertAction: UIAlertAction) {
            let url = NSURL(string: "https://" + alertAction.title!)
            self.webView.loadRequest(NSURLRequest(URL: url!))
        }
        
    }

