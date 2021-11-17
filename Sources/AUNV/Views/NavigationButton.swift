//
//  NavigationButton.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit

class NavigationButton: UIControl {
    
    // MARK: - UIControl
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                if isHighlighted {
                    UIViewPropertyAnimator(duration: 0.15, curve: .easeOut, animations: {
                        self.transform = .init(scaleX: 0.92, y: 0.92)
                    }).startAnimation()
                } else {
                    UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                        self.transform = .identity
                    }).startAnimation()
                }
            }
        }
    }
    
    // MARK: - UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.05
    }
}
