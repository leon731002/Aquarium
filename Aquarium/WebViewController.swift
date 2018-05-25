//
//  WebViewController.swift
//  Aquarium
//
//  Created by Leon on 2018/5/22.
//  Copyright © 2018年 Leon. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private var webView: WKWebView!
    var urlString: String = ""
    @IBOutlet weak var errorLabel: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initWebView()
        CommonTool.sharedInstance.addSubViewToFullScreen(self.webView, superView: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadUrl()
    }
    
    //MARK: - Public Functions
    public func loadUrl() {
        DispatchQueue.main.async {
            HUD.allowsInteraction = false
            HUD.show(.progress)
        }
        
        if let myURL = URL(string: self.urlString) {
            let myRequest = URLRequest(url: myURL)
            self.webView.load(myRequest)
            
        }
        else {
            DispatchQueue.main.async {
                HUD.hide()
                HUD.allowsInteraction = true
                
                CommonTool.sharedInstance.showAlertView("", msg: GetString.sharedInstance.getString("SettingViewController0003"), viewController: self, buttonTitle: GetString.sharedInstance.getString("SettingViewController0004"))
            }
        }
    }
    
    //MARK: - Private Function
    private func initUIString() {
        self.errorLabel.text = GetString.sharedInstance.getString("SettingViewController0007")
    }
    
    private func loadDataSuccess(_ success: Bool) {
        HUD.hide()
        HUD.allowsInteraction = true
        self.webView.isHidden = !success
    }
    
    private func initWebView() {
        let configuration = WKWebViewConfiguration()
        if #available(iOS 9.0, *) {
            configuration.allowsAirPlayForMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }
        configuration.allowsInlineMediaPlayback = true
        if #available(iOS 9.0, *) {
            configuration.allowsPictureInPictureMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }
        
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        preference.javaScriptCanOpenWindowsAutomatically = true
        
        configuration.preferences = preference
        self.webView = WKWebView(frame: self.view.frame, configuration: configuration)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
    }
    
    //MARK: - WKWebView Delegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async(execute: {
            self.loadDataSuccess(false)
        });
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async(execute: {
            self.loadDataSuccess(true)
        });
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async(execute: {
            self.loadDataSuccess(true)
        });
        
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, cred)
        }
        else
        {
            completionHandler(.performDefaultHandling, nil)
        }
    }

}
