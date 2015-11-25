//
//  ListingsTableViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 21/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class ListingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    var listingsFound = [Listing]()
    var photosFound = [Photo]()
    var searchString: String?
    var listingSelected: Listing?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        if let searchString = searchString {
            queryListingStringInTitle(searchString)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listingsFound.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Dequeue the reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ListingTableCell", forIndexPath: indexPath)
        
        // Get the listing
        let listing = listingsFound[indexPath.row]
        
        for photo in photosFound {
            
            if photo.listing == listing {
                
                photo.imageFile.getDataInBackgroundWithBlock() {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            cell.imageView?.image = image
                            //tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        cell.textLabel?.text = listing.title
        cell.detailTextLabel?.text = getNaturalTimeToEnd(listing.endsAt)
        return cell
    }
    
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        listingSelected = listingsFound[indexPath.row]
        performSegueWithIdentifier("ShowListingDetail", sender: self)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowListingDetail" {
            
            let viewController = segue.destinationViewController as! ListingDetailViewController
            viewController.listing = listingSelected
        }
    }
    
    // MARK: - Methods
    func queryListingStringInTitle(searchString: String) {
        
        let query = PFQuery(className: "Listing")
        query.whereKey("canonicalTitle", containsString: searchString)
        query.findObjectsInBackgroundWithBlock() { objects, error in
            
            if let error = error {
                
                // Handle error
                print("Error: \(error) \(error.userInfo)")
                return
            }
            
            if let listings = objects as? [Listing] {
                
                self.listingsFound = listings
                self.tableView.reloadData()
                for listing in listings {
                    
                    self.queryPhotoFromListing(listing)
                }
            }
            
            
        }
    }
    
    func queryPhotoFromListing(listing: Listing) {
        
        let query = PFQuery(className: "Photo")
        query.whereKey("listing", equalTo: listing)
        query.findObjectsInBackgroundWithBlock() { objects, error in
            
            if let error = error {
                
                // Handle error
                print("Error: \(error) \(error.userInfo)")
                return
            }
            print(objects)
            if let photos = objects as? [Photo] {
                
                self.photosFound.appendContentsOf(photos)
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    func getNaturalTimeToEnd(date: NSDate) -> String {
        
        // Get time interval from now to listing end
        let timeInterval = date.timeIntervalSinceDate(NSDate())
        print(timeInterval)
        var naturalTime: String
        
        switch timeInterval {
            
        case 0..<60 :
            
            naturalTime = "ending in \(timeInterval) sec"
            return naturalTime
        
        case 60..<3600 :
            
            naturalTime = "ending in \(Int(floor(timeInterval / 60)) + 1) min"
            return naturalTime
            
        case 3600..<86400 :
            
            naturalTime = "ending in \(Int(floor(timeInterval / 3600)) + 1) hours"
            return naturalTime
            
        case _ where timeInterval > 86400 :
            
            naturalTime = "ending in \(Int(floor(timeInterval / 86400)) + 1) days"
            return naturalTime
        
        default:
            
            naturalTime = "ended"
            return naturalTime
        }
    }
}
