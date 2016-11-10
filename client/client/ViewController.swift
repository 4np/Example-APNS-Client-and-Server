//
//  ViewController.swift
//  client
//
//  Created by Jeroen Wesbeek on 03/11/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire

class ViewController: UIViewController {
    fileprivate var foregroundNotification: NSObjectProtocol?
    fileprivate var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // observe when the application comes to the foreground
        foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) { [weak self] notification in
            // update the notification status when it does as we
            // may have arrived here from changing the app's push
            // notification settings
            self?.refreshNotificationStatus()
        }
        
        // update the notification status
        refreshNotificationStatus()
    }
    
    // MARK: Get notifcation status
    
    private func refreshNotificationStatus() {
        PushNotificationManager.sharedInstance.getAuthorizationStatus { [weak self] (status) in
            // remember status
            self?.authorizationStatus = status
            
            // and update view
            guard let view = self?.view as? FeedbackView else {
                return
            }

            view.configure(withAuthorizationStatus: status)
        }
    }
    
    // MARK: Button
    
    @IBAction func buttonPressed(_ sender: Any) {
        switch authorizationStatus {
        case .authorized, .denied:
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            break
        case .notDetermined:
            self.registerForPushNotifications(application: UIApplication.shared)
            break
        }
    }
    
    // MARK: Request authorization
    
    func registerForPushNotifications(application: UIApplication) {
        PushNotificationManager.sharedInstance.registerForPushNotifications() { [weak self] (granted, error) in
            // fetch status and update UI
            self?.refreshNotificationStatus()
        }
    }
}
