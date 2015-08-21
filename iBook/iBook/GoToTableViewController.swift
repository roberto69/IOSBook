//
//  GoToTableViewController.swift
//  iBook
//
//  Created by Guillaume on 20/08/2015.
//  Copyright (c) 2015 Guillaume. All rights reserved.
//

import UIKit
import CoreData

class GoToTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var TableArray = [ContentClass]()
    
    override func viewDidLoad() {
        getPages()
    }
    
    func getPages() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Element")
        request.returnsObjectsAsFaults = false
        
        var error: NSError?
        var results: NSArray = context.executeFetchRequest(request, error: &error)!
        
        if (results.count > 0) {
            for res in results {
                TableArray.append(ContentClass(title: res.valueForKey("title") as String, text: res.valueForKey("text") as String, url: res.valueForKey("url") as String))
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = TableArray[indexPath.row].title
        cell.detailTextLabel?.text = String(indexPath.row + 1)
        
        return cell
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("GoToTableView", sender: self)
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "changePage" {
            let goToVc:ViewController = segue.destinationViewController as ViewController
            
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            goToVc.viewRow = indexPath.row
        }
    }
}
