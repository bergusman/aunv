//
//  BannerView.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class BannerView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func fill(by content: UNNotificationContent) {
        if !content.title.isEmpty {
            titleLabel.text = content.title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
        if !content.subtitle.isEmpty {
            subtitleLabel.text = content.subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
        if !content.body.isEmpty {
            bodyLabel.text = content.body
            bodyLabel.isHidden = false
        } else {
            bodyLabel.isHidden = true
        }
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 18
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
}
