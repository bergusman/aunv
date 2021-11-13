//
//  DeliveredsViewController.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
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
    
    // MARK: - UICollectionView
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupCollectionView() {
        collectionView.register(DeliveredCell.nib, forCellWithReuseIdentifier: "delivered")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "delivered", for: indexPath) as! DeliveredCell
        cell.fill(by: delivereds[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w = collectionView.bounds.width - 20
        if #available(iOS 11.0, *) {
             w -= view.safeAreaInsets.left + view.safeAreaInsets.right
        }
        return .init(width: w, height: 200)
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
