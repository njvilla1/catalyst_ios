//
//  LoginScreenViewController.swift
//  Catalyst
//
//  Created by Tyler Hessler on 2/18/15.
//  Copyright (c) 2015 Design9. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController, APIControllerProtocol {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        println("Testing, new class worked")
        
    }
    
    //get and use results from api call
    func didReceiveAPIResults(results: NSDictionary) {
        println("Received API Results")
        
        if (results["authentication"] as NSString == "success") {
            println("we made it to the delegate callback function, result is success")
            println("go to profile feed, authentication successful")
            //segue goes here
            performSegueWithIdentifier("loginSegue", sender: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        println("login button clicked")
        username = usernameField.text
        println("Username is: \(username)")
        
        let password = passwordField.text
        println("Password is:\(password)")
        
        let apicontroller = APIController()
        apicontroller.post(["username":username, "password":password, "userLatitude":"0.0", "userLongitude":"0.0"], url: "http://ec2-54-172-188-199.compute-1.amazonaws.com/catalyst/login/")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let destinationVC = segue.destinationViewController as ProfileFeedViewController
        destinationVC.username = username
        
    }
   
}
