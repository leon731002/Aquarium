//
//  GetString.swift
//  VoteApp
//
//  Created by Leon on 2016/12/13.
//  Copyright © 2016年 KPMG. All rights reserved.
//

import Foundation

class GetString {
    static let stringTableFileName = "StringTable.plist"
    static let sharedInstance = GetString()
    
    //MARK: - Public Functions
    /*
     *Description: 取得對應的多國語系
     *Parameters: key為UI顯示文字的唯一代碼
     *Return: app依照手機語系要顯示的文字內容
     */
    public func getString(_ key: String) -> String {
        let bundle = self.getBundle(self.getCurrentLocaleCode())
        let string = bundle!.localizedString(forKey: key, value: nil, table: nil)
        return string
    }
    
    //MARK: - Private Functions
    /*
     *Description: 取得手機語系
     *Parameters: deviceLanguage為手機語系
     *Return: app要採用的語系Bundle
     */
    private func getBundle(_ deviceLanguage: String) -> Bundle? {
        var language = "en"
        
        if deviceLanguage == "tw" {
            language = "zh-Hant"
        }
        else {
            language = deviceLanguage
        }
        
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        //print("bundle path:\(String(describing: path))")
        return Bundle(path: path!)
    }
    
    /*
     *Description: 取得手機語系
     *Return: 語系代碼
     */
    private func getCurrentLocaleCode() -> String {
        
        let locale: NSLocale = NSLocale.current as NSLocale
        var returnCode = "en"
        
        if let _ = locale.object(forKey: NSLocale.Key.countryCode) as? String {
            
        }
        
        if let idCode = locale.object(forKey: NSLocale.Key.identifier) as? String {
            
            if idCode.components(separatedBy: "_").count > 0 {
                returnCode = idCode.components(separatedBy: "_")[0]
            }
            
        }
        
        if let _ = locale.object(forKey: NSLocale.Key.languageCode) as? String {
            
        }
        
        
        print("language:\(returnCode)")
        
        if returnCode == "zh" {
            returnCode = "tw"
        }
        else {
            if returnCode.contains("zh-Hans") {
                returnCode = "cn"
            } else if returnCode.contains("zh-Hant") {
                returnCode = "tw"
            }
            else {
                returnCode = returnCode.components(separatedBy: "-")[0]
            }
        }
        if returnCode != "ja" {
            returnCode = "en"
        }
        print("returnCode:\(returnCode)")
        return returnCode
    }
    
}
