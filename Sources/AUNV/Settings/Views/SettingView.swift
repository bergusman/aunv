//
//  SettingView.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit

class SettingView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    class func fromNib() -> Self {
        UINib(nibName: "SettingView", bundle: Bundle.module).instantiate(withOwner: nil, options: nil).first as! Self
    }
}
