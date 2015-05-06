//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var savedMemes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        savedMemes = appDelegate.savedMemes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if savedMemes.count == 0 {
            self.tabBarController!.performSegueWithIdentifier("SegueToMemeEditor", sender: self)
        }
        else {
            tableView.reloadData()
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SavedMemeTableViewCell") as! SavedMemeTableViewCell
        let meme = savedMemes[indexPath.row]
        
        // Set the name and image
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.myImageView.image = meme.memedImage
        
        return cell
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memedImage = savedMemes[indexPath.row].memedImage
        
        //Hijack the sender argument to let prepareSegue access the memedImage without 
        //having to add a property just for that...
        performSegueWithIdentifier("TableToDetail", sender: memedImage)
    }
}
