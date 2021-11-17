//
//  AuthorizeViewController.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class AuthorizeViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var optionsView: AuthorizationOptionsView!
    @IBOutlet weak var toastView: ToastView!
    
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
    
    private func fill() {
        if let settings = settings {
            optionsView.fill(by: settings)
        }
    }
    
    @IBAction func authorizeTouchUpInside(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: optionsView.options) { granted, error in
            DispatchQueue.main.async {
                self.authorizeHandler?()
                if granted {
                    self.toastView.showSuccess("Authorization Granted")
                } else {
                    if let error = error {
                        self.toastView.showFailure("Authorization Not Granted\n\(error)")
                    } else {
                        self.toastView.showFailure("Authorization Not Granted")
                    }
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func dismissTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        fill()
    }
    
    // MARK: - UIViewController
    
    init() {
        super.init(nibName: "AuthorizeViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
