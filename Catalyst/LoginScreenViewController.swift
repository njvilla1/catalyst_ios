//
//  LoginScreenViewController.swift
//  Catalyst
//
//  Created by Tyler Hessler on 2/18/15.
//  Copyright (c) 2015 Design9. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        println("Testing, new class worked")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let username = usernameField.text
        let destinationVC = segue.destinationViewController as ProfileFeedViewController
        destinationVC.username = username
        
    }
   
}
