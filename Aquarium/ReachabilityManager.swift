//
//  ReachabilityManager.swift
//  MobileOffice_JP
//
//  Created by Leon on 2017/5/5.
//  Copyright © 2017年 Jason. All rights reserved.
//

import UIKit

protocol ReachabilityManagerDelegate {
    func networkAvailable()
    func networkUnavailable()
    func hostAvailable()
    func hostUnavailable()
}

class ReachabilityManager: NSObject {

    static let sharedInstance = ReachabilityManager()
    static let reachabilityNotificationName = "kNetworkReachabilityChangedNotification"
    private var hostReachability: Reachability? = nil
    private var networkReachability = Reachability()
    
    private let listeners = NSMutableArray()
    
    override init() {
        super.init()
        self.startWatching()
    }
    
    //MARK: public functions
    func setHost(name hostName: String) {
        print("check host name:\(hostName)")
        if self.hostReachability != nil {
            self.hostReachability!.stopNotifier()
        }
        self.hostReachability = Reachability(hostName: hostName)
        self.hostReachability!.startNotifier()
        self.updateInterfaceWithReachability(reachability: self.hostReachability!)
    }
    
    func registerListener(observer: ReachabilityManagerDelegate) {
        
        if self.listeners.contains(observer) {
            
        }
        else {
            
            self.listeners.add(observer)
        }
        
        if self.hostReachability != nil {
            self.updateInterfaceWithReachability(reachability: self.hostReachability!)
        }
        self.updateInterfaceWithReachability(reachability: self.networkReachability)
    }
    
    func unregisterListener(observer: ReachabilityManagerDelegate) {
        if self.listeners.contains(observer) {
            
            self.listeners.remove(observer)
        }
        else {
            
        }
    }
    
    //MARK: private functions
    private func startWatching() {
        NotificationCenter.default.addObserver(self, selector: #selector(ReachabilityManager.reachabilityChangedAction(notification:)), name: NSNotification.Name(rawValue: ReachabilityManager.reachabilityNotificationName), object: nil)
        self.startWatchingInternet()
    }
    
    private func startWatchingInternet() {
        self.networkReachability = Reachability.forInternetConnection()
        self.networkReachability.startNotifier()
        self.updateInterfaceWithReachability(reachability: self.networkReachability)
    }
    
    private func updateInterfaceWithReachability(reachability: Reachability) {
        
        let netStatus: NetworkStatus = reachability.currentReachabilityStatus()
        let connectionRequired: Bool = reachability.connectionRequired()
        
        var available: Bool = false
        
        if netStatus.rawValue == 0 {
            available = false
        }
        else {
            if connectionRequired {
                available = false
            }
            else {
                available = true
            }
        }
        
        if reachability == self.hostReachability {
            print("host netStatus:\(netStatus)")
            print("host connectionRequired:\(connectionRequired)")
            self.pushEventToListeners(isAvailable: available, isHost: true)
        } else if reachability == self.networkReachability {
            print("internet netStatus:\(netStatus)")
            print("internet connectionRequired:\(connectionRequired)")
            self.pushEventToListeners(isAvailable: available, isHost: false)
        }
    }
    
    private func pushEventToListeners(isAvailable: Bool, isHost: Bool) {
        for index in self.listeners {
            if let observer = index as? ReachabilityManagerDelegate {
                if isAvailable {
                    if isHost {
                        observer.hostAvailable()
                    }
                    else {
                        observer.networkAvailable()
                    }
                }
                else {
                    if isHost {
                        observer.hostUnavailable()
                    }
                    else {
                        observer.networkUnavailable()
                    }
                }
                
            }
        }
    }
    
    
    //MARK: Reachability Event Handler
    func reachabilityChangedAction(notification: Notification) {
        if let currentReach = notification.object as? Reachability {
            self.updateInterfaceWithReachability(reachability: currentReach)
        }
    }
    
    
}
