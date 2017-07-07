//
//  ExtendViewController.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/28/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//


import Foundation
import UIKit

extension UIViewController {
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func alertBox(message: String){
        let alertCtrl = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertCtrl.addAction(confirm)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    func hideKeyBoardTapped(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
