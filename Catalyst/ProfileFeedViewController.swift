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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.profile_feed.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.api.delegate = self
        
        api.get_nearby_profiles(username:"nvilla")
        
        
        
    }
    
    //get and use results from api call
    func didReceiveAPIResults(results: NSDictionary) {
        println("Received API Results")
        var result_array: NSArray = results["results"] as NSArray
        
        var ib1: String = result_array[0]["info_blurb"] as String
        
        println("First infoblurb is \(ib1)")
        
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
        var cell: UITableViewCell = profile_feed.dequeueReusableCellWithIdentifier("profile_feed_cell") as UITableViewCell
        
        if let ib_label = cell.viewWithTag(102) as? UILabel {
            ib_label.text = self.table_data[indexPath.row]["info_blurb"] as? String
        }
        if let thumbnail = cell.viewWithTag(104) as? UIImageView {
            //grab the image url from json object for thumbnail image
            let urlString: String = self.table_data[indexPath.row]["pic_url"] as String
            let imgURL: NSURL? = NSURL(string: urlString)
            
            // Download an NSData representation of the image at the url
            let imgData = NSData(contentsOfURL:imgURL!)
            
            thumbnail.image = UIImage(data: imgData!)
        } else {
            println("error getting thumbnail")
        }
        
        return cell
    }
    
    func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Cell #\(indexPath.row)! was selected")
    }
}

