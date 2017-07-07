//
//  UClient.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/19/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import Foundation

class UClient : NSObject {
    
    
    var requestToken: String?
    var sessionNum: String?
    var userID: String?
    var firstName: String?
    var lastName: String?
    
    func taskforPOSTMethod(_ request: NSMutableURLRequest, completionHandlerForPost:
        @escaping (_ success: Bool?,_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        print(request)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(false, nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
            
            guard(error == nil) else {
                sendError("There was an error in retrieving account. Please check internet connection")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Please check your internet connection")
                return
            }
            
            print(statusCode)
            
            if statusCode == 400 || statusCode == 403 {
                sendError("Re-enter credentials")
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForPost)
        }
        
        task.resume()
        
        return task
    }
    
    func logout(completionHandlerForDelete: @escaping (_ result: Bool, _ error: NSError?)-> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDelete(false, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            guard(error == nil) else {
                sendError("There was an error with the request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else{
                sendError("No data was returned by the request")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            completionHandlerForDelete(true, nil)
            
        }
        task.resume()
    }
    
    func taskforGET(_ request: NSMutableURLRequest, completiongHandlerGET: @escaping (_ success: Bool?, _ results: AnyObject?, _ error: NSError?)-> Void ) -> URLSessionDataTask {
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                completiongHandlerGET(false, nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard(error == nil) else {
                sendError("There was an error with the request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else{
                sendError("No data was returned by the request")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completiongHandlerGET)

        }
        task.resume()
        return task

    }
    
    func taskforGETMethod(_ method: String, completionHandlerForGET: @escaping (_ success: Bool?, _ result: AnyObject?, _ error: NSError?)-> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: URL(string: method)!)
        
        request.addValue(UClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        
        request.addValue(UClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String){
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(false, nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard(error == nil) else {
                sendError("There was an error with the request")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else{
                sendError("No data was returned by the request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        task.resume()
        
        return task
    }
    
    private func URLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL{
        
        var components = URLComponents()
        components.scheme = UClient.Constants.ApiScheme
        components.host = UClient.Constants.ApiHost
        components.path = UClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }


    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ success: Bool?, _ result: AnyObject?, _ error: NSError?) -> Void){
        var parsedResult: AnyObject! = nil
        do{
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not par the data as JSON: '\(data)'"]
            completionHandlerForConvertData(false, nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(true, parsedResult, nil)
    }
    
    
    class func sharedInstance() -> UClient {
        struct Singleton {
            static var sharedInstance = UClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
    
}
