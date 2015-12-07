//
//  Config.swift
//  Bagasse
//
//  Created by TCCODER on 11/3/15.
//  Modified by TCCODER on 11/14/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation

/**
 * Config
 * A Singleton for loading data from Config.plist
 *
 * @author TCCODER
 * @version 1.1
 *
 * changes:
 * 1.1:
 * - Reading options from Settings
 * - clean up
 */
class Config {
    
    /// the singleton
    static let sharedInstance = Config()
    
    // This prevents others from using the default '()' initializer for this class.
    private init() {
        loadConfig()
    }
    
    /// the config dictionary
    var config: NSDictionary?
    
    /**
    Load config from Config.plist
    */
    func loadConfig() {
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            config = NSDictionary(contentsOfFile: path)
        }
    }
    
    /**
    Get base url from Config.plist
    
    - Returns: the base url string
    */
   /* func getBaseUrl() -> String {
        return config!.valueForKey("base_url") as! String
    }*/
     
     /**
     Get base url from Config.plist
     
     - Returns: the base url string
     */
    func getBaseUrl() -> String {
        let key = "base_url"
        var url = NSUserDefaults.standardUserDefaults().stringForKey(key) ?? ""
        if url.isEmpty {
            url = config!.valueForKey(key) as! String
            delay(0, { () -> () in
                // Update settings from default config
                NSUserDefaults.standardUserDefaults().setValue(url, forKey: key)
                NSUserDefaults.standardUserDefaults().synchronize()
            })
        }
        return url
    }

    /**
     Get help images
     
     - returns: the help images
     */
    func getHelpImages() -> [String] {
        return config!.valueForKey("help_images") as! [String]
    }
    
    /**
     Get good sample url from Config.plist
     
     - returns: the good sample url string
     */
    func getGoodSampleUrl() -> String {
        return config!.valueForKey("good_sample_url") as! String
    }
    
    /**
     Get your sample url from Config.plist
     
     - returns: the your sample url string
     */
    func getYourSampleUrl() -> String {
        return config!.valueForKey("your_sample_url") as! String
    }

    


}
