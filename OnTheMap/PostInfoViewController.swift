//
//  PostInfoViewController.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/26/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var introLabel: UILabel!

    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var locationText: UITextField!
   
    @IBOutlet weak var bottomView: UIView!
   
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var mediaURL: UITextField!
    
    var lat = CLLocationDegrees()
    var long = CLLocationDegrees()
    var mapString: String?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.activitySpinner.isHidden = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyBoardTapped()
    }

    @IBAction func cancelAction(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        self.moveToSubmit(enable: false)
    }
    
    @IBAction func findOnMap(_ sender: Any) {
        
        guard locationText.text != "" else {
            self.alertBox(message: "Please enter a location text")
            return
        }
        
        if submitButton.titleLabel?.text != "Submit" {
            
            mapString = locationText.text!
            self.activitySpinner.isHidden = false
            self.activitySpinner.startAnimating()
            getGeoCode(address: mapString!)
            
            
        } else if let mediaURLString = mediaURL.text, mediaURL.text != "" && submitButton.titleLabel?.text == "Submit" {
            print(mediaURLString)
            
            UClient.sharedInstance().postToParse(mapString: self.mapString!, media: mediaURLString, latitude: self.lat, longitude: self.long) { (success, error) in
                
                DispatchQueue.main.async{
                    guard error == nil else{
                        self.alertBox(message: (error?.localizedDescription)!)
                        return
                    }
                    
                    if success == true {
                        self.dismiss(animated: true)
                    }
                    
                }
                
                
            }
        } else if mediaURL.text == "" {
            self.alertBox(message: "Please enter a URL")
        }

    }
    
    
    func moveToSubmit(enable : Bool){
        self.middleView.isHidden = enable
        self.introLabel.isHidden = enable
        if enable == true{
            self.activitySpinner.stopAnimating()
            self.bottomView.alpha = 0.4
            self.submitButton.setTitle("Submit", for: .normal)
        }else {
            self.bottomView.alpha = 1.0
            self.submitButton.setTitle("Find on Map", for: .normal)
        }
    }
    
    func getGeoCode(address: String) {
        let enteredAddress = address
        
        
        let geoCode = CLGeocoder()
        
        geoCode.geocodeAddressString(enteredAddress) { (results, error) in
            

            
            if let pinLocation = results?[0] {
                self.lat = (pinLocation.location?.coordinate.latitude)!
                self.long = (pinLocation.location?.coordinate.longitude)!
                self.mapView.showAnnotations([MKPlacemark(placemark: pinLocation)], animated: true)
                self.moveToSubmit(enable: true)
            } else if error != nil {
                self.alertBox(message: "Cannot find location")
            }
            
        }
    }
    
    
}
