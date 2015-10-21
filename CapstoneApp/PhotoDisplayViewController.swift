//
//  PhotoDisplayViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 7/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit

// MARK: Class
class PhotoDisplayViewController: PageContentViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var imageFile: String!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the image
        imageView.image = UIImage(named: imageFile)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}