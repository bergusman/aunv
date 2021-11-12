//
//  ViewerViewController.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit
import UserNotifications

public class ViewerViewController: UIViewController {
    
    private var settings: UNNotificationSettings!
    private var categories: [UNNotificationCategory]!
    private var pendings: [UNNotificationRequest]!
    private var delivereds: [UNNotification]!
    
    private func get() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
            }
        }
        center.getNotificationCategories { categories in
            DispatchQueue.main.async {
                self.categories = categories
            }
        }
        center.getPendingNotificationRequests { pendings in
            DispatchQueue.main.async {
                self.pendings = pendings
            }
        }
        center.getDeliveredNotifications { delivereds in
            DispatchQueue.main.async {
                self.delivereds = delivereds
            }
        }
    }
    
    @IBAction func settingsTouchUpInside(_ sender: Any) {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func categoriesTouchUpInside(_ sender: Any) {
        let categoriesVC = CategoriesViewController()
        navigationController?.pushViewController(categoriesVC, animated: true)
    }
    
    @IBAction func pendingsTouchUpInside(_ sender: Any) {
        let pendingsVC = PendingsViewController()
        navigationController?.pushViewController(pendingsVC, animated: true)
    }
    
    @IBAction func deliveredsTouchUpInside(_ sender: Any) {
        let deliveredsVC = DeliveredsViewController()
        navigationController?.pushViewController(deliveredsVC, animated: true)
    }
    
    // MARK: - UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        get()
    }
    
    public init() {
        super.init(nibName: "ViewerViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
