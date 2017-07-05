//
//  UStudent.swift
//  OnTheMap
//
//  Created by Tony Chen on 7/3/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import MapKit
import Foundation


class UStudent : NSObject {
    
    var studentInformation = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    
    class func sharedInstance() -> UStudent {
        struct Singleton {
            static var sharedInstance = UStudent()
        }
        return Singleton.sharedInstance
    }
    
    
    
}
