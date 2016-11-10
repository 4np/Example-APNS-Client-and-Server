//
//  PushNotificationManager.swift
//  client
//
//  Created by Jeroen Wesbeek on 07/11/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Alamofire
import AdSupport

class PushNotificationManager {
    let endpoint = "https://your.hostname.com/devices"
    public static let sharedInstance = PushNotificationManager()
    private let center = UNUserNotificationCenter.current()
    private var application: UIApplication?
    private var token: String?
    private var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    fileprivate func getVendorUUID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    fileprivate func getAdvertisingUUID() -> String? {
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    final public func setDelegate(delegate: UNUserNotificationCenterDelegate, andApplication application: UIApplication) {
        center.delegate = delegate
        self.application = application
    }

    final public func registerForPushNotifications(completionHandler: @escaping (Bool, Error?) -> ()) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, error) in
            if granted {
                self?.application?.registerForRemoteNotifications()
            }

            DispatchQueue.main.async {
                completionHandler(granted, error)
            }
        }
    }
    
    final public func getAuthorizationStatus(completionHandler: @escaping (UNAuthorizationStatus) -> ()) {
        center.getNotificationSettings() { [weak self] settings in
            DispatchQueue.main.async {
                // check if the status changed to enabled
                if self?.authorizationStatus == .denied && settings.authorizationStatus == .authorized {
                    self?.updateDevice(enabled: true)
                } else if self?.authorizationStatus == .authorized && settings.authorizationStatus == .denied {
                    self?.updateDevice(enabled: false)
                }
                
                // store the new authorization status
                self?.authorizationStatus = settings.authorizationStatus
                completionHandler(settings.authorizationStatus)
            }
        }
    }
    
    final public func registerDevice(token: String) {
        self.token = token
        
        let parameters: Parameters = [
            "name": UIDevice.current.name,
            "model": UIDevice.current.model,
            "systemName": UIDevice.current.systemName,
            "systemVersion": UIDevice.current.systemVersion,
            "token": token,
            "vendorUUID": self.getVendorUUID() ?? "",
            "advertisingUUID": self.getAdvertisingUUID() ?? "",
            "identifier": Bundle.main.bundleIdentifier ?? "unknown",
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "unknown",
            "build": Bundle.main.infoDictionary?["CFBundleVersion"] ?? "unknown",
            "enabled": true,
            "sandbox": _isDebugAssertConfiguration()
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(_):
                debugPrint("registered device token")
                break
            case .failure(let error):
                debugPrint("could not register device token (\(error.localizedDescription))")
                break
            }
        }
    }
    
    fileprivate func updateDevice(enabled: Bool) {
        let parameters: Parameters = [
            "vendorUUID": self.getVendorUUID() ?? "",
            "advertisingUUID": self.getAdvertisingUUID() ?? "",
            "enabled": enabled,
            "sandbox": _isDebugAssertConfiguration()
        ]
        
        // We should really use PATCH here, but as we do not store or
        // know the device id we will use POST instead to update by
        // token or uuid.
        Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(_):
                debugPrint("updated device")
                break
            case .failure(let error):
                debugPrint("could not update device (\(error.localizedDescription))")
                break
            }
        }
    }
}
