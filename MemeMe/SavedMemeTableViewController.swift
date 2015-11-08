//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeTableViewController: UITableViewController {
    
    //MARK: Outlets
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //MARK: Lifetime
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
    
    //MARK: Editing
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addButton.enabled = !editing
        
        
        if editing {
            tabBarController!.setToolbarHidden(true, animated: true)
        }
        else {
            tabBarController!.setToolbarHidden(false, animated: true)
        }
    }
}

//MARK: Protocol conformance
extension SavedMemeTableViewController
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
        if !editing {
            let memedImage = savedMemes[indexPath.row].memedImage
            
            //Hijack the sender argument to let prepareSegue access the memedImage without
            //having to add a property just for that...
            performSegueWithIdentifier("TableToDetail", sender: memedImage)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            savedMemes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            //If no more saved memes left, alert the user that we're gonna bring him to the meme editor
            if savedMemes.count == 0 {
                navigationController!.setToolbarHidden(true, animated: true)
                setEditing(false, animated: true)

                let nextController = UIAlertController(title: "Saved Memes", message: "No saved Memes, please create one", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title:"Ok, let me create one", style: .Default) {_ in self.performSegueWithIdentifier("TableViewToMemeEditor", sender: self)}
                nextController.addAction(okAction)
                presentViewController(nextController, animated: true, completion: nil)
               }
        }
    }
}

