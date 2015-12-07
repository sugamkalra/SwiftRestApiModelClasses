//
//  CaneQuality.swift
//  apnagent
//
//  Created by TCCODER on 11/10/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation

/**
 * Cane Lab Sample Model
 *
 * @author TCCODER
 * @version 1.0
 */
class CaneLabSample {
    
    /// the id
    var id: String
    
    /// the sample id
    var sampleId: String!
    
    /// the rs
    var rs: String!
    
    /// the seq number
    var seq: String!
    
    /// the acct
    var acct: String!
    
    /// sample date
    var sampleDate: NSDate!
    
    /// the grower id
    var mainGrowerId: String!
    
    /// res value
    var res: Float!
    
    /// mois tare value
    var moistare: Float!
    
    /// mois m&w value
    var moismw: Float!
    
    /// mois m&d value
    var moismd: Float!
    
    /// pj brix value
    var pjbrx: Float!
    
    /// pj polar value
    var pjpolar: Float!
    
    /// ml mud value
    var mlmud: Float!
    
    /// % mud
    var mud: Float!
    
    /// adj residue value
    var adjresidue: Float!
    
    /// sum total value
    var sumtotal: Float!
    
    /// lab trs
    var labtrs: Float!
    
    /**
     Init
     */
    init(id: String) {
        self.id = id
    }
}

/**
 * CaneLabSample Extension for creating lab example from JSON
 *
 * @author TCCODER
 * @version 1.0
 */
extension CaneLabSample {
    
    /**
     Create a lab sample from JSON 
     
     - parameter json: the json
     */
    
    class func caneLabSampleFromJSON(json: JSON) -> CaneLabSample
    {
        
        let strRS:String
        
        if json["rs"] != nil
        {
            strRS = "\(json["rs"])"
        }
        else
        {
            strRS = "0"
        }
        
        let strSEQ:String
        
        if json["seq"] != nil
        {
            strSEQ = "\(json["seq"])"
        }
        else
        {
            strSEQ = "0.00"
        }

        
        let caneLabSample = CaneLabSample(id:"\(json["id"])")
        caneLabSample.sampleId = json["sampleid"].string!
        caneLabSample.rs = strRS
        caneLabSample.seq = strSEQ
        caneLabSample.acct = json["acct"].string!
        caneLabSample.sampleDate = DateFormatters.fullDate.dateFromString(json["sampledate"].string!)
        caneLabSample.mainGrowerId = json["maingrowerid"].string!
        caneLabSample.res = json["res"].float!
        caneLabSample.moistare = json["moistare"].float!
        caneLabSample.moismw = json["moismw"].float!
        caneLabSample.moismd = json["moismd"].float!
        caneLabSample.pjbrx = json["pjbrx"].float!
        caneLabSample.pjpolar = json["pjpolar"].float!
        caneLabSample.mlmud = json["mlmud"].float!
        caneLabSample.mud = json["mud"].float!
        caneLabSample.adjresidue = json["adjresidue"].float!
        caneLabSample.sumtotal = json["sumtotal"].float!
        caneLabSample.labtrs = json["labtrs"].float!
        return caneLabSample
    }
}