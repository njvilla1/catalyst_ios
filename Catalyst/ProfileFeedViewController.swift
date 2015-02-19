//
//  ViewController.swift
//  Catalyst
//
//  Created by Nicholas Villa on 2/11/15.
//  Copyright (c) 2015 Design9. All rights reserved.
//

import UIKit


class ProfileFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol{
    
    @IBOutlet weak var profile_feed: UITableView!
    
    var api = APIController()
    var table_data = []
    
    var username = ""
    
    //Image cache dictionary
    var imageCache = [String : UIImage]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.profile_feed.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.api.delegate = self
        
        api.get_nearby_profiles(username:username)
        
        
        
    }
    
    //get and use results from api call
    func didReceiveAPIResults(results: NSDictionary) {
        println("Received API Results")
        var result_array: NSArray = results["results"] as NSArray
        
        dispatch_async(dispatch_get_main_queue(), {
            self.table_data = result_array
            self.profile_feed!.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.table_data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("The cell \(indexPath.row) is being reloaded")
        
        var cell: UITableViewCell = profile_feed.dequeueReusableCellWithIdentifier("profile_feed_cell") as UITableViewCell
        
        var rowData: NSDictionary = self.table_data[indexPath.row] as NSDictionary
        
        //Get image from image cache. If it doesn't exist, download image asynchronously
        var image = self.imageCache[rowData["pic_url"] as String]
        if (image == nil) {
            //if the image does not exist, we need to download it
            var imgURL: NSURL = NSURL (string:rowData["pic_url"] as String)!
            
            //Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error == nil {
                    image = UIImage(data: data)
                    
                    //store the image into our cache
                    self.imageCache[rowData["pic_url"] as String] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = self.profile_feed.cellForRowAtIndexPath(indexPath) {
                            if let thumbnail = cellToUpdate.viewWithTag(104) as? UIImageView {
                                thumbnail.image = image
                            }
                        }
                    })
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        } else {
            //the image already exists in the cache, use the "image" variable
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = self.profile_feed.cellForRowAtIndexPath(indexPath) {
                    if let thumbnail = cellToUpdate.viewWithTag(104) as? UIImageView {
                        thumbnail.image = image
                    }
                }
            })
        }
        if let ib_label = cell.viewWithTag(102) as? UILabel {
            ib_label.text = self.table_data[indexPath.row]["info_blurb"] as? String
        }
                return cell
    }
    
    func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Cell #\(indexPath.row)! was selected")
    }
}

