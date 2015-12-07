//
//  CaneSurveyFormData.swift
//  Bagasse
//
//  Created by TCCODER on 14.11.15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation

// type alias to cover one pair of Cane Survey form data
typealias SurveyData = (acres: Float, tonPerAcre: Float)

/**
* Model object used to send Cane Survey form data
*
* @author TCCODER
* @version 1.0
*/
class CaneSurveyFormData {
    
    /// total for harvest
    var total: SurveyData?
    
    /// less total harvested
    var lessHavest: SurveyData?
    
    /// total remaining
    var remain: SurveyData?
    
    /// total % to ALMA
    var totalAlma: Float?
    
    /// the grower ID
    let growerId: String
    
    /// the data creation date
    var date = NSDate()
    
    /**
    Create new instance with empty data (all nil)
    
    - parameter growerId: the grower ID
    
    - returns: new instance
    */
    init(growerId: String) {
        self.growerId = growerId
    }
    
    /**
    Get total for harvest calculated value
    
    - returns: the value
    */
    func getTotal() -> Float {
        return total!.acres * total!.tonPerAcre
    }
    
    /**
    Get less total harvested calculated value
    
    - returns: the value
    */
    func getLessTotal() -> Float {
        return lessHavest!.acres * lessHavest!.tonPerAcre
    }
    
    /**
    Get total remaining calculated value
    
    - returns: the value
    */
    func getRemainTotal() -> Float {
        return remain!.acres * remain!.tonPerAcre
    }
    
}