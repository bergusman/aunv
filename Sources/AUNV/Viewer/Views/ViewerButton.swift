//
//  ViewerButton.swift
//
//  Created by Vitaly Berg on 11/13/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit

class ViewerButton: HighlightingScaledControl {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
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
