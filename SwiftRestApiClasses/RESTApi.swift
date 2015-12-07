//
//  RESTApi.swift
//  Bagasse
//
//  Created by TCCODER on 10/28/15.
//  Modified by TCCODER on 11/14/15.
//  Copyright © 2015 topcoder. All rights reserved.
//

import Foundation

/**
* RESTAuthDelegate
* A delegate for RESTApi
*
* @author TCCODER
* @version 1.1
*
* changes:
* 1.1:
* - protocol name changed
*/
protocol RESTAuthDelegate {
    func authorizationPassedWithKey(key: String);
    func authorizationFailedWithError(error: NSError);
}

/**
* An abstract delegate for RESTApi that defines common methods.
* It's very helpful for handling common errors and reduce code duplication in clients.
*
* @author TCCODER
* @version 1.0
*/
@objc
protocol RESTDelegate {
    
    func requestFailedWithError(error: NSError)
    
    func requestSucceedWithData()
}

/**
* A delegate for RESTApi for Cane Weekly Survey related requests
*a
* @author TCCODER
* @version 1.0
*/
protocol RESTSurveyDelegate: RESTDelegate {
    
    /**
    Notifies that data has sent

    - parameter data: the data
    */
    func weeklySurveySaved(data: CaneSurveyFormData)
    
}

/**
* A delegate for RESTApi for Quota related requests
*a
* @author TCCODER
* @version 1.0
*/
@objc
protocol RESTQuotaDelegate: RESTDelegate {
    
    /**
    Today Quota recedved
    
    - parameter todayQuota: the quota
    */
    optional func dailyQuotaReceived(todayQuota: CaneQuota)
    
    /**
     Adjustment/acceptance request has sent
     */
    optional func quotaStatusChangeSucceed()
    
    
}


@objc
protocol RESTQualityDelegate: RESTDelegate {
    
    /**
     Quality with Data
     
     - parameter caneQuality: the cane
     */
     optional func fetchListQualityWithData(caneQuality: CaneQuality)
     optional func fetchListQualityFailedWithError(error: NSError)
    
}


/**
 * A delegate for RESTApi for Settings
 *a
 * @author TCCODER
 * @version 1.0
 */
@objc
protocol RESTSettingsDelegate: RESTDelegate {
    
    /**
     Settings are saved
     */
    optional func settingsSaved()
    
    /**
     Settings receieved
     */
    func settingsReceived(receiveNotifications: Bool)
    
}



/**
* RESTError
* ErrorType for RESTApi
*
* @author TCCODER
* @version 1.1
*
* changes:
* 1.1:
* - WrongParameters error type added
*/
enum RESTError: ErrorType {
    case NoNetworkConnection
    case InvalidResponse
    case Failure(message: String)
    case WrongParameters(message: String)
    
    /// return NSError object
    func error() -> NSError {
        let nsError = self as NSError
        
        print(nsError)
        
        return NSError(domain: nsError.domain, code: nsError.code,
            userInfo: [NSLocalizedDescriptionKey: self.description])
    }
}

/**
* RESTError Extension for Error Description
* ErrorType for RESTApi
*
* @author TCCODER
* @version 1.1
*
* changes:
* 1.1:
* - WrongParameters support
*/
extension RESTError: CustomStringConvertible {
    
    /// error description
    var description: String {
        switch self {
        case .NoNetworkConnection: return "No network connection available".localized()
        case .InvalidResponse: return "Invalid response from server".localized()
        case .Failure(let message): return "Failure: \(message)"
        case .WrongParameters(let message): return message
        }
    }
}

/**
* HTTP methods for requests
*/
public enum RESTMethod: String {
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
}

/**
* RESTApi
* A singleton to access the Rest API
*
* @author TCCODER
* @version 1.1
*
* changes:
* 1.1:
* - new API endpoint support
*/
class RESTApi {
    
