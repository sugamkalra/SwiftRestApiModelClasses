//
//  HelperFunctions.swift
//  Topcoder
//
//  Created by TCCODER on 10/30/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import UIKit


/**
 * DateFormatters
 *
 * @author TCCODER
 * @version 1.0
 */
struct DateFormatters {
    
    /// Full date format
    static var fullDate: NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        f.locale = NSLocale.currentLocale()
        return f
    }()
    
    /// Date only format
    static var dateOnly: NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "MM/dd/yyyy"
        f.locale = NSLocale.currentLocale()
        return f
    }()
    
    /// Time only format
    static var timeOnly: NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "HH:mm"
        f.locale = NSLocale.currentLocale()
        return f
    }()
    
    /// Human rexadable format
    static var humanReadable: NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "MMM dd"
        return f
    }()
}

/**
 Delays given callback invocation
 
 - parameter delay: the delay in seconds
 - parameter callback: the callback to invoke after 'delay' seconds
 */
func delay(delay: NSTimeInterval, _ callback: ()->()) {
    let delayTime = delay * Double(NSEC_PER_SEC)
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime));
    dispatch_after(popTime, dispatch_get_main_queue(), {
        callback()
    })
}

/**
 Check if we should show rotate screen or not
 
 - returns: the status
 */
func shouldShowRotateInformation() -> Bool {
    return !NSUserDefaults.standardUserDefaults().boolForKey("no-rotate-information")
}

/**
 Set the show rotate information to not be shown anymore for the next launch
 */
func dontShowRotateInformation() {
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "no-rotate-information")
}