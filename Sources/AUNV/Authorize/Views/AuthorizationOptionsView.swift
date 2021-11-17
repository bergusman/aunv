//
//  AuthorizationOptionsView.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class AuthorizationOptionsView: UIView {
    @IBOutlet weak var badgeView: AuthorizationOptionView!
    @IBOutlet weak var soundView: AuthorizationOptionView!
    @IBOutlet weak var alertView: AuthorizationOptionView!
    @IBOutlet weak var carPlayView: AuthorizationOptionView!
    @IBOutlet weak var criticalAlertView: AuthorizationOptionView!
    @IBOutlet weak var providesAppNotificationSettingsView: AuthorizationOptionView!
    @IBOutlet weak var provisionalView: AuthorizationOptionView!
    @IBOutlet weak var announcementView: AuthorizationOptionView!
    @IBOutlet weak var timeSensitiveView: AuthorizationOptionView!
    
    var options: UNAuthorizationOptions {
        var options: UNAuthorizationOptions = []
        if badgeView.switcher.isOn { options.insert(.badge) }
        if soundView.switcher.isOn { options.insert(.sound) }
        if alertView.switcher.isOn { options.insert(.alert) }
        if carPlayView.switcher.isOn { options.insert(.carPlay) }
        if #available(iOS 12.0, *) {
            if criticalAlertView.switcher.isOn { options.insert(.criticalAlert) }
            if providesAppNotificationSettingsView.switcher.isOn { options.insert(.providesAppNotificationSettings) }
            if provisionalView.switcher.isOn { options.insert(.provisional) }
        }
        if #available(iOS 13.0, *) {
            if announcementView.switcher.isOn { options.insert(.announcement) }
        }
        if #available(iOS 15.0, *) {
            if timeSensitiveView.switcher.isOn { options.insert(.timeSensitive) }
        }
        return options
    }
    
    func fill(by settings: UNNotificationSettings) {
        badgeView.switcher.isOn = settings.badgeSetting == .enabled
        soundView.switcher.isOn = settings.soundSetting == .enabled
        alertView.switcher.isOn = settings.alertSetting == .enabled
        carPlayView.switcher.isOn = settings.carPlaySetting == .enabled
        if #available(iOS 12.0, *) {
            criticalAlertView.switcher.isOn = settings.criticalAlertSetting == .enabled
            providesAppNotificationSettingsView.switcher.isOn = settings.providesAppNotificationSettings
            provisionalView.switcher.isOn = settings.authorizationStatus == .provisional
        }
        if #available(iOS 13.0, *) {
            announcementView.switcher.isOn  = settings.announcementSetting == .enabled
        }
        if #available(iOS 15.0, *) {
            timeSensitiveView.switcher.isOn  = settings.timeSensitiveSetting == .enabled
        }
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 28
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        
        if #available(iOS 12.0, *) {
            // Nothing
        } else {
            criticalAlertView.isHidden = true
            providesAppNotificationSettingsView.isHidden = true
            provisionalView.isHidden = true
        }
        if #available(iOS 13.0, *) {
            // Nothing
        } else {
            announcementView.isHidden = true
        }
        if #available(iOS 15.0, *) {
            // Nothing
        } else {
            timeSensitiveView.isHidden = true
        }
    }
}
