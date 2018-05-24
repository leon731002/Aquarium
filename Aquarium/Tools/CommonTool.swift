//
//  CommonTool.swift
//  Event
//
//  Created by Leon on 2015/10/30.
//  Copyright © 2015年 KPMG. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import Social
import WebKit

class CommonTool: NSObject, UIAlertViewDelegate {
    
    static let sharedInstance = CommonTool()
    /*
     *Description: 將subView用autolayout的方式, 加到superView
     *Parameters: subView為子元件, superView為主頁面或元件
     */
    func addSubViewToFullScreen(_ subView: UIView, superView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(subView)
        var popViewConstraint = NSLayoutConstraint(item: subView,
            attribute: .left,
            relatedBy: .equal,
            toItem: superView,
            attribute: .left,
            multiplier: 1.0,
            constant: 0.0);
        superView.addConstraint(popViewConstraint)
        
        popViewConstraint = NSLayoutConstraint(item: subView,
            attribute: .right,
            relatedBy: .equal,
            toItem: superView,
            attribute: .right,
            multiplier: 1.0,
            constant: 0.0);
        superView.addConstraint(popViewConstraint)
        
        popViewConstraint = NSLayoutConstraint(item: subView,
            attribute: .top,
            relatedBy: .equal,
            toItem: superView,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0);
        superView.addConstraint(popViewConstraint)
        
        popViewConstraint = NSLayoutConstraint(item: subView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: superView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0);
        superView.addConstraint(popViewConstraint)
        
        subView.layoutIfNeeded()
    }
    
    /*
     *Description: 將UI元件的邊角修圓
     *Parameters: buttonView為UI元件, 可以是Button或ImageView
     */
    func clipButtonCorner(_ buttonView: UIView) {
        let imageLayer = buttonView.layer;
        imageLayer.cornerRadius = 5
        imageLayer.borderWidth = 0
        imageLayer.masksToBounds = true
    }
    
    /*
     *Description: 彈出提示訊息, 僅有一個確認鍵
     *Parameters: title為標題, message為內容, viewController為要顯示的頁面, buttonTitle為確認鍵文字
     */
    func showAlertView(_ title: String,msg: String, viewController: UIViewController, buttonTitle: String) {
        
        self.showAlertView(title, msg: msg, viewController: viewController, cancelTitle: buttonTitle, buttonTitles: nil) {
            (action: UIAlertAction) in
        }
        
    }
    
    /*
     *Description: 彈出提示訊息, 可有一個或多個按鈕
     *Parameters: title為標題, message為內容, viewController為要顯示的頁面, cancelTitle為取消按鈕的文字, buttonTitles為其他選項按鈕的文字, completion為callback function point可用action.title作為判斷, 定義各按鈕的反應行為
     */
    func showAlertView(_ title: String,msg: String, viewController: UIViewController, cancelTitle: String, buttonTitles: [String]?, completion: @escaping (_ action: UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: msg,
            preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction) -> Void in
            completion(action)
        }))
        
        if buttonTitles != nil {
            for buttonTitle in buttonTitles! {
                alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: {
                    (action: UIAlertAction) -> Void in
                    completion(action)
                    
                }))
            }
        }
        
        
        DispatchQueue.main.async(execute: {
            viewController.present(alert, animated: true, completion: nil)
        })
        
    }
}
