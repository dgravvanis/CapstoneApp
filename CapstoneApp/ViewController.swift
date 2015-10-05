//
//  ViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 2/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTouch(sender: UIButton) {
        
        if let viewController = storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") {
            presentViewController(viewController, animated: true, completion: nil)
        }
    }

}

