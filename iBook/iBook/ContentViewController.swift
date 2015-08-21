//
//  ContentViewController.swift
//  iBook
//
//  Created by Guillaume on 19/08/2015.
//  Copyright (c) 2015 Guillaume. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var textItem: UITextView!
    @IBOutlet weak var webContent: UIWebView!
    
    var pageIndex: Int?
    var contentItem: ContentClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.heading.text = self.contentItem.title
        
        
        if (self.contentItem.url != "") {
            textItem.hidden = true
            webContent.hidden = false
            let url = NSURL (string: self.contentItem.url);
            let requestObj = NSURLRequest(URL: url!);
            webContent.loadRequest(requestObj);
        }
        else {
            textItem.hidden = false
            webContent.hidden = true
            self.textItem.text = self.contentItem.text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
