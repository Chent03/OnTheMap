//
//  UConstants.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/19/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

extension UClient {
    
    struct Constants{
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
    }
    
    struct Methods {
        
        static let Udacitylink = "https://www.udacity.com"
        static let SessionMethod = "https://www.udacity.com/api/session"
        static let GETUserInfo = "https://www.udacity.com/api/users/"
        static let GETStudent = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100"
        static let GETStudentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
        
    }
    
    struct UParameterKeys {
        static let SessionID = "session"
        static let Limit = "limit"
        static let Skip = "skip"
        static let Prder = "order"
    }
    
    struct JSONResponseKeys {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let ACL = "ACL"
    }
}
