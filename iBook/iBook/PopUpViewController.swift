//
//  PopUpViewController.swift
//  iBook
//
//  Created by Guillaume on 19/08/2015.
//  Copyright (c) 2015 Guillaume. All rights reserved.
//

import UIKit

protocol PopUpViewControllerDelegate {
    func addNewPage(didAddItem: ContentClass)
}

class PopUpViewController: UIViewController {

    @IBOutlet weak var titleContent: UITextField!
    @IBOutlet weak var textContent: UITextView!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var labelText: UILabel!
    var contentItem: ContentClass!
    @IBOutlet weak var urlContent: UITextField!
    @IBOutlet weak var LabelTitle: UILabel!
    
    var delegate: PopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlContent.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create(sender: AnyObject) {
        
        if (self.textContent.text == "" && self.urlContent.text == ""){
            labelText.textColor = UIColor.redColor()
        }
        else {
            labelText.textColor = UIColor.blackColor()
        }
        
        if (self.titleContent.text == ""){
            LabelTitle.textColor = UIColor.redColor()
        }
        else{
            LabelTitle.textColor = UIColor.blackColor()
        }
        
        if ((self.textContent.text != "" || self.urlContent.text != "") && self.titleContent.text != ""){
            if let delegate = self.delegate {
                if (self.urlContent.text != ""){
                    let re = NSRegularExpression(pattern: "(?i)https?:\\/.*", options: nil, error: nil)!
                    if (re.firstMatchInString(self.urlContent.text, options: nil, range: NSRange(location: 0, length: self.urlContent.text.utf16Count)) == nil) {
                        labelText.textColor = UIColor.redColor()
                    }
                    else {
                        contentItem = ContentClass(title: self.titleContent.text, text: self.textContent.text, url: self.urlContent.text)
                        delegate.addNewPage(contentItem)
                        self.navigationController?.popViewControllerAnimated(true)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }else {
                    contentItem = ContentClass(title: self.titleContent.text, text: self.textContent.text, url: self.urlContent.text)
                    delegate.addNewPage(contentItem)
                    self.navigationController?.popViewControllerAnimated(true)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func switchWebText(sender: AnyObject) {
        if (self.buttonText.titleLabel?.text == "Web") {
            self.buttonText.setTitle("Text", forState: .Normal)
            self.labelText.text = "Web"
            self.textContent.hidden = true
            self.textContent.text = ""
            self.urlContent.placeholder = "Enter an url"
            self.urlContent.hidden = false
            self.textContent.hidden = true
            labelText.textColor = UIColor.blackColor()
            LabelTitle.textColor = UIColor.blackColor()
        }
        else {
            self.buttonText.setTitle("Web", forState: .Normal)
            self.labelText.text = "Text"
            self.textContent.hidden = false
            self.textContent.text = ""
            self.urlContent.hidden = true
            self.urlContent.text = ""
            labelText.textColor = UIColor.blackColor()
            LabelTitle.textColor = UIColor.blackColor()
        }
    }
}
