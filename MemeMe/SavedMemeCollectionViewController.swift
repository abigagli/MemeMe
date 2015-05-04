//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
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
        
        if savedMemes.count == 0 {
            
            let memeEditorNav = storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNav") as! UINavigationController
            presentViewController(memeEditorNav, animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if savedMemes.count == 0 {
            self.tabBarController!.performSegueWithIdentifier("SegueToMemeEditor", sender: self)
        }
        else {
            collectionView.reloadData()
        }
    }
}

//MARK: Protocol conformance
extension SavedMemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SavedMemeCollectionViewCell", forIndexPath: indexPath) as! SavedMemeCollectionViewCell
        
        let meme = savedMemes[indexPath.row]
        //cell.myImageView.image = meme.memedImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.backgroundView = UIImageView(image: meme.originalImage)
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.memedImage = savedMemes[indexPath.item].memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
