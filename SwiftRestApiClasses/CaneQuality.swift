//
//  CaneQuality.swift
//  apnagent
//
//  Created by TCCODER on 11/13/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation

/**
 * Cane Quality Model
 *
 * @author TCCODER
 * @version 1.0
 */
class CaneQuality: NSObject {
    
    /// grower id
    var growerId: String
    
    /// the status
    var status: String
    
    /// published date
    var publishedAt: NSDate
    
    /// lab samples, for today and yesterday
    var labSamples: [[CaneLabSample]]
    
    /// grower crop data
    var growerCrops: [GrowerCrop]
    
    /**
     Init
     */
    init(growerId: String, status: String, publishedAt: NSDate) {
        self.growerId = growerId
        self.status = status
        self.publishedAt = publishedAt
        
        self.growerCrops = [GrowerCrop]()
        self.labSamples = [[CaneLabSample]]()
    }
}

/**
 * Cane Quality Extension for creating Cane Quality from JSON
 *
 * @author TCCODER
 * @version 1.0
 */
extension CaneQuality {
    /**
     Create CaneQuality from json
     
     - parameter json: the json
     - returns: the cane quality instance
     */
    class func caneQualityFromJSON(json: JSON) -> CaneQuality {
        
        // create cane quality
        let caneQuality = CaneQuality(
            growerId: json["growerid"].string!,
            status: json["status"].string!,
           publishedAt: DateFormatters.fullDate.dateFromString(json["published_at"].string!)!)
        
        // create grower crop
        caneQuality.growerCrops = GrowerCrop.growerCropsFromJSON(json)
        
        // create lab sample data
        let data = json["data"].array!
        for labSamplesJSON in data {
            var samples = [CaneLabSample]()
            for labSampleJSON in labSamplesJSON.array! {
                let sample = CaneLabSample.caneLabSampleFromJSON(labSampleJSON)
                samples.append(sample)
            }
            caneQuality.labSamples.append(samples)
        }
        return caneQuality
    }
}