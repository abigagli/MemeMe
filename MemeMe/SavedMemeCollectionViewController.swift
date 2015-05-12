//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 28/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class SavedMemeCollectionViewController: UICollectionViewController {
    
    //MARK: Outlets
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //MARK: State
    private var tabBarToolbarHeight: CGFloat = CGFloat(0)

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
        
        tabBarToolbarHeight = tabBarController!.tabBar.frame.size.height
        
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
    
    //MARK: Actions
    
    @IBAction func deleteSelectedCells(sender: UIBarButtonItem) {
        let selectedCellIndexPaths = collectionView!.indexPathsForSelectedItems() as! [NSIndexPath]
        
        var newSavedMemes: [Meme] = []
        
        for (index, meme) in enumerate(savedMemes) {
            if !contains(selectedCellIndexPaths, { $0.row == index }) {
                newSavedMemes.append(meme)
            }
        }
        
        savedMemes = newSavedMemes
        
        collectionView!.deleteItemsAtIndexPaths(selectedCellIndexPaths)
        navigationController!.setToolbarHidden(true, animated: true)

        if savedMemes.count == 0 {
            setEditing(false, animated: true)

            let nextController = UIAlertController(title: "Saved Memes", message: "No saved Memes, please create one", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title:"Ok, let me create one", style: .Default) {_ in self.performSegueWithIdentifier("CollectionViewToMemeEditor", sender: self)}
            nextController.addAction(okAction)
            presentViewController(nextController, animated: true, completion: nil)
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
        super.setEditing(editing, animated: animated)
        addButton.enabled = !editing
        
        collectionView!.allowsMultipleSelection = editing
        let visibleCellIndexPaths = collectionView!.indexPathsForVisibleItems() as! [NSIndexPath]
        
        for indexPath in visibleCellIndexPaths {
            collectionView!.deselectItemAtIndexPath(indexPath, animated: false)
            
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! SavedMemeCollectionViewCell
            
            cell.editing = editing
        }
        
        if editing {
            //Hide all toolbars when beginning editing
            tabBarController!.setToolbarHidden(true, animated: true)
            navigationController!.setToolbarHidden(true, animated: false)
        }
        else {
            //Replace navigation toolbar with the tabbar's one
            navigationController!.setToolbarHidden(true, animated: false)
            tabBarController!.setToolbarHidden(false, animated: true)
        }
        
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
        cell.editing = editing
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memedImage = savedMemes[indexPath.row].memedImage
        
        if !editing {
            //Hijack the sender argument to let prepareSegue access the memedImage without
            //having to add a property just for that...
            performSegueWithIdentifier("CollectionToDetail", sender: memedImage)
        }
        else {
            navigationController!.setToolbarHidden(false, animated: true)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            if collectionView.indexPathsForSelectedItems().count == 0 {
                navigationController!.setToolbarHidden(true, animated: true)
            }
        }
    }
}
