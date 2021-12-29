//
//  NavigationButton.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit

class NavigationButton: HighlightingScaledControl {
    
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
