//
//  NotificationCell.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationCell: HighlightingScaledCell {
    @IBOutlet weak var bannerView: BannerView!
    @IBOutlet weak var triggerView: TriggerView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func fill(by notification: UNNotification) {
        fill(by: notification.request)
    }
    
    func fill(by request: UNNotificationRequest) {
        let content = request.content
        if !(content.title.isEmpty && content.subtitle.isEmpty && content.body.isEmpty) {
            bannerView.fill(by: content)
            bannerView.isHidden = false
        } else {
            bannerView.isHidden = true
        }
        
        if let trigger = request.trigger {
            triggerView.fill(by: trigger)
            triggerView.isHidden = false
        } else {
            triggerView.isHidden = true
        }
        
        detailsLabel.attributedText = Self.attributedDetails(for: request)
    }
    
    class func size(for notification: UNNotification, width: CGFloat) -> CGSize {
        return size(for: notification.request, width: width)
    }
    
    class func size(for request: UNNotificationRequest, width: CGFloat) -> CGSize {
        let w = width - 40
        var h: CGFloat = 0
        
        let content = request.content
        if !(content.title.isEmpty && content.subtitle.isEmpty && content.body.isEmpty) {
            h += BannerView.height(for: content, width: w)
        }
        
        if let trigger = request.trigger {
            h += h > 0 ? 5 : 0
            h += TriggerView.height(for: trigger, width: w)
        }
        
        h += h > 0 ? 5 : 0
        h += attributedDetails(for: request).boundingRect(with: .init(width: w, height: 10000), options: .usesLineFragmentOrigin, context: nil).height
        h += 10 + 5
        
        h += 20 + 20
        return .init(width: width, height: h)
    }
    
    class func attributedDetails(for request: UNNotificationRequest) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let titleFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        let valueFont = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        func appendTitle(_ title: String, indent: String = "") {
            result.append(.init(string: title + ": ", attributes: [
                .font: titleFont
            ]))
        }
        
        func appendValue(_ value: String) {
            result.append(.init(string: value, attributes: [
                .font: valueFont
            ]))
        }
        
        func appendText(_ text: String) {
            result.append(.init(string: text, attributes: [
                .font: titleFont
            ]))
        }
        
        func appendAny(_ any: Any, indent: String = "") {
            switch any {
            case let dictionary as [AnyHashable: Any]:
                appendText(indent + "{\n")
                for (key, value) in dictionary {
                    appendTitle(indent + "  \(key)")
                    appendAny(value, indent: indent + "  ")
                    appendText("\n")
                }
                appendText(indent + "}")
            case let array as [Any]:
                appendText(indent + "[\n")
                for value in array {
                    appendAny(value, indent: indent + "  ")
                    appendText("\n")
                }
                appendText(indent + "]")
            default:
                appendText(indent)
                appendValue("\(any)")
            }
        }
         
        if !request.identifier.isEmpty {
            appendTitle("identifier")
            appendValue("\(request.identifier)\n")
        }
        
        let content = request.content
        if !content.threadIdentifier.isEmpty {
            appendTitle("thread")
            appendValue("\(content.threadIdentifier)\n")
        }
        if !content.categoryIdentifier.isEmpty {
            appendTitle("category")
            appendValue("\(content.categoryIdentifier)\n")
        }
        if !content.launchImageName.isEmpty {
            appendTitle("launch image")
            appendValue("\(content.launchImageName)\n")
        }
        if let badge = content.badge {
            appendTitle("badge")
            appendValue("\(badge)\n")
        }
        if let sound = content.sound {
            appendTitle("sound")
            appendValue("\(sound)\n")
        }
        
        if #available(iOS 13.0, *) {
            if let targetContentIdentifier = content.targetContentIdentifier {
                appendTitle("target content")
                appendValue("\(targetContentIdentifier)\n")
            }
        }
        
        if #available(iOS 12.0, *) {
            if !content.summaryArgument.isEmpty {
                appendTitle("summary argument")
                appendValue("\(content.summaryArgument)\n")
            }
            if content.summaryArgumentCount > 0 {
                appendTitle("summary argument count")
                appendValue("\(content.summaryArgumentCount)\n")
            }
        }
        
        if #available(iOS 15.0, *) {
            appendTitle("interruption level")
            switch content.interruptionLevel {
            case .passive: appendValue("passive\n")
            case .active: appendValue("active\n")
            case .timeSensitive: appendValue("time sensetive\n")
            case .critical: appendValue("critical\n")
            @unknown default: appendValue("unknown(\(content.interruptionLevel.rawValue))\n")
            }
            
            appendTitle("relevance score")
            appendValue("\(content.relevanceScore)\n")
        }
        
        if !content.attachments.isEmpty {
            appendTitle("attachments")
        }
        
        if !content.userInfo.isEmpty {
            appendTitle("user info")
            appendAny(content.userInfo)
            appendText("\n")
        }
        
        return result.attributedSubstring(from: .init(location: 0, length: result.length - 1))
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 34
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
    
    static let nib = UINib(nibName: "NotificationCell", bundle: Bundle.module)
}
