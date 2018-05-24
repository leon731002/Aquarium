//
//  UIView-Keyboard.swift
//  Event
//
//  Created by Leon on 2016/8/3.
//  Copyright © 2016年 KPMG. All rights reserved.
//

import UIKit

protocol UIViewKeyboardDelegate {
    func keyboardHeightChanged(_ height: CGFloat)
}

class UIView_Keyboard: UIView {

    
    var delegate: UIViewKeyboardDelegate?
    fileprivate var hasRegistedNotification = false
    fileprivate var hasRegistedGesture = false
    fileprivate var tapGesture: UITapGestureRecognizer?
    fileprivate var keyboardHeight: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        
        if !hasRegistedNotification {
            hasRegistedNotification = true
            
            NotificationCenter.default.addObserver(self, selector: #selector(UIView_Keyboard.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(UIView_Keyboard.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView_Keyboard.hideKeyboard))
        }
       
    }
    
    override func removeFromSuperview() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func hideKeyboard() {
        self.endEditing(true)
    }
    
    func keyboardDidShow(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                print("keyboardSize.height:\(keyboardSize.height)")
                self.keyboardHeight = keyboardSize.height
                if self.delegate != nil {
                    self.delegate?.keyboardHeightChanged(self.keyboardHeight)
                }
            }
        }
        
        if self.tapGesture != nil {
            if !self.hasRegistedGesture {
                self.hasRegistedGesture = true
                self.addGestureRecognizer(self.tapGesture!)
            }
        }
        
    }
    
    func keyboardDidHide(_ notification: Notification) {
        self.keyboardHeight = 0
        if self.tapGesture != nil {
            if self.hasRegistedGesture {
                self.hasRegistedGesture = false
                self.removeGestureRecognizer(self.tapGesture!)
            }
        }
        if self.delegate != nil {
            self.delegate?.keyboardHeightChanged(self.keyboardHeight)
        }
        
    }
}
