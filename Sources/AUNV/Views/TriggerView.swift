//
//  TriggerView.swift
//
//  Created by Vitaly Berg on 11/18/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class TriggerView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var mapWrapper: UIView!
    @IBOutlet weak var mapView: TriggerMapView!
    
    func fill(by trigger: UNNotificationTrigger) {
        switch trigger {
        case let trigger as UNCalendarNotificationTrigger:
            titleLabel.text = "Calendar"
            fill(date: trigger.nextTriggerDate())
            detailsLabel.attributedText = Self.details(for: trigger)
            mapWrapper.isHidden = true
            
        case let trigger as UNTimeIntervalNotificationTrigger:
            titleLabel.text = "Time Interval"
            fill(date: trigger.nextTriggerDate())
            detailsLabel.attributedText = Self.details(for: trigger)
            mapWrapper.isHidden = true
            
        case let trigger as UNLocationNotificationTrigger:
            titleLabel.text = "Location"
            fill(date: nil)
            detailsLabel.attributedText = Self.details(for: trigger)
            if let region = trigger.region as? CLCircularRegion {
                mapView.region = region
                mapWrapper.isHidden = false
            } else {
                mapWrapper.isHidden = true
            }
            
        case is UNPushNotificationTrigger:
            titleLabel.text = "Push"
            fill(date: nil)
            mapWrapper.isHidden = true
            
        default:
            titleLabel.text = "Trigger"
            fill(date: nil)
            detailsLabel.attributedText = Self.attributedDetails(for: [("repeats", "\(trigger.repeats)")], separator: "")
            mapWrapper.isHidden = true
        }
    }
    
    private func fill(date: Date?) {
        if let date = date {
            dateLabel.text = Self.dateFormatter.string(from: date)
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("YYYY MMM d HH:mm:ss")
        return formatter
    }()
    
    private class func details(for trigger: UNCalendarNotificationTrigger) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(details(for: trigger.dateComponents))
        if result.length > 0 {
            result.append(.init(string: "\n", attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]))
        }
        result.append(attributedDetails(for: [("repeats", "\(trigger.repeats)")], separator: ""))
        return result
    }
    
    private class func details(for trigger: UNTimeIntervalNotificationTrigger) -> NSAttributedString {
        let fields: [(String, String)] = [
            ("time interval", "\(trigger.timeInterval) s"),
            ("repeats", "\(trigger.repeats)")
        ]
        return attributedDetails(for: fields, separator: "\n")
    }
    
    private class func details(for trigger: UNLocationNotificationTrigger) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let region = trigger.region
        
        result.append(attributedDetails(for: [("identifier", region.identifier)], separator: ""))

        result.append(.init(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]))
        result.append(attributedDetails(for: [
            ("notify on entry", "\(region.notifyOnEntry)"),
            ("notify on exit", "\(region.notifyOnExit)")
        ], separator: "; "))
        
        if let region = region as? CLCircularRegion {
            result.append(.init(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]))
            result.append(attributedDetails(for: [
                ("latitude", "\(region.center.latitude)"),
                ("longitude", "\(region.center.longitude)"),
                ("radius", "\(region.radius)")
            ], separator: "; "))
        }
        

        result.append(.init(string: "\n", attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]))
        result.append(attributedDetails(for: [("repeats", "\(trigger.repeats)")], separator: ""))
        return result
    }
    
    private class func details(for components: DateComponents) -> NSAttributedString {
        var fields: [(String, String)] = []
        if let calendar = components.calendar {
            fields.append(("calendar", "\(calendar)"))
        }
        if let timeZone = components.timeZone {
            fields.append(("time zone", "\(timeZone)"))
        }
        if let era = components.era {
            fields.append(("era", "\(era)"))
        }
        if let year = components.year {
            fields.append(("year", "\(year)"))
        }
        if let month = components.month {
            fields.append(("month", "\(month)"))
        }
        if let day = components.day {
            fields.append(("day", "\(day)"))
        }
        if let hour = components.hour {
            fields.append(("hour", "\(hour)"))
        }
        if let minute = components.minute {
            fields.append(("minute", "\(minute)"))
        }
        if let second = components.second {
            fields.append(("second", "\(second)"))
        }
        if let nanosecond = components.nanosecond {
            fields.append(("nanosecond", "\(nanosecond)"))
        }
        if let weekday = components.weekday {
            fields.append(("weekday", "\(weekday)"))
        }
        if let weekdayOrdinal = components.weekdayOrdinal {
            fields.append(("weekday ordinal", "\(weekdayOrdinal)"))
        }
        if let quarter = components.quarter {
            fields.append(("quarter", "\(quarter)"))
        }
        if let weekOfMonth = components.weekOfMonth {
            fields.append(("week of month", "\(weekOfMonth)"))
        }
        if let weekOfYear = components.weekOfYear {
            fields.append(("week of year", "\(weekOfYear)"))
        }
        if let yearForWeekOfYear = components.yearForWeekOfYear {
            fields.append(("year for week of year", "\(yearForWeekOfYear)"))
        }
        if let isLeapMonth = components.isLeapMonth {
            fields.append(("is leap month", "\(isLeapMonth)"))
        }
        
        return attributedDetails(for: fields, separator: "; ")
    }
    
    private class func attributedDetails(for fields: [(title: String, value: String)], separator: String) -> NSAttributedString {
        let titleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        let valueFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let result = NSMutableAttributedString()
        for (i, field) in fields.enumerated() {
            var title = field.title
            title = title.replacingOccurrences(of: " ", with: "\u{A0}")
            title += ":\u{A0}"
            
            result.append(.init(string: title, attributes: [
                .font: titleFont
            ]))
            
            result.append(.init(string: field.value, attributes: [
                .font: valueFont
            ]))
            
            if i < fields.count - 1 {
                result.append(.init(string: separator, attributes: [
                    .font: titleFont
                ]))
            }
        }
        
        return result
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
