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
class ViewController: UIViewController, UISearchBarDelegate {

    // MARK: - Properties
    var currentUser: PFUser?
    
    // MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
        
        BitcoinAverageClient.sharedInstance.updateBitcoinRateForCurrency("USD")
        
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
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SearchForListing" {
            
            let viewController = segue.destinationViewController as! ListingsTableViewController
            viewController.searchString = searchBar.text?.lowercaseString
        }
    }
    
    // MARK: - Search Bar Delegate Methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if searchBar.text != nil {
            performSegueWithIdentifier("SearchForListing", sender: nil)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // Hide the search bar
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }

    // MARK: - Methods
    // MARK: - Actions
    @IBAction func createButtonTouched(sender: UIButton) {
        
        performSegueWithIdentifier("CreateListingSegue", sender: self)
    }
}

