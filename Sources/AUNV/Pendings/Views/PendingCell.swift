//
//  PendingCell.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class PendingCell: UICollectionViewCell {
    @IBOutlet weak var identifierLabel: UILabel!
    
    func fill(by pending: UNNotificationRequest) {
        identifierLabel.text = pending.identifier
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 34
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
    
    static let nib = UINib(nibName: "PendingCell", bundle: Bundle.module)
}
