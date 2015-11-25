//
//  ListingDetailViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 26/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class ListingDetailViewController: UIViewController, UIPageViewControllerDataSource {

    // MARK: - Properties
    var pageViewController: UIPageViewController!
    var listing: Listing?
    var listingPhotos = [Photo]()
    var bids = [Bid]()
    
    // Bitcoin number formatter
    private lazy var btcFormatter: NSNumberFormatter = {
        
        let formatter = NSNumberFormatter()
        formatter.positiveFormat = "###0.########"
        formatter.minimumFractionDigits = 8
        return formatter
        }()
    
    // MARK: - Outlets
    @IBOutlet weak var photoContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = listing?.title
        descriptionLabel.text = listing?.itemDescription
        queryListingForBids(listing!)
        // Get page view controller from storyboard
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        // Set the data source
        pageViewController.dataSource = self

        // Do any additional setup after loading the view.
        queryPhotoFromListing(listing!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Page View Controller Data Source Methods
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        // Get index
        let vc = viewController as! PageContentViewController
        var index = vc.pageIndex as Int
        
        // Check index bounds
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        // Decrement index
        index--
        
        // Update pageControl
        //pageControl.currentPage = index
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        // Get index
        let vc = viewController as! PageContentViewController
        var index = vc.pageIndex as Int
        
        // Check index bounds
        if index == NSNotFound {
            return nil
        }
        
        // Increment index
        index++
        
        // Check index bounds
        if index == listingPhotos.count {
            return nil
        }
        
        // Update pageControl
        //pageControl.currentPage = index
        return viewControllerAtIndex(index)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PresentBidView" {
            
            let viewController = segue.destinationViewController as! BidViewController
            viewController.listing = listing
        }
    }
    
    // MARK: - Photo Page Controller Methods
    func viewControllerAtIndex(index: Int) -> ListingPhotoDisplayViewController {
        
        // We use one content controller
        // and populate it with with images
        // from pageImages array
        
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("ListingPhotoDisplayViewController") as! ListingPhotoDisplayViewController
        
        if !listingPhotos.isEmpty {
            viewController.photo = listingPhotos[index]
        }
        viewController.pageIndex = index
        return viewController
    }
    
    func displayPageController() {
        
        // Starting view controller
        let startVC = viewControllerAtIndex(0)
        
        // Configure page view controller
        pageViewController.setViewControllers([startVC], direction: .Forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRectMake(photoContainerView.bounds.origin.x,
                                                    photoContainerView.bounds.origin.y,
                                                    photoContainerView.bounds.width,
                                                    photoContainerView.bounds.height)
        
        // Display page view controller
        //addChildViewController(pageViewController)
        photoContainerView.insertSubview(pageViewController.view, atIndex: 0)
        pageViewController.didMoveToParentViewController(self)
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
            
            if let photos = objects as? [Photo] {
                
                self.listingPhotos.appendContentsOf(photos)
                self.displayPageController()
                print("done")
            }
        }
    }
    
    // MARK: Methods
    func queryListingForBids(listing: Listing) {
        
        // Query listing for existing bids
        // sorted by creation time
        let query = PFQuery(className: "Bid")
        query.whereKey("listing", equalTo: listing)
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock() { objects, error in
            
            if let error = error {
                
                // Handle error
                print("Error: \(error) \(error.userInfo)")
                return
            }
            
            if let bids = objects as? [Bid] {
                self.bids.appendContentsOf(bids)
                
                // Get the last bid value
                if self.bids.count != 0 {
                    self.priceLabel.text = self.btcFormatter.stringFromNumber((self.bids.first?.amount)!)
                    
                    // If no bids found display the starting price value
                } else {
                    self.priceLabel.text = self.btcFormatter.stringFromNumber(listing.startingPrice)
                }
            }
        }
    }
    // MARK: - Actions
    @IBAction func bidButtonPress(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("PresentBidView", sender: self)
    }
    
    @IBAction func bookmarkButtonPress(sender: UIBarButtonItem) {
    }
}