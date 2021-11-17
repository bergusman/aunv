//
//  SettingsViewController.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    var settings: UNNotificationSettings?
    var authorizeHandler: (() -> Void)?
    
    private func setupScrollView() {
        scrollView.contentInset.bottom = 25 + 56
        if #available(iOS 11.1, *) {
            scrollView.verticalScrollIndicatorInsets.bottom = 25 + 56
        } else {
            scrollView.scrollIndicatorInsets.bottom = 25 + 56
        }
    }
    
    private func getSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
                self.fill(by: settings)
            }
        }
    }
    
    private func tryFill() {
        if let settings = settings {
            fill(by: settings)
        }
    }
    
    private func fill(by settings: UNNotificationSettings) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        func add(title: String, value: String) {
            let fieldView = SettingView.fromNib()
            fieldView.titleLabel.text = title
            fieldView.valueLabel.text = value
            stackView.addArrangedSubview(fieldView)
        }
        
        func add(title: String, setting: UNNotificationSetting) {
            switch setting {
            case .notSupported: add(title: title, value: "Not Supported")
            case .disabled: add(title: title, value: "Disabled")
            case .enabled: add(title: title, value: "Enabled")
            @unknown default: add(title: title, value: "Unknown\(setting.rawValue)")
            }
        }
        
        switch settings.authorizationStatus {
        case .notDetermined: add(title: "Authorization Status", value: "Not Determined")
        case .denied: add(title: "Authorization Status", value: "Denied")
        case .authorized: add(title: "Authorization Status", value: "Authorized")
        case .provisional: add(title: "Authorization Status", value: "Provisional")
        case .ephemeral: add(title: "Authorization Status", value: "Ephemeral")
        @unknown default: add(title: "Authorization Status", value: "Unknown(\(settings.authorizationStatus.rawValue)")
        }
        
        add(title: "Sound", setting: settings.soundSetting)
        add(title: "Badge", setting: settings.badgeSetting)
        add(title: "Alert", setting: settings.alertSetting)
        add(title: "Notification Center", setting: settings.notificationCenterSetting)
        add(title: "Lock Screen", setting: settings.lockScreenSetting)
        add(title: "Car Play", setting: settings.carPlaySetting)
        
        switch settings.alertStyle {
        case .none: add(title: "Alert Style", value: "None")
        case .banner: add(title: "Alert Style", value: "Banner")
        case .alert: add(title: "Alert Style", value: "Alert")
        @unknown default: add(title: "Alert Style", value: "Unknown(\(settings.alertStyle.rawValue)")
        }

        if #available(iOS 11.0, *) {
            switch settings.showPreviewsSetting {
            case .always: add(title: "Show Previews", value: "Always")
            case .whenAuthenticated: add(title: "Show Previews", value: "When Authenticated")
            case .never: add(title: "Show Previews", value: "Never")
            @unknown default: add(title: "Show Previews", value: "Unknown(\(settings.showPreviewsSetting.rawValue)")
            }
        }

        if #available(iOS 12.0, *) {
            add(title: "Critical Alert", setting: settings.criticalAlertSetting)
            add(title: "Provides App Notification Settings", value: settings.providesAppNotificationSettings ? "Yes" : "No")
        }
        if #available(iOS 13.0, *) {
            add(title: "Announcement", setting: settings.announcementSetting)
        }
        if #available(iOS 15.0, *) {
            add(title: "Time Sensitive", setting: settings.timeSensitiveSetting)
            add(title: "Scheduled Delivery", setting: settings.scheduledDeliverySetting)
            add(title: "Direct Messages", setting: settings.directMessagesSetting)
        }
    }
    
    @IBAction func authorizeTouchUpInside(_ sender: Any) {
        let authorizeVC = AuthorizeViewController()
        authorizeVC.settings = settings
        authorizeVC.authorizeHandler = { [weak self] in
            guard let self = self else { return }
            self.getSettings()
            self.authorizeHandler?()
        }
        authorizeVC.modalPresentationStyle = .fullScreen
        present(authorizeVC, animated: true)
    }
    
    // MARK: - Navigation
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        tryFill()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSettings()
    }
    
    init() {
        super.init(nibName: "SettingsViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
