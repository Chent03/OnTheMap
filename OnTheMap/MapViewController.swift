//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/21/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var Ustudents = [UStudents]()
    var annotations = [MKPointAnnotation]()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let method = UClient.Methods.GETStudentLocation
        
        
        UClient.sharedInstance().loadStudentLocations(method: method) { (success, results, error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
//                    print("Login failed")
                    return
                }
                guard success == true else {
//                    print("Success was false")
                    return
                }
                

                if let students = results {
                    self.Ustudents = students
                }
                
                for student in self.Ustudents{
                    
                    self.pinLocations(student: student)
//                    print(student.latitude)
//                    print("HI")
                    
                }
                self.mapView.addAnnotations(self.annotations)
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func pinLocations(student: UStudents){
        
        
        guard student.latitude is Double else {
            return
        }
        
        guard student.longitude is Double else {
            return
        }
        
        guard student.firstName is String else {
            return
        }
        
        guard student.lastName is String else {
            return
        }
        
        let lat = CLLocationDegrees(student.latitude as! Double)
        let long = CLLocationDegrees(student.longitude as! Double)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
        let first = student.firstName as! String
        let last = student.lastName as! String
        let mediaURL = student.mediaURL as! String
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first)\(last)"
        annotation.subtitle = mediaURL
            
        annotations.append(annotation)

        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reusedId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusedId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusedId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                
                let link = URL(string: toOpen)
                
                app.open(link!, options: [:], completionHandler: nil)
                
//                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func logingOut(_ sender: UIBarButtonItem) {
        UClient.sharedInstance().logout() { (success, error) in
            
            
            DispatchQueue.main.async{
                guard error == nil else{
//                    print("logout failed")
                    return
                }
                
                if success == true {
                    self.dismiss(animated: true)
                }
                
            }
            
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        
        let method = UClient.Methods.GETStudentLocation
        
        
        UClient.sharedInstance().loadStudentLocations(method: method) { (success, results, error) in
            
            DispatchQueue.main.async {
                guard error == nil else {
//                    print("Login failed")
                    return
                }
                guard success == true else {
//                    print("Success was false")
                    return
                }
                
                
                if let students = results {
                    self.Ustudents = students
                }
                
                for student in self.Ustudents{
                    
                    self.pinLocations(student: student)
                    
                }
                self.mapView.addAnnotations(self.annotations)
                
            }
        }
        
    }
    
    


}
