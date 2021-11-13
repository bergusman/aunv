//
//  ViewerViewController.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit
import UserNotifications

class ViewerViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var settingsButton: ViewerButton!
    @IBOutlet weak var categoriesButton: ViewerButton!
    @IBOutlet weak var pendingsButton: ViewerButton!
    @IBOutlet weak var deliveredsButton: ViewerButton!
    
    private func setupScrollView() {
        scrollView.contentInset.bottom = 50
    }
    
    private var settings: UNNotificationSettings!
    private var categories: Set<UNNotificationCategory>!
    private var pendings: [UNNotificationRequest]!
    private var delivereds: [UNNotification]!
    
    private func get() {
        getSettings()
        getCategories()
        getPendings()
        getDelivereds()
    }
    
    private func getSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.settings = settings
                switch settings.authorizationStatus {
                case .notDetermined: self.settingsButton.detailsLabel.text = "Not Determined"
                case .denied: self.settingsButton.detailsLabel.text = "Denied"
                case .authorized: self.settingsButton.detailsLabel.text = "Authorized"
                case .provisional: self.settingsButton.detailsLabel.text = "Provisional"
                case .ephemeral: self.settingsButton.detailsLabel.text = "Ephemeral"
                @unknown default: self.settingsButton.detailsLabel.text = "Unknown(\(settings.authorizationStatus.rawValue))"
                }
            }
        }
    }
    
    private func getCategories() {
        UNUserNotificationCenter.current().getNotificationCategories { categories in
            DispatchQueue.main.async {
                self.categories = categories
                if categories.isEmpty {
                    self.categoriesButton.detailsLabel.text = "No categories"
                } else if categories.count == 1 {
                    self.categoriesButton.detailsLabel.text = "1 category"
                } else {
                    self.categoriesButton.detailsLabel.text = "\(categories.count) categories"
                }
            }
        }
    }
    
    private func getPendings() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { pendings in
            DispatchQueue.main.async {
                self.pendings = pendings
                if pendings.isEmpty {
                    self.pendingsButton.detailsLabel.text = "No requests"
                } else if pendings.count == 1 {
                    self.pendingsButton.detailsLabel.text = "1 request"
                } else {
                    self.pendingsButton.detailsLabel.text = "\(pendings.count) requests"
                }
            }
        }
    }
    
    private func getDelivereds() {
        UNUserNotificationCenter.current().getDeliveredNotifications { delivereds in
            DispatchQueue.main.async {
                self.delivereds = delivereds
                if delivereds.isEmpty {
                    self.deliveredsButton.detailsLabel.text = "No notifications"
                } else if delivereds.count == 1 {
                    self.deliveredsButton.detailsLabel.text = "1 notification"
                } else {
                    self.deliveredsButton.detailsLabel.text = "\(delivereds.count) notifications"
                }
            }
        }
    }
    
    @IBAction func settingsTouchUpInside(_ sender: Any) {
        let settingsVC = SettingsViewController()
        settingsVC.settings = settings
        settingsVC.authorizeHandler = {
            self.getSettings()
        }
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func categoriesTouchUpInside(_ sender: Any) {
        let categoriesVC = CategoriesViewController()
        categoriesVC.categories = Array(categories ?? [])
        navigationController?.pushViewController(categoriesVC, animated: true)
    }
    
    @IBAction func pendingsTouchUpInside(_ sender: Any) {
        let pendingsVC = PendingsViewController()
        pendingsVC.pendings = pendings
        pendingsVC.addHandler = {
            self.getPendings()
        }
        navigationController?.pushViewController(pendingsVC, animated: true)
    }
    
    @IBAction func deliveredsTouchUpInside(_ sender: Any) {
        let deliveredsVC = DeliveredsViewController()
        deliveredsVC.delivereds = delivereds
        navigationController?.pushViewController(deliveredsVC, animated: true)
    }
    
    // MARK: - Navigation
    
    @IBAction func dismissTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        get()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        get()
    }
    
    init() {
        super.init(nibName: "ViewerViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
