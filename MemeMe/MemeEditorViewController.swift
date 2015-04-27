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
        didSet {
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
    
    private var fieldBeingEdited: WhichField = .none
    private var memedImage: UIImage?
    
    //MARK: Outlets 
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: ObservableUIImageView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
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

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        memedImage = memeizeImage(imageView.image!)
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = activityCompletedHandler
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    @IBAction func cancelMemeEditing(sender: UIBarButtonItem) {
        stopTextEditing()
    }
    
    func activityCompletedHandler (activity: String!,  completed: Bool, returnedItems: [AnyObject]!, activityError: NSError!) -> Void {
        
        if completed && activityError == nil {
            saveMemedImage()
            memedImage = nil
        }
    }
    
    private func stopTextEditing () {
        switch fieldBeingEdited {
        case .top :
            topTextField.resignFirstResponder()
        case .bottom :
            bottomTextField.resignFirstResponder()
        default :
           break
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.observer = self
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        topTextField.sizeToFit()
        bottomTextField.sizeToFit()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        updateUI()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Notifications
    private func subscribeToKeyboardNotifications() {
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
    
    private func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: Business logic
    private func saveMemedImage() {
        println ("SAVING")
        
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image!, memedImage: self.memedImage!)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.append(meme)
    }
    
    private func memeizeImage(image: UIImage) -> UIImage {
        
        hideBars()
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        showBars()
        
        return memedImage
    }
    
    private func hideBars() {
        UIApplication.sharedApplication().statusBarHidden = true
        navigationController?.navigationBar.hidden = true
        toolbar.hidden = true
    }
    private func showBars() {
        UIApplication.sharedApplication().statusBarHidden = false
        navigationController?.navigationBar.hidden = false
        toolbar.hidden = false
    }
    
    private func numSharedMemes() -> Int {
        return 0
    }
    
    private func updateUI() {
        if (imageView.image != nil) {
            navigationItem.leftBarButtonItem!.enabled = true
        }
        else {
            navigationItem.leftBarButtonItem!.enabled = false
        }

        navigationItem.rightBarButtonItem!.enabled = numSharedMemes() > 0
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
        updateUI()
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
        
        //Prevent sharing while editing text fields
        navigationItem.leftBarButtonItem!.enabled = false
    }
}

extension MemeEditorViewController: ObservableUIImageViewDelegate
{
    func imageDidSet(_: UIImage?) {
        updateUI()
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
