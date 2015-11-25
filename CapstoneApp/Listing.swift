//
//  Listing.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 8/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation
import Parse

// MARK: Class
class Listing: PFObject, PFSubclassing {
    
    // MARK: - Properties
    @NSManaged var title: String
    @NSManaged var canonicalTitle: String
    @NSManaged var startingPrice : NSNumber
    @NSManaged var itemDescription: String
    @NSManaged var canonicalItemDescription: String
    @NSManaged var endsAt: NSDate
    @NSManaged var fromUser: PFUser
    
    // MARK: - Initializer
    convenience init(title: String, startingPrice: NSNumber, itemDescription: String, fromUser: PFUser, endTimeInterval: NSTimeInterval) {
        self.init()
        
        self.title = title
        self.canonicalTitle = title.lowercaseString
        self.startingPrice = startingPrice
        self.itemDescription = itemDescription
        self.canonicalItemDescription = itemDescription.lowercaseString
        self.endsAt = NSDate().dateByAddingTimeInterval(endTimeInterval)
        self.fromUser = fromUser
    }
    
    // MARK: - Methods
    static func parseClassName() -> String {
        return "Listing"
    }
}
