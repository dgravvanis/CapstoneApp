//
//  FiatTextFieldDelegate.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 2/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation
import UIKit

//
// Custom delegate for text field
// to handle fiat currency input
//

// MARK: Class
class FiatTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: - Properties
    private lazy var formatter: NSNumberFormatter = {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        return formatter
        }()
    
    // MARK: - UITextFieldDelegate Methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Prevent undo crash
        if range.location + range.length > textField.text?.characters.count {
            return false
        }
        
        let newText = NSString(string: textField.text!).stringByReplacingCharactersInRange(range, withString: string)
        
        // Digits only in input (or deletions)
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        for character in string.unicodeScalars {
            if !digits.longCharacterIsMember(character.value) {
                return false
            }
        }
        
        // Gather all digits
        var newTextDigits = ""
        for character in newText.unicodeScalars {
            if digits.longCharacterIsMember(character.value) {
                newTextDigits.append(character)
            }
        }
        
        // Format all digits into a currency string
        let subunits = NSDecimalNumber(string: newTextDigits)
        if subunits == NSDecimalNumber.notANumber() {
            
            textField.text = formatter.stringFromNumber(NSNumber(integer: 0))
        } else {
            
            let unit = subunits.decimalNumberByDividingBy(100)
            let proposedText = formatter.stringFromNumber(unit)
            
            // Limit characters to 15
            if let proposedText = proposedText {
                if proposedText.characters.count > 15 {
                    return false
                }
            }
            textField.text = proposedText
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = formatter.stringFromNumber(NSNumber(integer: 0))
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
