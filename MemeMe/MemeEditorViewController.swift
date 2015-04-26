//
//  ViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 26/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

protocol ObservableUIImageViewDelegate
{
    func imageDidSet(image: UIImage?)
}
class ObservableUIImageView : UIImageView
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
    var observer : ObservableUIImageViewDelegate?
}


class MemeEditorViewController: UIViewController {
    
    //MARK: State
    private enum WhichField {
        case none
        case top
        case bottom
    }
    
    private var fieldBeingEdited : WhichField = .none
    
    //MARK: Outlets 
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: ObservableUIImageView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    //MARK: Actions
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

    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.observer = self
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        topTextField.sizeToFit()
        bottomTextField.sizeToFit()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Business logic
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow (notification: NSNotification) {
        if fieldBeingEdited == .bottom {
            let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            view.frame.origin.y -= keyboardSize.CGRectValue().height
        }
    }
    
    func keyboardWillHide (notification: NSNotification) {
        if fieldBeingEdited == .bottom {
            let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
            view.frame.origin.y += keyboardSize.CGRectValue().height
        }
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

extension MemeEditorViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text.isEmpty {
            textField.text = textField == topTextField ? "TOP" : "BOTTOM"
        }
        textField.resignFirstResponder()
        fieldBeingEdited = .none
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topTextField {
            fieldBeingEdited = .top
            if textField.text == "TOP" {
                textField.text = ""
            }
        }
        else if textField == bottomTextField {
            fieldBeingEdited = .bottom
            if textField.text == "BOTTOM" {
            textField.text = ""
            }
        }
        
    }
}

extension MemeEditorViewController: ObservableUIImageViewDelegate
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
