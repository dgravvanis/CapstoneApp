//
//  HomeViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 7/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// MARK: Class
class HomeViewController: UIViewController, UIPageViewControllerDataSource {

    // MARK: - Properties
    var pageViewController: UIPageViewController!
    var pageImages: NSArray!
    var carouselTimer: NSTimer!
    
    // MARK: - Outlets
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initializePageController()
        
        //Set the number of pages
        pageControl.numberOfPages = pageImages.count
        
        startCarousel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods
    func viewControllerAtIndex(index: Int) -> PhotoDisplayViewController {
        
        // We use one content controller
        // and populate it with with images
        // from pageImages array
        
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("PhotoDisplayViewController") as! PhotoDisplayViewController
        viewController.imageFile = pageImages[index] as! String
        viewController.pageIndex = index
        return viewController
    }
    
    func initializePageController() {
        
        // Get page view controller from storyboard
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        // Set the filenames from the images
        pageImages = ["", "", ""]
        
        // Set the data source
        pageViewController.dataSource = self
        
        // Starting view controller
        let startVC = viewControllerAtIndex(0)
        
        // Configure page view controller
        pageViewController.setViewControllers([startVC], direction: .Forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.width, view.frame.height)
        
        // Display page view controller
        addChildViewController(pageViewController)
        view.insertSubview(pageViewController.view, atIndex: 0)
        pageViewController.didMoveToParentViewController(self)
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
        pageControl.currentPage = index
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
        if index == pageImages.count {
            return nil
        }
        
        // Update pageControl
        pageControl.currentPage = index
        return viewControllerAtIndex(index)
    }
    
    // MARK: - Actions
    @IBAction func touchSignInButton(sender: UIButton) {
        
        // Present sign in controller
        if let viewController = storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") {
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func touchCreateAccountButton(sender: UIButton) {
        
        // Present sign in controller
        if let viewController = storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") {
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
}

// MARK: - Extension
extension HomeViewController {
    
    // MARK: - Carousel Methods
    func startCarousel() {
        
        if carouselTimer == nil {
            // Start timer with intervals
            carouselTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("moveCarousel"), userInfo: nil, repeats: true)
            
        }
    }
    
    func moveCarousel() {
        
        // Get the index
        var index: Int = (pageViewController.viewControllers?.first as! PageContentViewController).pageIndex
        
        // Increment or start over
        if index == pageImages.count - 1 {
            index = 0
        } else {
            index++
        }
        
        // Present content controller
        let contentViewControllerToDisplay = viewControllerAtIndex(index)
        pageViewController.setViewControllers([contentViewControllerToDisplay], direction: .Forward, animated: true, completion: nil)
        
        // Update pageControl
        pageControl.currentPage = contentViewControllerToDisplay.pageIndex
    }
    
    func stopCarousel() {
        
        if carouselTimer != nil {
            
            // Stop timer
            carouselTimer.invalidate()
            carouselTimer = nil
        }
    }
}
