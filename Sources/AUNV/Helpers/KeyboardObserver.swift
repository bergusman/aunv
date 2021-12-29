//
//  KeyboardObserver.swift
//
//  Created by Vitaly Berg on 6/10/20.
//  Copyright © 2020 Vitaly Berg. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let keyboardStateChanged = Notification.Name("KeyboardStateChanged")
}

class KeyboardObserver {
    class var keyboardHeight: CGFloat {
        let h = UIScreen.main.bounds.height
        if h <= 667 {
            return 216
        } else if h <= 736 {
            return 226
        } else if h <= 844 {
            return 291
        } else {
            return 301
        }
    }
    
    class var suggestionsHeight: CGFloat {
        let h = UIScreen.main.bounds.height
        if h <= 568 {
            return 38
        } else if h <= 667 {
            return 44
        } else {
            return 45
        }
    }
    
    class var keyboardAndSuggestionsHeight: CGFloat {
        return keyboardHeight + suggestionsHeight
    }
    
    var isEnabled = true
    
    init(enabled: Bool = true) {
        isEnabled = enabled
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    // MARK: - State
    
    enum State {
        case willShow(UserInfo)
        case didShow(UserInfo)
        case willHide(UserInfo)
        case didHide(UserInfo)
    }
    
    private(set) var state: State?
    private(set) var frame: CGRect?

    // MARK: - Handlers
    
    struct UserInfo {
        let frameBegin: CGRect
        let frameEnd: CGRect
        let animationDuration: TimeInterval
        let animationOptions: UIView.AnimationOptions
    }
    
    typealias Handler = (UserInfo) -> Void
    
    var willShow: Handler?
    var didShow: Handler?
    var willHide: Handler?
    var didHide: Handler?
    var willChangeFrame: Handler?
    var didChangeFrame: Handler?
    
    // MARK: - Notifications
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = UserInfo(notification.userInfo) else { return }
        state = .willShow(userInfo)
        guard isEnabled else { return }
        willShow?(userInfo)
    }
    
    @objc private func keyboardDidShow(notification: Notification) {
        guard let userInfo = UserInfo(notification.userInfo) else { return }
        state = .didShow(userInfo)
        guard isEnabled else { return }
        didShow?(userInfo)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = UserInfo(notification.userInfo) else { return }
        state = .willHide(userInfo)
        guard isEnabled else { return }
        willHide?(userInfo)
    }
    
    @objc private func keyboardDidHide(notification: Notification) {
        guard let userInfo = UserInfo(notification.userInfo) else { return }
        state = .didHide(userInfo)
        guard isEnabled else { return }
        didHide?(userInfo)
    }
    
    @objc private func keyboardWillChangeFrame(notification: Notification) {
        guard let userInfo = UserInfo(notification.userInfo) else { return }
        frame = userInfo.frameEnd
        guard isEnabled else { return }
        willChangeFrame?(userInfo)
    }
    
    @objc private func keyboardDidChangeFrame(notification: Notification) {
        guard let userInfo = UserInfo(notification.userInfo) else { return }
        frame = userInfo.frameEnd
        guard isEnabled else { return }
        didChangeFrame?(userInfo)
    }
}

extension KeyboardObserver.State {
    var isShowing: Bool {
        if case .willShow = self {
            return true
        }
        return false
    }
    
    var isShown: Bool {
        if case .didShow = self {
            return true
        }
        return false
    }
    
    var isHidding: Bool {
        if case .willHide = self {
            return true
        }
        return false
    }
    
    var isHidden: Bool {
        if case .didHide = self {
            return true
        }
        return false
    }
}

extension KeyboardObserver.UserInfo {
    init?(_ info: [AnyHashable : Any]?) {
        guard let info = info else { return nil }
        guard let frameBegin = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return nil }
        guard let frameEnd = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return nil }
        guard let animationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return nil }
        guard let animationCurve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return nil }
        self.init(
            frameBegin: frameBegin,
            frameEnd: frameEnd,
            animationDuration: animationDuration,
            animationOptions: UIView.AnimationOptions(rawValue: animationCurve << 16)
        )
    }
}
