//
//  PendingsViewController.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class PendingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var pendings: [UNNotificationRequest]!
    var addHandler: (() -> Void)?
    
    private func getPendings() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { pendings in
            DispatchQueue.main.async {
                self.pendings = pendings
                self.collectionView.reloadData()
            }
        }
    }
    
    private func removePending(at indexPath: IndexPath) {
        let pending = pendings[indexPath.item]
        pendings.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [pending.identifier])
    }
    
    // MARK: - UICollectionView
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupCollectionView() {
        collectionView.register(PendingCell.nib, forCellWithReuseIdentifier: "pending")
        collectionView.contentInset.bottom = 10 + 54 + 10
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let pendings = pendings {
            return pendings.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pending", for: indexPath) as! PendingCell
        let pending = pendings[indexPath.item]
        cell.fill(by: pending)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let alertVC = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Remove", style: .destructive, handler: { _ in
            self.removePending(at: indexPath)
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
        return .init(width: w, height: 400)
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
    
    @IBAction func addTouchUpInside(_ sender: Any) {
        let newVC = NewPendingViewController()
        newVC.addHandler = {
            self.addHandler?()
            self.getPendings()
        }
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPendings()
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
        super.init(nibName: "PendingsViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
