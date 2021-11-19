//
//  DeliveredsViewController.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class DeliveredsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var delivereds: [UNNotification]!
    
    private func getDelivereds() {
        UNUserNotificationCenter.current().getDeliveredNotifications { delivereds in
            DispatchQueue.main.async {
                self.delivereds = delivereds
                self.collectionView.reloadData()
            }
        }
    }
    
    private func removeDelivered(at indexPath: IndexPath) {
        let delivered = delivereds[indexPath.item]
        delivereds.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [delivered.request.identifier])
    }
    
    // MARK: - UICollectionView
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupCollectionView() {
        collectionView.register(NotificationCell.nib, forCellWithReuseIdentifier: "notification")
        collectionView.contentInset.bottom = 50
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let delivereds = delivereds {
            return delivereds.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "notification", for: indexPath) as! NotificationCell
        cell.fill(by: delivereds[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let alertVC = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Remove", style: .destructive, handler: { _ in
            self.removeDelivered(at: indexPath)
        }))
        alertVC.addAction(.init(title: "Cancel", style: .cancel))
        present(alertVC, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w = collectionView.bounds.width - 20
        if #available(iOS 11.0, *) {
             w -= view.safeAreaInsets.left + view.safeAreaInsets.right
        }
        return NotificationCell.size(for: delivereds[indexPath.item], width: w)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var oy = scrollView.contentOffset.y
        if #available(iOS 11.0, *) {
            oy += scrollView.adjustedContentInset.top
        }
        titleLabel.transform.ty = -oy
    }
    
    // MARK: - Navigation
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backTouchUpInside(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeTouchUpInside(_ sender: Any) {
        let alertVC = UIAlertController(title: "Remove all delivered notifications?", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Remove All", style: .destructive, handler: { _ in
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }))
        alertVC.addAction(.init(title: "Cancel", style: .cancel))
        present(alertVC, animated: true)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDelivereds()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset.top = 88 + titleLabel.bounds.height + 50
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    init() {
        super.init(nibName: "DeliveredsViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
