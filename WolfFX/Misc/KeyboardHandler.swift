//
//  KeyboardHandler.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/8/21.
//  Copyright © 2021 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit


protocol KeyboardHandler: class {
    
    var bottomConstraint: NSLayoutConstraint! { get set }
    
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
    func startObservingKeyboardChanges()
    func stopObservingKeyboardChanges()
}

extension KeyboardHandler where Self: UIViewController {
    
    func startObservingKeyboardChanges() {
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
        
    func stopObservingKeyboardChanges() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
