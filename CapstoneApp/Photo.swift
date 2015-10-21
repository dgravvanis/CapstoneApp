//
//  Photo.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 8/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import Parse

// MARK: Class
class Photo: PFObject, PFSubclassing {
    
    // MARK: - Properties
    @NSManaged var imageFile: PFFile
    @NSManaged var listing: Listing
    
    // MARK: - Initializer
    convenience init(imageFile: PFFile, listing: Listing) {
        self.init()
        
        self.imageFile = imageFile
        self.listing = listing
    }
    
    // MARK: - Methods
    static func parseClassName() -> String {
        return "Photo"
    }
}
