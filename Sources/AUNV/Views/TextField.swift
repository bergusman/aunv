//
//  TextField.swift
//
//  Created by Vitaly Berg on 11/19/21.
//  Copyright © 2021 Vitaly Berg. All rights reserved.
//

import UIKit

class TextField: UIControl, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var text: String {
        get {
            return textField.text ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    
    var returnHandler: (() -> Void)?
    var backwardHandler: (() -> Void)?
    
    @IBOutlet var nextControl: UIControl?
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextControl?.becomeFirstResponder()
        returnHandler?()
        return true
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
