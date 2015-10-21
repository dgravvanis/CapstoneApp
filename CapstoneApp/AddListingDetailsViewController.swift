//
//  AddListingDetailsViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 8/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class AddListingDetailsViewController: PageContentViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties

    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startingPriceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    

    // MARK: - Actions
    @IBAction func doneButtonPressed(sender: UIButton) {
        
        let price = NSNumber(integer: Int(startingPriceTextField.text!)!)
        
        let newListing = Listing(title: titleTextField.text!, startingPrice: price , itemDescription: descriptionTextView.text, fromUser: PFUser.currentUser()!)
        
        for imageFile in SharingManager.sharedInstance.imageFiles {
            
            let photo = Photo(imageFile: imageFile, listing: newListing)
            photo.saveInBackground()
        }
        
        SharingManager.sharedInstance.imageFiles.removeAll()
        
        newListing.saveInBackgroundWithBlock() { (success: Bool, error: NSError?) -> Void in
            
            if (success) {
                // The object has been saved.
                print("listing saved")
                
                
            } else {
                // There was a problem, check error.description
                self.presentError("Alert", message: (error?.description)!)
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
