//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewController: UICollectionViewController {
    
    //MARK: State
    var editingCells = false
    
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
        
        collectionView!.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if savedMemes.count == 0 {
            performSegueWithIdentifier("CollectionViewToMemeEditor", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateCellFrame(collectionView!.frame.size)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CollectionToDetail" {
            let detailViewController = segue.destinationViewController as! MemeDetailViewController
            detailViewController.memedImage = sender as? UIImage
        }
    }
    
    //MARK: UI Layout
    private func updateCellFrame(forViewSize: CGSize) {
        let width = (forViewSize.width - 8) / 3.0
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    //MARK: Editing
    override func setEditing(editing: Bool, animated: Bool) {
        editingCells = true
    }
}

//MARK: Protocol conformance
extension SavedMemeCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate
{
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SavedMemeCollectionViewCell", forIndexPath: indexPath) as! SavedMemeCollectionViewCell
        
        let meme = savedMemes[indexPath.row]
        
        cell.meme = meme
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memedImage = savedMemes[indexPath.row].memedImage
        
        //Hijack the sender argument to let prepareSegue access the memedImage without 
        //having to add a property just for that...
        performSegueWithIdentifier("CollectionToDetail", sender: memedImage)
    }
}
