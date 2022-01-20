//
//  ExUIButton.swift
//  Snack
//
//  Created by ghyeongkim-MN on 2022/01/20.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        switch state {
        case .normal:
            context.setFillColor(color.cgColor)
        case .disabled:
            context.setFillColor(color.withAlphaComponent(0.3).cgColor)
        default:
            context.setFillColor(color.cgColor)
        }
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
