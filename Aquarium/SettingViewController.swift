//
//  ViewController.swift
//  Aquarium
//
//  Created by Leon on 2018/5/20.
//  Copyright © 2018年 Leon. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate, ReachabilityManagerDelegate, UIViewKeyboardDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var ipTitleLabel: UILabel!
    @IBOutlet weak var bottomConstraintOfContentView: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView_Keyboard!
    private let bottomOfContentView: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ReachabilityManager.sharedInstance.registerListener(observer: self)
        contentView.delegate = self
        self.initUIString()
        CommonTool.sharedInstance.clipButtonCorner(self.saveButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.autoConnectAnExistingServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connectAction(_ sender: UIButton) {
        let (urlString, ipString) = self.autoCorrectUrlString(self.ipTextField.text!)
        if self.checkIfServerIsAvailable(urlString) {
            SharedPreferenceManager.sharedInstance.saveValueForKey(.ip, value: urlString)
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let webView = storyBoard.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
                webView.urlString = urlString
                self.present(webView, animated: true, completion: nil)
            }
        }
        else {
            DispatchQueue.main.async {
                CommonTool.sharedInstance.showAlertView("", msg: GetString.sharedInstance.getString("SettingViewController0003"), viewController: self, buttonTitle: GetString.sharedInstance.getString("SettingViewController0004"))
            }
        }
    }
    
    //MARK: - Private Functions
    private func autoConnectAnExistingServer() {
        let ip = SharedPreferenceManager.sharedInstance.getValueByKey(.ip)
        if ip != "" {
            DispatchQueue.main.async {
                self.ipTextField.text = ip
            }
            
            self.connectAction(UIButton())
        }
    }
    private func initUIString() {
        self.ipTitleLabel.text = GetString.sharedInstance.getString("SettingViewController0001")
        self.saveButton.setTitle(GetString.sharedInstance.getString("SettingViewController0002"), for: UIControlState())
    }
    
    private func autoCorrectUrlString(_ urlString: String) -> (urlString: String, ipString: String) {
        if urlString.starts(with: "https://") {
            return (urlString, urlString.components(separatedBy: "https://")[1])
        }
        else if urlString.starts(with: "http://") {
            return (urlString, urlString.components(separatedBy: "http://")[1])
        }
        else {
            return ("http://\(urlString)", urlString)
        }
    }
    
    private func checkIfServerIsAvailable(_ serverUrl: String) -> Bool {
        if let url = URL(string: serverUrl) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    //MARK: - Keyboard Events Handling
    func keyboardHeightChanged(_ height: CGFloat) {
        DispatchQueue.main.async {
            self.bottomConstraintOfContentView.constant = self.bottomOfContentView + height
            self.view.updateConstraints()
        }
    }
    
    //MARK: - TextField Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        }
        self.view.endEditing(true)
        return true
    }
    
    //MARK: - Reachability Delegate
    //MARK: ReachabilityManagerDelegate
    func networkAvailable() {
        
    }
    
    func networkUnavailable() {
        if let controller = self.presentedViewController {
            CommonTool.sharedInstance.showAlertView("", msg: GetString.sharedInstance.getString("SettingViewController0005"), viewController: controller, cancelTitle: GetString.sharedInstance.getString("SettingViewController0004"), buttonTitles: nil) {
                (action: UIAlertAction) in
                self.dimissAllTopView() {
                    let ip = SharedPreferenceManager.sharedInstance.getValueByKey(.ip)
                    if ip != "" {
                        SharedPreferenceManager.sharedInstance.saveValueForKey(.ip, value: "")
                    }
                }
            }
            
        }
        
    }
    
    func hostAvailable() {
        
    }
    
    func hostUnavailable() {
        if let _ = self.presentedViewController {
            self.dimissAllTopView() {
                let ip = SharedPreferenceManager.sharedInstance.getValueByKey(.ip)
                if ip != "" {
                    SharedPreferenceManager.sharedInstance.saveValueForKey(.ip, value: "")
                }
            }
        }
    }
    
    private func dimissAllTopView(completion: @escaping () -> ()) {
        if let topView = self.presentedViewController {
            DispatchQueue.main.async {
                topView.dismiss(animated: true, completion: {
                    self.dimissAllTopView(completion: completion)
                })
            }
        }
        else {
            completion()
        }
    }
}

