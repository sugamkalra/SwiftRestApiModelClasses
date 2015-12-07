//
//  GrowerCrop.swift
//  apnagent
//
//  Created by TCCODER on 11/11/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation

/**
 * Grower Crop Model
 *
 * @author TCCODER
 * @version 1.0
 */
class GrowerCrop {
    
    /// the title
    var title: String!
    
    /// average value
    var average: Float!
    
    /// all average value
    var allAverage: Float!
    
    /// the diff
    var diff: Float!
    
    /**
     Init
     */
    init(title: String, average: Float, allAverage: Float, diff: Float) {
        self.title = title
        self.average = average
        self.allAverage = allAverage
        self.diff = diff
    }
}

/**
 * GrowerCrop Extension for creating data from JSON
 *
 * @author TCCODER
 * @version 1.0
 */
extension GrowerCrop {
    
    /**
     Create a grower crop from JSON
     
     - parameter json: the json
     */
    class func growerCropsFromJSON(json: JSON) -> [GrowerCrop] {
        
        print(json)
        
        
        // Core
        
        let diffCore:Float
        let avgCore:Float
        let allAvgCore:Float
        
        if (json["diff"]["corelabtrs"] != nil)
        {
            diffCore = json["diff"]["corelabtrs"].float!
        }
        else
        {
            diffCore = 0.0
        }
        
        if (json["groweraverage"]["corelabtrs"] != nil)
        {
            avgCore = json["groweraverage"]["corelabtrs"].float!
        }
        else
        {
            avgCore = 0.0
        }

        
        if (json["allaverage"]["corelabtrs"] != nil)
        {
            allAvgCore = json["allaverage"]["corelabtrs"].float!
        }
        else
        {
            allAvgCore = 0.0
        }

        // Estimill
        
        let diffEst:Float
        let avgEst:Float
        let allAvgEst:Float
        
        if (json["diff"]["estmillcrs"] != nil)
        {
            diffEst = json["diff"]["estmillcrs"].float!
        }
        else
        {
            diffEst = 0.0
        }
        
        if (json["groweraverage"]["estmillcrs"] != nil)
        {
            avgEst = json["groweraverage"]["estmillcrs"].float!
        }
        else
        {
            avgEst = 0.0
        }
        
        if (json["allaverage"]["estmillcrs"] != nil)
        {
            allAvgEst = json["allaverage"]["estmillcrs"].float!
        }
        else
        {
            allAvgEst = 0.0
        }
        
        // Sed
        
        let diffSed:Float
        let avgSed:Float
        let allAvgSed:Float
        
        if (json["diff"]["sediment"] != nil)
        {
            diffSed = json["diff"]["sediment"].float!
        }
        else
        {
            diffSed = 0.0
        }

        
        if (json["groweraverage"]["sediment"] != nil)
        {
            avgSed = json["groweraverage"]["sediment"].float!
        }
        else
        {
            avgSed = 0.0
        }
        
        if (json["allaverage"]["sediment"] != nil)
        {
            allAvgSed = json["allaverage"]["sediment"].float!
        }
        else
        {
            allAvgSed = 0.0
        }

        // Fibr
        
        let diffFibr:Float
        let avgFibr:Float
        let allAvgFibr:Float
        
        if (json["diff"]["fibraque"] != nil)
        {
            diffFibr = json["diff"]["fibraque"].float!
        }
        else
        {
            diffFibr = 0.0
        }
        
        
        if (json["groweraverage"]["fibraque"] != nil)
        {
            avgFibr = json["groweraverage"]["fibraque"].float!
        }
        else
        {
            avgFibr = 0.0
        }
        
        if (json["allaverage"]["fibraque"] != nil)
        {
            allAvgFibr = json["allaverage"]["fibraque"].float!
        }
        else
        {
            allAvgFibr = 0.0
        }

        
        // Purity
        
        let diffjuicepurity:Float
        let avgjuicepurity:Float
        let allavgjuicepurity:Float
        
        if (json["diff"]["juicepurity"] != nil)
        {
            diffjuicepurity = json["diff"]["juicepurity"].float!
        }
        else
        {
            diffjuicepurity = 0.0
        }
        
        if (json["groweraverage"]["juicepurity"] != nil)
        {
            avgjuicepurity = json["groweraverage"]["juicepurity"].float!
        }
        else
        {
            avgjuicepurity = 0.0
        }
        
        if (json["allaverage"]["juicepurity"] != nil)
        {
            allavgjuicepurity = json["allaverage"]["juicepurity"].float!
        }
        else
        {
            allavgjuicepurity = 0.0
        }

        
        // Pol
        
        let diffjuicepol:Float
        let avgjuicepol:Float
        let allAvgjuicepol:Float
        
        if (json["diff"]["juicepol"] != nil)
        {
            diffjuicepol = json["diff"]["juicepol"].float!
        }
        else
        {
            diffjuicepol = 0.0
        }
        
        if (json["groweraverage"]["juicepol"] != nil)
        {
            avgjuicepol = json["groweraverage"]["juicepol"].float!
        }
        else
        {
            avgjuicepol = 0.0
        }
        
        if (json["allaverage"]["juicepol"] != nil)
        {
            allAvgjuicepol = json["allaverage"]["juicepol"].float!
        }
        else
        {
            allAvgjuicepol = 0.0
        }

        
        // Brix
        
        let diffjuicebrix:Float
        let avgjuicebrix:Float
        let allavgjuicebrix:Float
        
        if (json["diff"]["juicebrix"] != nil)
        {
            diffjuicebrix = json["diff"]["juicebrix"].float!
        }
        else
        {
            diffjuicebrix = 0.0
        }

        if (json["groweraverage"]["juicebrix"] != nil)
        {
            avgjuicebrix = json["groweraverage"]["juicebrix"].float!
        }
        else
        {
            avgjuicebrix = 0.0
        }
        
        if (json["allaverage"]["juicebrix"] != nil)
        {
            allavgjuicebrix = json["allaverage"]["juicebrix"].float!
        }
        else
        {
            allavgjuicebrix = 0.0
        }

        
        var growerCrops = [GrowerCrop]()
        growerCrops.append(GrowerCrop(
            title: "Core Lab Trs",
            average: avgCore,
            allAverage: allAvgCore,
            diff: diffCore))
        
        growerCrops.append(GrowerCrop(
            title: "Est. Mill Crs",
            average: avgEst,
            allAverage: allAvgEst,
            diff: diffEst))

        growerCrops.append(GrowerCrop(
            title: "Juice Brix",
            average: avgjuicebrix,
            allAverage: allavgjuicebrix,
            diff: diffjuicebrix))
        
        growerCrops.append(GrowerCrop(
            title: "Juice Pol.",
            average: avgjuicepol,
            allAverage: allAvgjuicepol,
            diff: diffjuicepol))

        growerCrops.append(GrowerCrop(
            title: "Juice Purity",
            average: avgjuicepurity,
            allAverage: allavgjuicepurity,
            diff: diffjuicepurity))
        
        growerCrops.append(GrowerCrop(
            title: "Fibraque",
            average: avgFibr,
            allAverage: allAvgFibr,
            diff: diffFibr))
        
        growerCrops.append(GrowerCrop(
            title: "% Sediment",
            average: avgSed,
            allAverage: allAvgSed,
            diff: diffSed))

        return growerCrops
    }
}