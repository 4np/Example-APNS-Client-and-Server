//
//  FeedbackView.swift
//  client
//
//  Created by Jeroen Wesbeek on 07/11/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import UserNotifications
import UIColor_Hex_Swift

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
            backgroundColor = UIColor("#76bd22") // green
            titleLabel.text = "Notifications are enabled"
            button.setTitle("Change settings", for: .normal)
            break
        case .denied:
            backgroundColor = UIColor("#ff681d") // orangy red
            titleLabel.text = "Notifications are disabled"
            button.setTitle("Change settings", for: .normal)
            break
        case .notDetermined:
            backgroundColor = UIColor("#ffc72a") // yellow
            titleLabel.text = "Undetermined whether notifications are enabled or not"
            button.setTitle("Request", for: .normal)
            break
        }
    }
    
    public func configure(withAuthorizationStatus authorizationStatus: UNAuthorizationStatus) {
        self.authorizationStatus = authorizationStatus
    }
}
