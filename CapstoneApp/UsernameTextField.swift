//
//  UsernameTextField.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 3/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// MARK: Class
class UsernameTextField: UITextField {
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        placeholder = "Username"
    }
}