//
//  BitcoinAverageApiClient.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 2/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import Foundation

// MARK: Protocol
protocol BitcoinAverageClientDelegate {
    func btcRateDidUpdate(rate: Float)
}

// MARK: - Class
class BitcoinAverageClient: NSObject {
    
    // MARK: - Properties
    // Singleton
    static let sharedInstance = BitcoinAverageClient()
    private var session = NSURLSession.sharedSession()
    // Delegate
    var delegate: BitcoinAverageClientDelegate?
    
    // MARK: - Methods
    private func generateURLForCurrency(currency: String) -> NSURL? {
        
        let components = NSURLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path + "\(currency)/"
        
        return components.URL
    }
    
    private func httpsGetRequest(url: NSURL, completionHandler: (data: NSData?, error: NSError?) -> Void) {
        
        let task = session.dataTaskWithURL(url) { data, responce, error in
            completionHandler(data: data, error: error)
        }
        
        // Start the request
        task.resume()
    }
    
    func updateBitcoinRateForCurrency(currency: String) {
        
        // Generate the URL
        guard let url = generateURLForCurrency(currency) else {
            
            // Handle error
            print("updateBitcoinRateForCurrency: url is Nil")
            return
        }
        
        // Make the request
        httpsGetRequest(url) { rawJSON, error in
            
            if let error = error {
                
                // Handle error
                print("updateBitcoinRateForCurrency: \(error)")
                return
            }
            
            if let rawJSON = rawJSON {
                
                // Parse JSON
                do{
                    let parsedResult = try NSJSONSerialization.JSONObjectWithData(rawJSON, options: .AllowFragments)
                    guard let rate = parsedResult.valueForKey(JSONResponseKeys.average24h) as? Float else {
                        
                        // Handle error
                        print("updateBitcoinRateForCurrency: key not found in results")
                        return
                    }
                    
                    // Store bitcoin rate in user defaults
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setFloat(rate, forKey: "rate")
                    
                    // Delegate
                    if let delegate = self.delegate {
                        dispatch_async(dispatch_get_main_queue()) { delegate.btcRateDidUpdate(rate) }
                    }
                    
                } catch {
                    // Handle error
                    print("updateBitcoinRateForCurrency: \(error)")
                    return
                }
            }
        }
        
    }
}

// MARK: - Extension
extension BitcoinAverageClient {
    
    // MARK: - API Constants
    private struct Constants {
        
        static let scheme = "https"
        static let host = "api.bitcoinaverage.com"
        static let path = "/ticker/global/"
    }
    
    private struct JSONResponseKeys {
        
        static let average24h = "24h_avg"
        static let ask = "ask"
        static let bid = "bid"
        static let last = "last"
        static let timestamp = "timestamp"
        static let volume = "volume_btc"
        static let  volumePercent = "volume_percent"
    }
}