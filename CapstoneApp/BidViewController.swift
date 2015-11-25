//
//  BidViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 30/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class BidViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    var listing: Listing?
    var btcRate: Float?
    var bids = [Bid]()
    
    // Fiat currency number formatter
    private lazy var formatter: NSNumberFormatter = {
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        return formatter
        }()
    
    // Bitcoin number formatter
    private lazy var btcFormatter: NSNumberFormatter = {
        
        let formatter = NSNumberFormatter()
        formatter.positiveFormat = "###0.########"
        formatter.minimumFractionDigits = 8
        return formatter
        }()
    
    // MARK: - Outlets
    @IBOutlet weak var bidAmountTextField: UITextField!
    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var bidButton: UIButton!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bidAmountTextField.delegate = self
        getBtcRate()
        queryListingForBids(listing!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Text Field Delegate Methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Prevent undo crash
        if range.location + range.length > textField.text?.characters.count {
            return false
        }
        
        let newText = NSString(string: textField.text!).stringByReplacingCharactersInRange(range, withString: string)
        
        // Digits only in input (or deletions)
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        for character in string.unicodeScalars {
            if !digits.longCharacterIsMember(character.value) {
                return false
            }
        }
        
        // Gather all digits
        var newTextDigits = ""
        for character in newText.unicodeScalars {
            if digits.longCharacterIsMember(character.value) {
                newTextDigits.append(character)
            }
        }
        
        // Format all digits into a currency string
        let subunits = NSDecimalNumber(string: newTextDigits)
        if subunits == NSDecimalNumber.notANumber() {
            
            textField.text = formatter.stringFromNumber(NSNumber(integer: 0))
        } else {
            
            let unit = subunits.decimalNumberByDividingBy(100)
            let proposedText = formatter.stringFromNumber(unit)
            
            // Limit characters to 15
            if let proposedText = proposedText {
                if proposedText.characters.count > 15 {
                    return false
                }
            }
            textField.text = proposedText
            btcLabel.text = btcFormatter.stringFromNumber(convertFiatToBtc(newTextDigits) as NSNumber)
            
            let userBid = Float(btcLabel.text!)
            var currentPrice = listing?.startingPrice as! Float
            
            if bids.count != 0 {
                
                currentPrice = bids[0].amount as Float
            }
            
            if userBid > currentPrice || userBid == currentPrice && bids.count == 0 {
                
                bidButton.enabled = true
            } else {
                bidButton.enabled = false
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = formatter.stringFromNumber(NSNumber(integer: 0))
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    @IBAction func dismissButtonTouch(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func bidButtonTouch(sender: UIButton) {
        
        let userBid = Float(btcLabel.text!)
        var currentPrice = listing?.startingPrice as! Float
        
        if bids.count != 0 {
            
            currentPrice = bids[0].amount as Float
        }
        
        
        if userBid > currentPrice || userBid == currentPrice && bids.count == 0 {
            
            let newBid = Bid(fromUser: PFUser.currentUser()!, amount: userBid!, listing: listing!)
            
            newBid.saveInBackgroundWithBlock() {
                
                (success: Bool, error: NSError?) -> Void in
                
                if (success) {
                    // The object has been saved.
                    print("bid saved")
                    
                    
                } else {
                    // There was a problem, check error.description
                    self.presentError("Alert", message: (error?.description)!)
                }
            }
        }
        
    }
    
    // MARK: - Methods
    func getBtcRate() {
        
        // Read the BTC rate from the user defaults
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let rate = userDefaults.valueForKey("rate")
        btcRate = rate as? Float
    }
    
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
                
                // If bids found get the most recent bid and propose a bid value
                if self.bids.count != 0 {
                    self.setInitialBidValue(self.bids.first?.amount as! Float)
                
                // If no bids found bid value is starting price
                } else {
                    self.bidAmountTextField.text = self.formatter.stringFromNumber(listing.startingPrice as Float * self.btcRate!)
                    self.btcLabel.text = self.btcFormatter.stringFromNumber(listing.startingPrice)
                }
            }
        }
    }

    func convertFiatToBtc(amount: String) -> Float {
        
        // Convert fiat to BTC
        let btc = (Float(amount)! / 100 ) / btcRate!
        return btc
    }
    
    func setInitialBidValue(value: Float) {
        
        // Set a proposed bid value +1$
        let proposedBidFiat = value * btcRate! + 1
        let proposedBidBtc = proposedBidFiat / btcRate!
        bidAmountTextField.text = formatter.stringFromNumber(proposedBidFiat)
        btcLabel.text = btcFormatter.stringFromNumber(proposedBidBtc)
    }
}
