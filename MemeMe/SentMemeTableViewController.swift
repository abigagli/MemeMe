//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UIViewController {
    
    var savedMemes: [Meme]!

    @IBOutlet weak var tableView: UITableView!
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SentMemeTableViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SavedMemeTableViewCell") as! UITableViewCell
        let meme = savedMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.originalImage
        
        return cell
    }
    
    /*

func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController")! as! VillainDetailViewController
detailController.villain = self.allVillains[indexPath.row]
self.navigationController!.pushViewController(detailController, animated: true)

}
*/
}
