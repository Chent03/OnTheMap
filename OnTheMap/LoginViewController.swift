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
    
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    override func viewWillAppear(_ animated: Bool) {
        self.activityViewToggle(isON: false)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyBoardTapped()
    }
    
    @IBAction func loginPressed(_ sender: UIButton){
        
        
        self.activityViewToggle(isON: true)
    
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            self.alertBox(message: "Enter Credentials")
            self.activityViewToggle(isON: false)
        } else {
            
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            UClient.sharedInstance().loginUdacity(email: email, password: password){ (success, results, error) in
                DispatchQueue.main.async {
                    
                    
                    guard error == nil else {
                        self.alertBox(message: (error?.localizedDescription)!)
                        self.activityViewToggle(isON: false)
                        return
                    }
                    
                    if success {
                        self.completeLogin()
                        self.activityViewToggle(isON: false)
                    }
                    
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
    
    private func activityViewToggle(isON: Bool){
        if isON{
            self.activityView.isHidden = false
            self.activityView.startAnimating()
        }else {
            self.activityView.isHidden = true
            self.activityView.stopAnimating()
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
