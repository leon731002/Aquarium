//
//  HttpRequestFactory.swift
//  Event
//
//  Created by Leon on 2015/10/26.
//  Copyright © 2015年 KPMG. All rights reserved.
//

import UIKit

enum HTTP_REQUEST_TYPE: String {
    case login                      = "/mobile/sensor"
    case register                    = "/device/signageregister"
}

class HttpRequestFactory {
    static let sharedInstance = HttpRequestFactory()
    
    static let HTTP_UNKONW_FAIL_CODE: Int = -9876
    static let HTTP_UNKONWSERVER_FAIL_CODE: Int = -12345
    
    private let serverCommandVersion = "2"
    var web: String = ""
    var connectWithDeviceName: String = ""
    
    func sendHttpRequest(serverIP: String, requestType: HTTP_REQUEST_TYPE, querySource:Any, completion: @escaping (Any) -> Void) {
        
        if self.web == "" && serverIP == "" {
            completion(HttpRequestFactory.HTTP_UNKONWSERVER_FAIL_CODE)
            return
        }
        if requestType == .login {
            self.sendLoginActionRequest(serverIP: serverIP) {
                (result: (String,String)) in
                completion(result)
            }
        } else if requestType == .register {
            self.sendLoginActionRequest(serverIP: serverIP) {
                (result: (String,String)) in
                completion(result)
            }
        }
    }
    
    //MARK: 發送登入需求
    private func sendLoginActionRequest(serverIP: String, completion: @escaping(_ result: (String,String)) -> Void) {
        var deviceName = ""
        var domainName = ""
//        let account = WebServerManager.validAccount
//        let password = WebServerManager.validPassword
        
        let myRequestString = ""
        let request = self.getRequestForPost(serverIP: serverIP, url: "\(HTTP_REQUEST_TYPE.login.rawValue)", postString: myRequestString as NSString)
        
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60
        let session = URLSession(configuration: sessionConfig)

        let task = session.dataTask(with: request as URLRequest, completionHandler: { (responseJson, response, error) in
            if (error != nil) {
                print("\(serverIP) login error:\(error!.localizedDescription)")
            }
            else {
                if responseJson != nil && responseJson!.count > 0 {
                    print("\(serverIP) login resp string:\(String(describing: NSString(data:responseJson!, encoding:String.Encoding.utf8.rawValue)))")
                    
                    if let jsonResult = (try? JSONSerialization.jsonObject(with: responseJson!, options:JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary {
                        if let value = jsonResult["deviceName"] as? String {
                            deviceName = value
                        }
                        if let value = jsonResult["server"] as? String {
                            domainName = value
                        }
                        completion((domainName, deviceName))
                        return
                    }
                }
            }
            completion(("",""))
            return
        })
        task.resume()
    }
    
    //MARK:
    func getRequestForPost(serverIP: String, url: String, postString: NSString) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: serverIP + url)! as URL)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        if postString != "" {
            request.httpBody = postString.data(using: String.Encoding.utf8.rawValue)
        }
        
        return request
    }
    
    func getRequestForGet(serverIP: String, url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: serverIP + url)! as URL)
        request.httpMethod = "GET"
        return request
    }
    
}
