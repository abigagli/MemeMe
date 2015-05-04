//
//  ViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 26/4/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

//Overrid property observer for UIImageView to make it easy keeping UI (sharing button in particular) in sync
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
    
    private struct Defaults {
        static let kTopText = "TOP"
        static let kBottomText = "BOTTOM"
    }
    
    //MARK: State
    private enum WhichField {
        case none
        case top
        case bottom
    }
    
    private var fieldBeingEdited: WhichField = .none
    private var memedImage: UIImage?
    private var previousTopText: String?
    private var previousBottomText: String?
    
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

    @IBAction func tapOnImage(sender: UITapGestureRecognizer) {
        if fieldBeingEdited != .none {
            stopTextEditing(restorePreviousText: false)
        }
        
    }
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        memedImage = memeizeImage(imageView.image!)
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = activityCompletedHandler
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    @IBAction func cancelMemeEditing(sender: UIBarButtonItem) {
        //Cancel behavior depends on context:
        if fieldBeingEdited != .none { //While text editing, just stop it and restore previous text
            stopTextEditing(restorePreviousText: true)
        }
        else { //Otherwise alert the user depending on if we have already saved memes and/or we've an image being currently edited
            let nextController = UIAlertController(title: "MemeEditor", message: "I'd really like to see a meme", preferredStyle: .Alert)
            
            if numSavedMemes() > 0 {
                if imageView.image != nil { //We have saved memes, but we're currently editing one, so ask for confirmation
                    nextController.message = "Do you really want to go back to saved memes?"
                    let okAction = UIAlertAction(title:"Yes, show my saved memes", style: .Default) {action in self.dismissViewControllerAnimated(true, completion: nil)}
                    let cancelAction = UIAlertAction(title:"No, I want to keep editing this one", style: .Default, handler: nil)
                    nextController.addAction(okAction)
                    nextController.addAction(cancelAction)
                }
                else { //We have saved memes, but not currently editing one, so just bail out...
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            else {
                //Always let the user start from scratch if there are no saved memes
                let okAction = UIAlertAction(title:"Ok, let's meme from scratch!", style: .Default) {action in self.cleanSlate()}
                nextController.addAction(okAction)
                
                //But if there's an image already set, allow the user to keep editing it
                if imageView.image != nil {
                    let keepEditing = UIAlertAction(title:"Keep editing current meme", style: .Default, handler: nil)
                    nextController.addAction(keepEditing)
                    
                }
            }
            presentViewController(nextController, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.observer = self
        
        cleanSlate()
        
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
    func activityCompletedHandler (activity: String!,  completed: Bool, returnedItems: [AnyObject]!, activityError: NSError!) -> Void {
        
        if completed && activityError == nil {
            saveMemedImage()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func cleanSlate() {
        imageView.image = nil
        previousTopText = Defaults.kTopText
        previousBottomText = Defaults.kBottomText
        stopTextEditing(restorePreviousText: true)
    }
    
    
    private func stopTextEditing (#restorePreviousText: Bool) {
        switch fieldBeingEdited {
        case .top :
            topTextField.resignFirstResponder()
        case .bottom :
            bottomTextField.resignFirstResponder()
        default :
           break
        }
        
        if restorePreviousText {
            topTextField.text = previousTopText
            bottomTextField.text = previousBottomText
        }
        
        fieldBeingEdited = .none
        updateUI()
    }
    
    private func numSavedMemes() -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.count
    }
    
    private func saveMemedImage() {
        //If the user didn't write any specific text, avoid storing default text labels
        let topText = topTextField.text == Defaults.kTopText ? "" : topTextField.text
        let bottomText = bottomTextField.text == Defaults.kBottomText ? "" : bottomTextField.text
        
        var meme = Meme(topText: topText, bottomText: bottomText, originalImage: imageView.image!, memedImage: self.memedImage!)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.append(meme)
    }
    
    private func memeizeImage(image: UIImage) -> UIImage {
        
        hideBars()
        
        //Avoid rendering default placeholder text
        let topText = topTextField.text
        let bottomText = bottomTextField.text
        
        if topTextField.text == Defaults.kTopText {
            topTextField.text = ""
        }
        
        if bottomTextField.text == Defaults.kBottomText {
            bottomTextField.text = ""
        }
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Restore textfields' content
        topTextField.text = topText
        bottomTextField.text = bottomText

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
    
    
    private func updateUI() {
        navigationItem.leftBarButtonItem!.enabled = imageView.image != nil
    }
    
    private func ensureDefaultText(forTextField textField: UITextField) {
        
        if textField.text.isEmpty {
            if textField == topTextField {
                textField.text =  Defaults.kTopText
            }
            else if textField == bottomTextField {
                textField.text =  Defaults.kBottomText
            }
        }
        
    }
}



//MARK: Protocol conformance
extension MemeEditorViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topTextField {
            fieldBeingEdited = .top
            previousTopText = textField.text
            if textField.text == Defaults.kTopText {
                textField.text = ""
            }
        }
        else if textField == bottomTextField {
            fieldBeingEdited = .bottom
            previousBottomText = textField.text
            if textField.text == Defaults.kBottomText {
            textField.text = ""
            }
        }
        
        //Prevent sharing while editing text fields
        navigationItem.leftBarButtonItem!.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        ensureDefaultText(forTextField: textField)
        fieldBeingEdited = .none
        updateUI()
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
