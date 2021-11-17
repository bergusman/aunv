//
//  NewPendingViewController.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class NewPendingViewController: UIViewController {
    var addHandler: (() -> Void)?
    
    @IBOutlet weak var toastView: ToastView!
    
    @IBAction func addTouchUpInside(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body"
    
        let date = Date(timeIntervalSinceNow: 6)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date), repeats: false)
        
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
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: "NewPendingViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
