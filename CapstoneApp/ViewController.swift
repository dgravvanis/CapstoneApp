//
//  ViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 2/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class ViewController: UIViewController {

    // MARK: - Properties
    var currentUser: PFUser?
    
    // MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentUser = PFUser.currentUser()
        
        // Check if a user is logged in
        guard let user = currentUser else {
            
            // Hide label
            label.hidden = true
            return
        }
        // Do stuff with the user
        label.text = "Hello \(user.username!)"
        label.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods
    // MARK: - Actions

}

