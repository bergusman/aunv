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
    
    class func height(for content: UNNotificationContent, width: CGFloat) -> CGFloat {
        let w = width - 30
        var h: CGFloat = 0
        
        if !content.title.isEmpty {
            h += NSAttributedString(string: content.title, attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ]).boundingRect(with: .init(width: w, height: 1000), options: .usesLineFragmentOrigin, context: nil).height
        }
        if !content.subtitle.isEmpty {
            h += h > 0 ? 3 : 0
            h += NSAttributedString(string: content.subtitle, attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ]).boundingRect(with: .init(width: w, height: 1000), options: .usesLineFragmentOrigin, context: nil).height
        }
        if !content.body.isEmpty {
            h += h > 0 ? 3 : 0
            h += NSAttributedString(string: content.body, attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]).boundingRect(with: .init(width: w, height: 1000), options: .usesLineFragmentOrigin, context: nil).height
        }
        
        return 10 + h + 10
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
