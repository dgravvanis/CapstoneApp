//
//  SignUpViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 3/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UsernameTextField!
    @IBOutlet weak var emailTextField: EmailTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func closeButtonTouched(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func singUpButtonTouched(sender: UIButton) {
        
        // Check if user completed the form
        if usernameTextField.text?.isEmpty == true {
            usernameTextField.shake()
            return
        }
        if !emailTextField.containsValidEmail() {
            emailTextField.shake()
            return
        }
        if passwordTextField.text?.isEmpty == true {
            passwordTextField.shake()
            return
        }
        
        // Create user object
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        
        // Sign up the user
        user.signUpInBackgroundWithBlock() { (succeeded: Bool, error: NSError?) -> Void in
            
            if let error = error,
                let errorString = error.userInfo["error"] as? String {
                    // Show the errorString to the user
                    self.presentError("Alert", message: errorString)
                    
            } else {
                
                // Perform segue
                self.performSegueWithIdentifier("SignUpSegue", sender: self)
            }
            
        }
    }
}
