//
//  APIController.swift
//  Catalyst
//
//  Created by Nicholas Villa on 2/11/15.
//  Copyright (c) 2015 Design9. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}



class APIController {
    
    var delegate: APIControllerProtocol?
    init() {
    }
    
    //function for getting nearby profiles
    // HTTP GET
    func get_nearby_profiles(#username: String) {
        // Start HTTP request for getting all profiles near nvilla
        let url = NSURL(string: "http://ec2-54-172-188-199.compute-1.amazonaws.com/catalyst/nearby_profiles/\(username)/")
        var request = NSURLRequest(URL:url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("request task completed!")
            if (error != nil) {
                println(error.localizedDescription)
            } else {
                //creating error object for json error
                var err: NSError?
                
                var result_array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSArray
                if(err != nil) {
                    println("JSON Error /(err!.localizedDescription")
                } else {
                    var jsonResult: NSDictionary = ["results": result_array]
                    self.delegate?.didReceiveAPIResults(jsonResult)
                }
            }
        })
        
        task.resume()
        
        
        
        println("request called")
    }
    
    
    
    func post(params : Dictionary<String, String>, url : String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            println(params)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["authentication"] as? NSString
                    println("Succes: \(success)")
                    self.delegate?.didReceiveAPIResults(json!)
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
    
}

