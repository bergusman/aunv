//
//  DeliveredCell.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit
import UserNotifications

class DeliveredCell: UICollectionViewCell {
    
    func fill(by delivered: UNNotification) {
        
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 34
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
    
    static let nib = UINib(nibName: "DeliveredCell", bundle: Bundle.module)
}
