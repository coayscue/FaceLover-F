//
//  ViewController.swift
//  FaceLover
//
//  Created by Christian Ayscue on 4/1/15.
//  Copyright (c) 2015 christianayscue. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var clicks = 0
    var loverIDs: [String] = []

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonClicked(sender: AnyObject) {
        //incr clicks
        clicks++
        //first time through, get user's lovers, and display the first lover
        if clicks == 1{
            //change labels
            topLabel.text = "Lover #\(clicks):"
            button.setTitle("Next Lover", forState: UIControlState.Normal)
            var url = NSURL(string: "https://www.facebook.com/home.php")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!){
                (data, response, error) in
                if error == nil{
                    //get the content of the site
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)
                    
                    //parse the html to retrieve the usernumbers
                    var components = urlContent!.componentsSeparatedByString("InitialChatFriendsList\",[],{\"list\":[\"")
                    var nextString = components[1] as NSString
                    //separates the id numbers
                    components = nextString.componentsSeparatedByString("\",\"")
                    for (var i = 0; i<30; i++){
                        var idNumber = components[i] as NSString
                        //cuts the -2 off the end of the id
                        let idString = idNumber.substringToIndex(idNumber.length-2)
                        self.loverIDs.append(idString)
                    }
                    println(self.loverIDs)
                    
                    //load the first lover
                    var url = NSURL(string: "https://www.facebook.com/\(self.loverIDs[0])")
                    var request = NSURLRequest(URL: url!)
                    self.webView.loadRequest(request)
                    
                }
            }
            task.resume()
        }else{
            //changes the top label
            topLabel.text = "Lover #\(clicks):"
            //load the next lover
            var url = NSURL(string: "https://m.facebook.com/\(self.loverIDs[clicks-1])")
            var request = NSURLRequest(URL: url!)
            self.webView.loadRequest(request)
            if clicks == 30{
                clicks = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL(string: "https://www.facebook.com")
        var request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

