//
//  UStudents.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/21/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

struct StudentInformation {
    
    let objectId: AnyObject
    let uniqueKey: AnyObject
    let firstName: AnyObject
    let lastName: AnyObject
    let mapString: AnyObject
    let mediaURL: AnyObject
    let latitude: AnyObject
    let longitude: AnyObject
    let createdAt: AnyObject
    let updatedAt: AnyObject
    
    init(dictionary: [String: AnyObject]){
        
        objectId = dictionary["objectId"] as AnyObject
        uniqueKey = dictionary["uniqueKey"] as AnyObject
        firstName = dictionary["firstName"] as AnyObject
        lastName = dictionary["lastName"] as AnyObject
        mapString = dictionary["mapString"] as AnyObject
        mediaURL = dictionary["mediaURL"] as AnyObject
        latitude = dictionary["latitude"] as AnyObject
        longitude = dictionary["longitude"] as AnyObject
        createdAt = dictionary["createdAt"] as AnyObject
        updatedAt = dictionary["updatedAt"] as AnyObject
    

    }
    
    
    static func studentsFromResult(_ results: [[String: AnyObject]]) -> [StudentInformation]{
        
        var students = [StudentInformation]()
        
        for result in results {
            students.append(StudentInformation(dictionary: result))
        }
        
        return students
    }
    
    
}
