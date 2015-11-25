//
//  CreateListingPageViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 10/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// MARK: Class
class CreateListingPageViewController: UIViewController, UIPageViewControllerDataSource {

    // MARK: Properties
    var pageViewController: UIPageViewController!
    let contentViewControllers = ["AddPhotoViewController", "AddListingDetailsViewController"]
    
    // MARK: - Outlets
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initializePageController()
        
        //Set the number of pages
        pageControl.numberOfPages = contentViewControllers.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func viewControllerAtIndex(index: Int) -> UIViewController {
        
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(contentViewControllers[index]) as! PageContentViewController
        viewController.pageIndex = index
        return viewController
    }
    
    func initializePageController() {
        
        // Get page view controller from storyboard
        pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
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
        if index == contentViewControllers.count {
            return nil
        }
        
        // Update pageControl
        pageControl.currentPage = index
        return viewControllerAtIndex(index)
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPress(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}