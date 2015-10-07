//
//  SignInViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 6/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    func presentSingUpViewController() {
        
        if let viewController = storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") {
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: Actions
    @IBAction func closeButtonTouched(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signInButtonTouched(sender: UIButton) {
        
        // Check if user completed the form
        if usernameTextField.text?.isEmpty == true {
            usernameTextField.shake()
            return
        }
        
        if passwordTextField.text?.isEmpty == true {
            passwordTextField.shake()
            return
        }
        
        // Log in the user
        PFUser.logInWithUsernameInBackground("\(usernameTextField.text!)", password:"\(passwordTextField.text!)") {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                
                // Perform segue
                self.performSegueWithIdentifier("SignInSegue", sender: self)
                
            } else {

                if let error = error,
                    let errorString = error.userInfo["error"] as? String {
                        // Show the errorString to the user
                        self.presentError("Alert", message: errorString)
                }
            }
        }
    }
}