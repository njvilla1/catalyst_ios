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
}

