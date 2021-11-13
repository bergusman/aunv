//
//  ViewerButton.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit

class ViewerButton: UIControl {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 28
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        detailsLabel.text = nil
    }
}
