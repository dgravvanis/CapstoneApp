//
//  Bid.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 30/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import Parse

class Bid: PFObject, PFSubclassing {
    
    // MARK: Properties
    @NSManaged var fromUser: PFUser
    @NSManaged var amount: NSNumber
    @NSManaged var listing: Listing
    
    // MARK: Initializer
    convenience init(fromUser: PFUser, amount: NSNumber, listing: Listing) {
        self.init()
        
        self.fromUser = fromUser
        self.amount = amount
        self.listing = listing
    }
    
    static func parseClassName() -> String {
        return "Bid"
    }
}