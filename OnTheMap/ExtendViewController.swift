//
//  ExtendViewController.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/28/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alertBox(message: String){
        let alertCtrl = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertCtrl.addAction(confirm)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
}
