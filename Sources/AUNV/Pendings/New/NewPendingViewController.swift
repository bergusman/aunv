//
//  NewPendingViewController.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class NewPendingViewController: UIViewController {
    var addHandler: (() -> Void)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var toastView: ToastView!
    
    private let keyboardObserver = KeyboardObserver(enabled: false)
    
    private func setup() {
        scrollView.contentInset.bottom = 25 + 56
        if #available(iOS 11.1, *) {
            scrollView.verticalScrollIndicatorInsets.bottom = 25 + 56
        } else {
            scrollView.scrollIndicatorInsets.bottom = 25 + 56
        }
        
        keyboardObserver.willShow = { _ in
            
        }
        keyboardObserver.willHide = { _ in
            
        }
    }
    
    @IBAction func addTouchUpInside(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "iTech"
        content.subtitle = "Subtitle"
        content.body = "Body"
        content.sound = .default
        if #available(iOS 13.0, *) {
            content.targetContentIdentifier = "target"
        }
        content.categoryIdentifier = "MyCategory"
        content.userInfo = [
            "bingo": "bongo",
            "lol": 8,
            "kek": [
                "shmek": "huyek",
                "abra": "kadabra"
            ],
            "array": [
                ["abra": "kadabra"],
                "bingo"
            ]
        ]
    
        //let date = Date(timeIntervalSinceNow: 600)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: true)
        
        let region = CLCircularRegion(center: .init(latitude: -8.688806, longitude: 115.171251), radius: 200, identifier: "iTech")
        region.notifyOnExit = true
        region.notifyOnEntry = true
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 600, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                self.addHandler?()
                if let error = error {
                    self.toastView.showFailure("Request Not Added\n\(error)")
                } else {
                    self.toastView.showSuccess("Request Added")
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
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboardObserver.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardObserver.isEnabled = false
    }
    
    init() {
        super.init(nibName: "NewPendingViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
