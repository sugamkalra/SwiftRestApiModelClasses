//
//  CaneQuota.swift
//  Bagasse
//
//  Created by TCCODER on 14.11.15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation

/**
Possible status for the current day quota

*/
enum CaneQuotaStatus: String {
    case Accepted = "Accept",
    Unconfirmed = "not_confirmed",
    AdjustmentRequested = "Adjust"
}

/**
* Model object for Cane Quota
*
* @author TCCODER
* @version 1.0
*/
class CaneQuota: NSObject {
    
    /// the ID used to update quota
    let id: String
    
    /// the quota status
    var status: CaneQuotaStatus
    
    /// the Quota value
    var quota: Int
    
    /// the progress in completing Quota
    let trucksIn: Int
    
    /// the grower ID
    let maingrowerid: String
    
    /// the date of the quota
    var date: NSDate?
    
    /// the "almaestimate" value
    var almaEstimate: Int = 0
    
    /**
    Create Quota instance
    
    - parameter id:      the ID
    - parameter quota:   the quota value
    - parameter truckIn: the progress
    
    - returns: new instance
    */
    init(id: String, status: CaneQuotaStatus, quota: Int, trucksIn: Int = 0, maingrowerid: String = "") {
        self.id = id
        self.status = status
        self.quota = quota
        self.trucksIn = trucksIn
        self.maingrowerid = maingrowerid
    }
}