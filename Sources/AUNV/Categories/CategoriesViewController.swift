//
//  CategoriesViewController.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var categories: [UNNotificationCategory]!
    
    private func getCategories() {
        UNUserNotificationCenter.current().getNotificationCategories { categories in
            DispatchQueue.main.async {
                self.categories = Array(categories)
                self.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func addTouchUpInside(_ sender: Any) {
    }
    
    // MARK: - UICollectionView
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupCollectionView() {
        collectionView.register(CategoryCell.nib, forCellWithReuseIdentifier: "category")
        collectionView.contentInset.bottom = 10 + 54 + 10
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categories = categories {
            return categories.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryCell
        cell.fill(by: categories[indexPath.item])
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
        getCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset.top = 88 + titleLabel.bounds.height + 50
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    public init() {
        super.init(nibName: "CategoriesViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
