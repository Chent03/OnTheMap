//
//  ViewController.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/19/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginPressed(_ sender: UIButton){
        
        guard let email = emailTextField.text else {
//            print("No email entered")
            return
        }
        
        guard let password = passwordTextField.text else {
//            print("No password entered")
            return
        }
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            self.alertBox(message: "Enter Credentials")
        } else {
            
            print(email)
            print(password)
            UClient.sharedInstance().loginUdacity(email: email, password: password){ (success, results, error) in
                DispatchQueue.main.async {
                    guard error == nil else {
//                        print("Login failed")
                        self.alertBox(message: "Incorrect email and/or password.")
                        return
                    }
                    guard success == true else {
//                        print("Success was false")
                        return
                    }
                    self.completeLogin()
                    
                }
            }
        }
        
        
    }
    
    private func completeLogin(){
        performUIUpdatesOnMain {
            self.setUIEnabled(true)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func signup(_ sender: UIButton){
        
        let url = URL(string: UClient.Methods.Udacitylink)
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        
    }
    


}


private extension LoginViewController {
    func setUIEnabled(_ enabled: Bool){
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5

        }
    }
    
}
