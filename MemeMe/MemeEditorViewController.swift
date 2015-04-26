//
//  ViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 26/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

protocol observableUIImageViewDelegate
{
    func imageDidSet(image: UIImage?)
}
class observableUIImageView : UIImageView
{
    override var image : UIImage? {
        get {
            return super.image
        }
        
        set {
            super.image = newValue
            observer?.imageDidSet(image)
        }
            
    }
    var observer : observableUIImageViewDelegate?
}


class MemeEditorViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: observableUIImageView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.observer = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func chooseImage(sender: UIBarButtonItem) {
        var pickerViewController = UIImagePickerController()
        if sender.title != nil {
            pickerViewController.sourceType = .PhotoLibrary
        }
        else {
             pickerViewController.sourceType = .Camera
        }
        
        pickerViewController.delegate = self
        presentViewController (pickerViewController, animated: true, completion: nil)
    }

}

extension MemeEditorViewController: observableUIImageViewDelegate
{
    func imageDidSet(image: UIImage?) {
        if (image != nil) {
            self.navigationItem.leftBarButtonItem!.enabled = true
        }
        else {
            self.navigationItem.leftBarButtonItem!.enabled = false
        }
    }
}

extension MemeEditorViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* Enable this if you want to remove previously picked image every time you cancel out of pickerViewController
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imageView.image = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    */
}
