//
//  PasswordTextField.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 3/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// MARK: Class
class PasswordTextField: UITextField {
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        secureTextEntry = true
        placeholder = "Password"
    }
}