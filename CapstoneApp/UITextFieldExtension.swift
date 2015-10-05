//
//  UITextFieldExtension.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 3/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

extension UITextField {
    
    // If text is in valid email form returns true
    func containsValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(text)
    }
    
    // Shake animation
    func shake() {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(center.x - 10, center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(center.x + 10, center.y))
        layer.addAnimation(animation, forKey: "position")
    }
}