    /// the singleton
    static let sharedInstance = RESTApi()
    // This prevents others from using the default '()' initializer for this class.
    private init() {}
    
    // MARK: Common methods
    
    /**
    Create request with JSON parameters
    
    - parameter method:     the method
    - parameter endpoint:   the endpoint
    - parameter parameters: the parameters
    - parameter delegate:   the delegate of REST Api
    
    - returns: the request
    */

    
    func createJsonRequestWithParams(method: RESTMethod, endpoint: String, parameters: [String: AnyObject],
        delegate: RESTDelegate) -> NSURLRequest  {
            var url = "\(Config.sharedInstance.getBaseUrl())/\(endpoint)"
            var body: NSData?
            if method == .GET {
                let params = parameters.toURLString()
                url = "\(url)?\(params)"
            }
            else {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(parameters,
                        options: NSJSONWritingOptions(rawValue: 0))
                    if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        body = string.dataUsingEncoding(NSUTF8StringEncoding)
                    }
                }
                catch let error as NSError {
                    delegate.requestFailedWithError(error)
                }
            }
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = method.rawValue
            if let key = AuthenticationUtil.sharedInstance.loadKey(),
                let username = AuthenticationUtil.sharedInstance.getUsername() {
                    let authStr = "\(username):\(key)".encodeBase64()
                    request.addValue("Basic \(authStr)", forHTTPHeaderField: "Authorization")
            }
            request.HTTPBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
    }

    
    // For Post Query
    
   /* func createJsonRequest(method: RESTMethod, endpoint: String, parameters: [String: String],
        delegate: RESTDelegate) -> NSURLRequest
    {
            var url = "\(Config.sharedInstance.getBaseUrl())/\(endpoint)"
            var body: NSData?
            
            /*if method == .GET {
                
                let params = parameters.toURLString()
                
                url = "\(url)?\(params)"
                
            }*/
           // else {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(parameters,
                        options: NSJSONWritingOptions(rawValue: 0))
                    if let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                    {
                        body = string.dataUsingEncoding(NSUTF8StringEncoding)
                        
                    }
                }
                catch let error as NSError {
                    delegate.requestFailedWithError(error)
                }
            //}
            
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = method.rawValue
            if let key = AuthenticationUtil.sharedInstance.loadKey(),
                let username = AuthenticationUtil.sharedInstance.getUsername() {
                    let authStr = "\(username):\(key)".encodeBase64()
                    request.addValue("Basic \(authStr)", forHTTPHeaderField: "Authorization")
            }
            
            request.HTTPBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
    }*/
    
    // For Get
    
    func createJsonRequest(method: RESTMethod, endpoint: String, parameters: [String: String],
        delegate: RESTDelegate) -> NSURLRequest
    {
        var url = "\(Config.sharedInstance.getBaseUrl())/\(endpoint)"
        var body: NSData?
        
        if method == .GET {
            
            let params = parameters.toURLString()
            
            url = "\(url)?\(params)"
            
        }
        else {
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(parameters,
                    options: NSJSONWritingOptions(rawValue: 0))
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                {
                    body = string.dataUsingEncoding(NSUTF8StringEncoding)
                    
                }
            }
            catch let error as NSError {
                delegate.requestFailedWithError(error)
            }
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method.rawValue
        if let key = AuthenticationUtil.sharedInstance.loadKey(),
            let username = AuthenticationUtil.sharedInstance.getUsername() {
                let authStr = "\(username):\(key)".encodeBase64()
                request.addValue("Basic \(authStr)", forHTTPHeaderField: "Authorization")
        }
        
        request.HTTPBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    /**
    Send request to REST Api
    
    - Parameters:
    - request: the request
    - handler: completion handler
    */
    func sendRequest(request: NSURLRequest, handler: (JSON?, RESTError?) -> (Void)) throws {
        
        // Check for network first
        if !Reachability.isConnectedToNetwork() {
            throw RESTError.NoNetworkConnection
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let error = error {
                handler(nil, RESTError.Failure(message: error.localizedDescription))
                return
            }
            // read json from data
            let json = JSON(data: data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            // if the response is failure
            if json["result"].string == "Failure" {
                handler(nil, RESTError.Failure(message: json["resultDetails"].string!))
            }
            else {
                handler(json, nil)
            }
        }
        task.resume()
    }
    
    /**
    Send request and handle common errors
    
    - parameter request:  the request
    - parameter success:  the callback to return JSON response
    - parameter delegate: the delegate to return errors
    
    - throws: exceptions from NSURLSession.dataTaskWithRequest
    */
    func sendRequestAndHandleError(request: NSURLRequest, success: (JSON)->(), delegate: RESTDelegate) throws {
        try self.sendRequest(request) { json, error in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // if there's an error
                if let error = error {
                    delegate.requestFailedWithError(error.error())
                }
                    // if response is not JSON object
                else if json == nil {
                    delegate.requestFailedWithError(RESTError.InvalidResponse.error())
                }
                else {
                    success(json!)
                }
            })
        }
    }
    
    // MARK: Authorization
    
    /**
    Request APSKey from REST Api
    
    - Parameters:
    - email: the username
    - pin: the password
    - delegate: the delegate of REST Api
    */
    func requestAuthorizationWithEmail(email: String, andPin pin: String,
        withDelegate delegate: RESTAuthDelegate) throws {
            let request = self.createAuthorizationRequest(email, pin: pin)
            try self.sendRequest(request) { json, error in
                
                // if there's an error
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        delegate.authorizationFailedWithError(error!.error())
                    })
                    return
                }
                
                
                
                // check for key "apikey"
                if let key = json!["apikey"].string {
                    
                    print(json!["growerid"].string!)
                    
                    // Added by Sugam - To Save Grower Id
                    AuthenticationUtil.sharedInstance.saveGrowerId(json!["growerid"].string!)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        delegate.authorizationPassedWithKey(key)
                    })
                }
                else {
                    // invalid response, not found key "apikey"
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        delegate.authorizationFailedWithError(RESTError.InvalidResponse.error())
                    })
                }
            }
    }
    
    /**
    Create request for authorization
    
    - Parameters:
    - email: the username
    - pin: the password
    - Returns: the request for authorization
    */
    func createAuthorizationRequest(email: String, pin: String) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Config.sharedInstance.getBaseUrl())/authorize")!)
        request.HTTPMethod = "PUT"
        request.HTTPBody = ["username": email, "password": pin].toURLString().dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    // MARK: Cane Survey
    
    /**
    Save a New Survey
    
    - parameter data:     the data to save
    - parameter delegate: the delegate of REST Api
    */
    func saveSurvey(data: CaneSurveyFormData, delegate: RESTSurveyDelegate) throws {
        
        // Validate parameters
        if data.total == nil
            || data.lessHavest == nil
            || data.remain == nil
            || data.totalAlma == nil {
                throw RESTError.WrongParameters(message: "Please fill all fields".localized())
        }
        if data.total!.acres < 0
            || data.total!.tonPerAcre < 0
            || data.lessHavest!.acres < 0
            || data.lessHavest!.tonPerAcre < 0
            || data.remain!.acres < 0
            || data.remain!.tonPerAcre < 0
            || data.totalAlma < 0 {
                throw RESTError.WrongParameters(message:"Please provide non negative values for all fields".localized())
        }
        
        /*date: {type: 'String'},
        totalacres: {type: 'Number', required: false},
        totaltonacre: {type: 'Number', required: false},
        total: {type: 'Number', required: false},
        lesshavestacres: {type: 'Number', required: false},
        lesstonacre: {type: 'Number', required: false},
        lesstotal: {type: 'Number', required: false},
        remainacres: {type: 'Number', required: false},
        remaintonacre: {type: 'Number', required: false},
        remaintotal: {type: 'Number', required: false},
        totalalma: {type: 'Number', required: false},
        growerid: {type: 'String'}*/
        
        
        let parameters: [String: AnyObject] = [
            "date": data.date.formatFullDate(),
            "totalacres": data.total!.acres,
            "totaltonacre": data.total!.tonPerAcre,
            "total": data.getTotal(),
            "lessharvestacres": data.lessHavest!.acres,
            "lesstonacre": data.lessHavest!.tonPerAcre,
            "lesstotal": data.getLessTotal(),
            "remainacres": data.remain!.acres,
            "remaintonacre": data.remain!.tonPerAcre,
            "remaintotal": data.getRemainTotal(),
            "totalalma": data.totalAlma!,
            "growerid": data.growerId
        ]
        
        let request = createJsonRequestWithParams(.POST, endpoint: "survey", parameters: parameters, delegate: delegate)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            // Check if success
            if let surveys = json.dictionary {
                if surveys.count > 0 {
                    if surveys["status"] == "Success" {
                        delegate.weeklySurveySaved(data)
                        return
                    }
                }
            }
            
            // Failed
            delegate.requestFailedWithError(RESTError.InvalidResponse.error())
            }, delegate: delegate)
    }
    
    // MARK: Cane Quota
    
    /**
    Get quota for given grower
    
    - parameter growerid: the grower's ID
    - parameter delegate: the delegate of REST Api
    */
    
    
    // For Post Query
    
    
   /* func getQuota(growerid: String, delegate: RESTQuotaDelegate) throws {
        struct Static {
            static var dateFormatter: NSDateFormatter = {
                let f = NSDateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                return f
                }()
        }
        
        let parameters = [
            "date": Static.dateFormatter.stringFromDate(NSDate()),
            "growerid": growerid
        ]
        
        print(growerid)
        
        let request = createJsonRequest(.POST, endpoint: "quota/query", parameters: parameters, delegate: delegate)
        
        //let request = createGetQuotaRequest(growerid)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            if let quotas = json["data"].array {
                if let quota = self.getRecentQuotaValue(quotas, json) {
                    
                    // Using most recent quota
                    delegate.dailyQuotaReceived?(quota)
                    return
                }
            }
            delegate.requestFailedWithError(RESTError.InvalidResponse.error())
            }, delegate: delegate)
    }*/

    // For Get

    func getQuota(growerid: String, delegate: RESTQuotaDelegate) throws {
        struct Static {
            static var dateFormatter: NSDateFormatter = {
                let f = NSDateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                return f
            }()
        }
        
        let parameters = [
            "date": Static.dateFormatter.stringFromDate(NSDate()),
            "growerid": growerid
        ]
        
        print(growerid)
        
        let request = createJsonRequest(.GET, endpoint: "quota", parameters: parameters, delegate: delegate)
        
        //let request = createGetQuotaRequest(growerid)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            if let quotas = json["data"].array {
                if let quota = self.getRecentQuotaValue(quotas, json) {
                    
                    // Using most recent quota
                    delegate.dailyQuotaReceived?(quota)
                    return
                }
            }
            
            delegate.requestFailedWithError(RESTError.InvalidResponse.error())
            }, delegate: delegate)
    }
    
    
    func createGetQuotaRequest(growerid:String) -> NSURLRequest
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Config.sharedInstance.getBaseUrl())/quota")!)
        
        request.HTTPMethod = "GET"
        
        struct Static {
            static var dateFormatter: NSDateFormatter = {
                let f = NSDateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                return f
            }()
        }
        
        request.HTTPBody = ["date": Static.dateFormatter.stringFromDate(NSDate()), "growerid": growerid].toURLString().dataUsingEncoding(NSUTF8StringEncoding)
        
        if let key = AuthenticationUtil.sharedInstance.loadKey(),
            let username = AuthenticationUtil.sharedInstance.getUsername() {
                let authStr = "\(username):\(key)".encodeBase64()
                request.addValue("Basic \(authStr)", forHTTPHeaderField: "Authorization")
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }

    
    
    /**
     Sent adjustment request for today quota
     
     - parameter quota:    the quota
     - parameter newValue: the new quota value
     - parameter reason:   the adjustment reason
     - parameter delegate: the delegate of REST Api
     */
    func requestQuotaAdjustment(quota: CaneQuota, newValue: Int, reason: String, delegate: RESTQuotaDelegate) throws
    {
        let parameters:[String:AnyObject] = [
            "action": "Adjust",
            "response": "\(newValue)",
            "quotaid": Int(quota.id)!, // integer
            "reason_notes": reason,
            "quota_adjusted":newValue, //integer
            //"maingrowerid": quota.maingrowerid
        ]
        
        let request = createJsonRequestWithParams(.POST, endpoint: "quota", parameters: parameters, delegate: delegate)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            // check for key "apikey"
            if json["status"].stringValue == "Success" {
                delegate.quotaStatusChangeSucceed?()
            }
            else {
                delegate.requestFailedWithError(RESTError.Failure(message: json.description).error())
            }
            }, delegate: delegate)
    }
    
    
    /**
     Accept today quota
     
     - parameter quota:    the quota
     - parameter delegate: the delegate of REST Api
     */
    func acceptQuota(quota: CaneQuota, delegate: RESTQuotaDelegate) throws {
        let parameters:[String:AnyObject] = [
            "action": "Accept",
            "response": "\(quota.quota)",
            "quotaid": Int(quota.id)!, // integer
            //"reason": "",
            "quota_adjusted":0 //integer
            //"growerid": quota.maingrowerid
        ]
        
        let request = createJsonRequestWithParams(.POST, endpoint: "quota", parameters: parameters, delegate: delegate)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            // check for key "apikey"
            if json["status"].stringValue == "Success" {
                delegate.quotaStatusChangeSucceed?()
            }
            else {
                delegate.requestFailedWithError(RESTError.Failure(message: json.description).error())
            }
            }, delegate: delegate)
    }
    

    
    /**
    Get most recent quota value from the list of quotas
    
    - parameter list:     list of quotas from JSON reponse
    - parameter response: the JSON response
    
    - returns: the quota model object
    */
    private func getRecentQuotaValue(list: [JSON], _ response: JSON) -> CaneQuota? {
        var quotas = list
        if list.count > 0 {
            /**
            *  The sorting is added to fix sample response that currently has quotas sorted with wrong order.
            */
            quotas.sortInPlace({$0["datetimeupdated"].stringValue >= $1["datetimeupdated"].stringValue})
            if let json = quotas.first {
                let quota = CaneQuota(id: json["id"].string ?? json["id"].intValue.description,
                    status: CaneQuotaStatus(rawValue: json["status"].stringValue) ?? .Unconfirmed,
                    quota: json["quota"].intValue,
                    trucksIn: json["trucksin"].intValue,
                    maingrowerid: json["maingrowerid"].stringValue)
                quota.date = NSDate.parseFullDate(json["datetimeupdated"].stringValue)
                quota.almaEstimate = response["almaestimate"].intValue
                return quota
            }
        }
        return nil
    }
    
    // MARK: Cane Quality
    
    /**
     Fetch list quality
     
     - Parameters:
     - delegate: the delegate of REST Api
     */
    
    
    // For Post Query
    
   /* func fetchListQualityWithDelegate(growerid:String, delegate: RESTQualityDelegate) throws
    {
        
        struct Static {
            static var dateFormatter: NSDateFormatter = {
                let f = NSDateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                return f
            }()
        }

        
        let parameters = [
            "date": Static.dateFormatter.stringFromDate(NSDate()),
            "growerid": growerid
        ]

        
        let request = self.createJsonRequest(.POST, endpoint: "sampledata/query", parameters: parameters, delegate: delegate)
        
        try self.sendRequest(request) { json, error in
            // if there's an error
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    delegate.fetchListQualityFailedWithError?(error!.error())
                })
                return
            }
            
            let caneQuality = CaneQuality.caneQualityFromJSON(json!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                delegate.fetchListQualityWithData?(caneQuality)
            })
            
            
        }
    }*/
    
    // For Get
    
    func fetchListQualityWithDelegate(growerid:String, delegate: RESTQualityDelegate) throws
    {
        
        struct Static {
            static var dateFormatter: NSDateFormatter = {
                let f = NSDateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                return f
            }()
        }
        
        
        let parameters = [
            "date": Static.dateFormatter.stringFromDate(NSDate()),
            "growerid": growerid
        ]
        
        
        let request = self.createJsonRequest(.GET, endpoint: "sampledata", parameters: parameters, delegate: delegate)
        
        try self.sendRequest(request) { json, error in
            // if there's an error
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    delegate.fetchListQualityFailedWithError?(error!.error())
                })
                return
            }
            
            let caneQuality = CaneQuality.caneQualityFromJSON(json!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                delegate.fetchListQualityWithData?(caneQuality)
            })
            
            
        }
    }

    
    /**
     Create request for fetching list quality
     */
    
    // For Post Query
    
   /* func createFetchListQualityRequest() -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(Config.sharedInstance.getBaseUrl())/sampledata/query")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    } */
     
     // For Get
    
     func createFetchListQualityRequest() -> NSURLRequest {
     let request = NSMutableURLRequest(URL: NSURL(string: "\(Config.sharedInstance.getBaseUrl())/sampledata")!)
     request.HTTPMethod = "GET"
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     return request
     }
    
    
    // MARK: Update Device Token
    
    /**
    Update Device Token
    
    - Parameters:
    - delegate: the delegate of REST Api
    */
    func updateDeviceToken(devicetoken: String, andgrowerid growerid: String,
        withDelegate delegate: RESTDelegate) throws
    {
         let parameters = [
        "devicetoken": devicetoken,
        "growerid": growerid
        ]
        
        let request = createJsonRequest(.POST, endpoint: "device", parameters: parameters, delegate: delegate)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            
            print(json)
            
            //delegate.requestFailedWithError(RESTError.InvalidResponse.error())
            
            }, delegate: delegate)
    }
    
    
    // MARK: Settings Opt Out for Sample Notifications
    
    /**
    Update Settings PN's opt out for Sample Notifications
    
    - Parameters:
    - delegate: the delegate of REST Api
    */
    func updateSettingsOptOut(sampleoptin: String, andgrowerid growerid: String,
        withDelegate delegate: RESTDelegate) throws
    {
        let parameters = [
            "sampleoptin": sampleoptin,
            "growerid": growerid
        ]
        
        let request = createJsonRequest(.POST, endpoint: "settings", parameters: parameters, delegate: delegate)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            
            if json["status"].stringValue == "Success"
            {
                delegate.requestSucceedWithData()
            }
            else
            {
                delegate.requestFailedWithError(RESTError.InvalidResponse.error())

            }
            
            
            }, delegate: delegate)
    }


    
    // MARK: Settings Opt Out for Sample Notifications

    /**
     Get Settings
     
     - parameter growerid: the grower ID
     - parameter delegate: the delegate of REST Api
     */
    func getSettingsOptOut(growerid: String, delegate: RESTSettingsDelegate) throws {
        
        let parameters = [
            "growerid": growerid
        ]
        let request = createJsonRequest(.GET, endpoint: "settings", parameters: parameters, delegate: delegate)
        
        try self.sendRequestAndHandleError(request, success: { (json) -> () in
            
            if json["status"].stringValue == "Success" {
                delegate.settingsReceived(json["samplenotificationflag"].boolValue)
            }
            else {
                delegate.requestFailedWithError(RESTError.Failure(message: json.description).error())
            }
            }, delegate: delegate)
    }


    
}