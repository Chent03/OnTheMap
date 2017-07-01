//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Tony Chen on 6/25/17.
//  Copyright © 2017 Tony Chen. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    var Ustudents: [UStudents] = [UStudents]()
    
    @IBOutlet weak var addPin: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet var studentView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let method = UClient.Methods.GETStudent
        
        UClient.sharedInstance().loadStudentLocations(method: method){ (success, results, error) in
        
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Login failed")
                    return
                }
                guard success == true else {
                    print("Success was false")
                    return
                }
                
                if success {
                    self.Ustudents = results!
                    self.studentView.reloadData()

                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

extension StudentTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "StudentTableViewCell"
        let individuals = Ustudents[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell?.imageView!.image = UIImage(named: "icon_pin")

        
        guard individuals.firstName is String else {
            return cell!
        }
        
        guard individuals.lastName is String else {
            return cell!
        }
        
        
        cell?.textLabel!.text = (individuals.firstName as! String) + " " + (individuals.lastName as! String)
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Ustudents.count)
        return Ustudents.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let individual = Ustudents[(indexPath as NSIndexPath).row]
        
        guard individual.mediaURL is String else {
            return
        }
        
        let url = URL(string: individual.mediaURL as! String)
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func logingOut(_ sender: UIBarButtonItem) {
        UClient.sharedInstance().logout() { (success, error) in
            
            
            DispatchQueue.main.async{
                guard error == nil else{
                    print("logout failed")
                    return
                }
                
                if success == true {
                    self.dismiss(animated: true)
                }
                
            }
            
        }
    }
    
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        
        let method = UClient.Methods.GETStudent
        
        UClient.sharedInstance().loadStudentLocations(method: method){ (success, results, error) in
            
            
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Login failed")
                    return
                }
                guard success == true else {
                    print("Success was false")
                    return
                }
                
                if success {
                    self.Ustudents = results!
                    self.studentView.reloadData()
                    
                }
                
            }
        }
        
        
    }
}
