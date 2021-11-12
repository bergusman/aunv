//
//  AuthorizationOptionView.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit

class AuthorizationOptionView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 56)
    }
}
