//
//  CategoryCell.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit
import UserNotifications

class CategoryCell: UICollectionViewCell {
    
    func fill(by category: UNNotificationCategory) {
        
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 34
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
    
    static let nib = UINib(nibName: "CategoryCell", bundle: Bundle.module)
}
