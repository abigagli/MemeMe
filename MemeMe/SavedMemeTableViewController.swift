//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeTableViewController: UITableViewController {
    
    //MARK:State
    
    //A computed property that simply relates to the actual storage in AppDelegate
    var savedMemes: [Meme]! {
        get {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.savedMemes
        }
        set {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.savedMemes = newValue
        }
    }

    //MARK: Lifetime
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        /*
        tabBarController!.tabBar.frame = CGRectZero
        tabBarController!.tabBar.hidden = true
        navigationController!.toolbarHidden = false
        
        self.navigationItem.title = "HIDING TAB TOOLBAR"
        */
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if savedMemes.count == 0 {
            performSegueWithIdentifier("TableViewToMemeEditor", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TableToDetail" {
            let detailViewController = segue.destinationViewController as! MemeDetailViewController
            detailViewController.memedImage = sender as? UIImage
        }
    }
}

//MARK: Protocol conformance
extension SavedMemeTableViewController : UITableViewDataSource, UITableViewDelegate
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SavedMemeTableViewCell") as! SavedMemeTableViewCell
        let meme = savedMemes[indexPath.row]
        
        cell.meme = meme
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memedImage = savedMemes[indexPath.row].memedImage
        
        //Hijack the sender argument to let prepareSegue access the memedImage without 
        //having to add a property just for that...
        performSegueWithIdentifier("TableToDetail", sender: memedImage)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            savedMemes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            //If no more saved memes left, alert the user that we're gonna bring him to the meme editor
            if savedMemes.count == 0 {
                
                let nextController = UIAlertController(title: "Saved Memes", message: "No saved Memes, please create one", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title:"Ok, let me create one", style: .Default) {_ in self.performSegueWithIdentifier("TableViewToMemeEditor", sender: self)}
                nextController.addAction(okAction)
                presentViewController(nextController, animated: true, completion: nil)
               }
        }
    }
}
