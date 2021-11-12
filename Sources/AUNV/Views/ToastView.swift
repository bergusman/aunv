//
//  ToastView.swift
//  
//
//  Created by Vitaly Berg on 11/13/21.
//

import UIKit

class ToastView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    func showSuccess(_ title: String) {
        titleLabel.text = title
        backgroundColor = #colorLiteral(red: 0.7843137255, green: 1, blue: 0.3215686275, alpha: 1)
        show()
    }
    
    func showFailure(_ title: String) {
        titleLabel.text = title
        backgroundColor = #colorLiteral(red: 1, green: 0.3843137255, blue: 0.03921568627, alpha: 1)
        show()
    }
    
    private var hidingTimer: Timer?

    func show() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        hidingTimer?.invalidate()
        hidingTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
            self?.hide()
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
    }
}
