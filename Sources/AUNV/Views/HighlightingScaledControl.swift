//
//  HighlightingScaledControl.swift
//  
//
//  Created by Vitaly Berg on 11/18/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit

class HighlightingScaledControl: UIControl {
    @IBInspectable var highlightingScale: CGFloat = 0.92
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted != oldValue {
                if isHighlighted {
                    UIViewPropertyAnimator(duration: 0.15, curve: .easeOut, animations: {
                        self.transform = .init(scaleX: self.highlightingScale, y: self.highlightingScale)
                    }).startAnimation()
                } else {
                    UIViewPropertyAnimator(duration: 0.3, curve: .easeOut, animations: {
                        self.transform = .identity
                    }).startAnimation()
                }
            }
        }
    }
}
