//
//  Uconvenience.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/21/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import Foundation
import UIKit


extension UClient {
    
    
    func postToParse(mapString: String, media: String, latitude: Double, longitude: Double, completionHandlerForPOSTING: @escaping(_ success: Bool, _ errorString: NSError?) -> Void) {
        
        let uniqueKey = self.userID!
        let first = self.firstName!
        let last = self.lastName!
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(Constants.ApplicationID , forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(first)\", \"lastName\": \"\(last)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(media)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        print(jsonBody)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error ) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOSTING(false, NSError(domain: "postToParse", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError("Error in retrieving")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
            
            completionHandlerForPOSTING(true, nil)
            
            
        }
        task.resume()
        
    }
    
    func loginUdacity(email: String, password: String, completionHandlerForSessionID: @escaping(_ success: Bool, _ requestSession: String?, _ errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"

        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
        
        let _ = taskforPOSTMethod(request){ (success, results, error) in
        
            if let error = error {
                print(error)
                completionHandlerForSessionID(false, nil, "Login Failed(Session_ID)")
            } else {
                
                guard let accountResult = results?["account"] as? [String:AnyObject] else {
                    print("Can't get account results")
                    return
                }
                guard let sessionResult = results?["session"] as? [String:AnyObject] else {
                    print("Can't get session result")
                    return
                }
                
                guard let accountKey = accountResult["key"] as? String else {
                    print("No key")
                    return
                }
                
                self.userID = accountKey
                
                self.loadUserProfile()
                
                
                if let sessionID = sessionResult["id"] as? String {
                    self.sessionNum = sessionID
                    print(self.sessionNum!)
                    completionHandlerForSessionID(true, sessionID, nil)
                } else {
                    print("Could not find id key")
                    completionHandlerForSessionID(false, nil, "Login Failed")
                }
            }
        }
    }
    
    
    func loadUserProfile(){
        let requst = NSMutableURLRequest(url: URL(string: Methods.GETUserInfo + self.userID!)!)
        
        self.taskforGET(requst) { (success, result, error) in
            guard error == nil else{
                print("error in getting profile")
                return
            }
            
            guard let profile = result?["user"] as? [String:AnyObject] else {
                print("Can't get account user")
                return
            }
            
            if let first = profile["first_name"] as? String, let last = profile["last_name"] as? String{
                self.firstName = first
                self.lastName = last
                
            } else {
                print("Missing")
            }
            
    
        
        
        }
        
        
    }
    
    
    func loadStudentLocations(method: String, completionHandlerForLocations: @escaping(_ success: Bool , _ studentLocations: [UStudents]?, _ errorString: String?) -> Void) {
    
        
        let _ = taskforGETMethod(method) { (success, results, error) in
            
            if let error = error {
                print(error)
                completionHandlerForLocations(false, nil, "Couldn't get data")
            } else {
                
                if let results = results?["results"] as? [[String:AnyObject]]{
                    
                    let students = UStudents.studentsFromResult(results)
//                    print(students)
                    completionHandlerForLocations(true, students, nil)
                    
                } else{
                    completionHandlerForLocations(false, nil, "Failed to get data")
                }
                
            }
        }
        
    }
}
