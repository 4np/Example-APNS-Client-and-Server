//
//  FeedbackView.swift
//  client
//
//  Created by Jeroen Wesbeek on 07/11/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import UserNotifications

class FeedbackView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    private var authorizationStatus: UNAuthorizationStatus = .notDetermined {
        didSet {
            layout()
        }
    }

    private func layout() {
        // background color will represent authorization status
        switch authorizationStatus {
        case .authorized:
            backgroundColor = UIColor.green
            titleLabel.text = "Notifications are enabled"
            button.setTitle("Change settings", for: .normal)
            break
        case .denied:
            backgroundColor = UIColor.red
            titleLabel.text = "Notifications are disabled"
            button.setTitle("Change settings", for: .normal)
            break
        case .notDetermined:
            backgroundColor = UIColor.orange
            titleLabel.text = "Undetermined wheter notifications are enabled or not"
            button.setTitle("Request", for: .normal)
            break
        }
    }
    
    public func configure(withAuthorizationStatus authorizationStatus: UNAuthorizationStatus) {
        self.authorizationStatus = authorizationStatus
    }
}
