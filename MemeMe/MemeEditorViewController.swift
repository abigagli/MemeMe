//
//  ViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 26/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            cameraButton.enabled = true
        }
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


extension MemeEditorViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
