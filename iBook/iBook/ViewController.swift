//
//  ViewController.swift
//  iBook
//
//  Created by Guillaume on 19/08/2015.
//  Copyright (c) 2015 Guillaume. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIPageViewControllerDataSource, PopUpViewControllerDelegate {

    var pageViewController: UIPageViewController!
    var pageTitle = [ContentClass]()
    var viewRow = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (retPages() == 0){
            addNewPage(ContentClass(title: "My Book", text: "Click on add button to create your own book", url: ""))
        }
        
        getPages()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
        
        self.pageViewController.dataSource = self
        
        var startVC = self.viewControllerAtIndex(viewRow) as ContentViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //create new contentViewController and assign title
    func viewControllerAtIndex(index: Int) -> ContentViewController
    {
        if ((self.pageTitle.count == 0) || (index >= self.pageTitle.count)) {
            return ContentViewController()
        }
        
        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as ContentViewController
        
        vc.contentItem = self.pageTitle[index] as ContentClass
        vc.pageIndex = index
        
        return vc
    }

    //Mark Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as ContentViewController
        var index = vc.pageIndex as Int?
        
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        
        index!--
        return self.viewControllerAtIndex(index!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as ContentViewController
        var index = vc.pageIndex as Int?
        
        if (index == NSNotFound) {
            return nil
        }
        
        index!++
        
        if (index == self.pageTitle.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index!)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitle.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PopUpViewController" {
            let popUpVc:PopUpViewController = segue.destinationViewController as PopUpViewController
            popUpVc.delegate = self
        }
    }
    
    //calculate pages
    func retPages() -> Int {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Element")
        request.returnsObjectsAsFaults = false
        
        var error: NSError?
        var results: NSArray = context.executeFetchRequest(request, error: &error)!
        var count: Int = 0
        
        if (results.count > 0) {
            for res in results {
                count++
            }
        }
        return count
    }
    
    //get all pages and assign to a list
    func getPages() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Element")
        request.returnsObjectsAsFaults = false
        
        var error: NSError?
        var results: NSArray = context.executeFetchRequest(request, error: &error)!
        
        if (results.count > 0) {
            for res in results {
                pageTitle.append(ContentClass(title: res.valueForKey("title") as String, text: res.valueForKey("text") as String, url: res.valueForKey("url") as String))
            }
        }
    }
    
    //add a new page to a list and Core Data
    func addNewPage(didAddItem: ContentClass) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Element", inManagedObjectContext: context)
        let newPage = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        
        newPage.setValue(didAddItem.title, forKey: "title")
        newPage.setValue(didAddItem.text, forKey: "text")
        newPage.setValue(didAddItem.url, forKey: "url")
        
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        context.save(nil)
        pageTitle.append(didAddItem)
    }    
}

