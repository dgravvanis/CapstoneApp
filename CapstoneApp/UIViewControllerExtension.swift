//
//  UIViewControllerExtension.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 5/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Present error messages to the user
    func presentError(title: String, message: String) {
     
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}