//
//  PendingCell.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class PendingCell: HighlightingScaledCell {
    @IBOutlet weak var bannerView: BannerView!
    @IBOutlet weak var triggerView: TriggerView!
    @IBOutlet weak var identifierLabel: UILabel!
    
    func fill(by pending: UNNotificationRequest) {
        identifierLabel.text = pending.identifier
        
        let content = pending.content
        if !(content.title.isEmpty && content.subtitle.isEmpty && content.body.isEmpty) {
            bannerView.fill(by: content)
            bannerView.isHidden = false
        } else {
            bannerView.isHidden = true
        }
        
        if let trigger = pending.trigger {
            triggerView.fill(by: trigger)
            triggerView.isHidden = false
        } else {
            triggerView.isHidden = true
        }
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
