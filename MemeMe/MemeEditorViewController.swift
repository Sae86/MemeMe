//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Sae on 10/19/15.
//  Copyright © 2015 Sae. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageViewer: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
        imageViewer.backgroundColor = UIColor.blackColor()
        configureTextFields(topText, startingText: "TOP")
        configureTextFields(bottomText, startingText: "BOTTOM")
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    func configureTextFields(textField: UITextField, startingText: String){
        textField.delegate = self
        textField.text = startingText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageViewer.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            shareButton.enabled = true
        }
    }
    
    // code source: http://stackoverflow.com/questions/24180954/how-to-hide-keyboard-in-swift-on-pressing-return-key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.editing{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.editing{
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        let items = [ self.generateMemedImage() ]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
        save()
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    struct Meme {        
        var top: String
        var bottom: String
        var image: UIImage
        var memedImage: UIImage
    }
    
    func save()  {
        var meme = Meme(top: topText.text!, bottom: bottomText.text!, image: imageViewer.image!, memedImage: generateMemedImage())
    }

    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // TODO:  Show toolbar and navbar      
        return memedImage
    }

    @IBAction func cancelToInitialState(sender: UIBarButtonItem) {
        imageViewer.image = nil
        shareButton.enabled = false
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)       
        unsubscribeFromKeyboardNotifications()
    }
}

