//
//  SharedPreferenceManager.swift
//  Aquarium
//
//  Created by Leon on 2018/5/24.
//  Copyright © 2018年 Leon. All rights reserved.
//

import Foundation

enum SharedPreferenceKey: String {
    case ip =   "IP"
}

class SharedPreferenceManager: NSObject {
    static let sharedInstance = SharedPreferenceManager()
    
    /*
     *Description: 用key搜尋儲存的數值, 統一為字串格式, 再由各頁面去轉類別
     *Parameters: key是數值對應的索引標籤
     *Return: 數值
     */
    func getValueByKey(_ key: SharedPreferenceKey) -> String {
        var value: String = ""
        let userDefaultData = UserDefaults.standard
        if(userDefaultData.value(forKey: key.rawValue) != nil){
            value = userDefaultData.string(forKey: key.rawValue)!
        }
        
        return value
    }
    
    /*
     *Description: 儲存數值到特定的key, 統一為字串格式
     *Parameters: key是數值的索引標籤, value是儲存的數值
     */
    func saveValueForKey(_ key: SharedPreferenceKey, value: String) {
        let userDefaultData = UserDefaults.standard
        userDefaultData.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
