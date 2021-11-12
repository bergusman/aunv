//
//  Toolbar.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit

class Toolbar: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 11.0, *) {
            layer.cornerRadius = 44
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            if #available(iOS 13.0, *) {
                layer.cornerCurve = .continuous
            }
        }
    }
}
