//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeTableViewController: UITableViewController {
    
    //@IBOutlet weak var tableView: UITableView!
    
    var savedMemes: [Meme]! {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.savedMemes
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
}
