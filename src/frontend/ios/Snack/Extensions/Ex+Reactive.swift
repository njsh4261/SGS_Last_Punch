//
//  Ex+Reactive.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/31.
//

import RxSwift

extension Reactive where Base: UIButton {
    
    var setImage: Binder<()> {
        return Binder(base, binding: { (button, _) in
            if button.image(for: .normal) == UIImage(systemName: "eye.fill") {
                button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            } else {
                button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }
        })
    }
    
    var setText: Binder<String> {
        return Binder(base, binding: { (button, str) in
            button.setTitle(str, for: .normal)
        })
    }
}

extension Reactive where Base: UIView {
    
    var endEditing: Binder<Void> {
        return Binder(base, binding: { (view, _) in
            view.endEditing(true)
        })
    }
}

extension Reactive where Base: UITextField {
    
    var canBecomeFirstResponder: Binder<Void> {
        return Binder(base, binding: { (textField, _) in
            textField.becomeFirstResponder()
        })
    }
    
    var setText: Binder<String> {
        return Binder(base, binding: { (textField, text) in
            textField.text = text
        })
    }
    
    // Toggle
    var isSecureTextEntry: Binder<()> {
        return Binder(base, binding: { (textField, _) in
            textField.isSecureTextEntry = !textField.isSecureTextEntry
        })
    }
    
    var deleteCodeBackward: Binder<(Bool)> {
        return Binder(base, binding: { (textField, _) in
            if textField.text!.count > 6 {
                textField.deleteBackward()
            }
        })
    }
    
    var deleteWorkspaceNameBackward: Binder<(Bool)> {
        return Binder(base, binding: { (textField, _) in
            if textField.text!.count > 16 {
                textField.deleteBackward()
            }
        })
    }
}
