//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sae on 11/22/15.
//  Copyright © 2015 Sae. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var memeView: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "goToDetails:")
        navigationItem.rightBarButtonItem = editButton
        memeView.image = meme.memedImage
    }
    // http://www.thomashanning.com/uipopoverpresentationcontroller/
    func goToDetails(sender: UIButton!) {
        let editorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        editorController.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        if let popoverPresentationController = editorController.popoverPresentationController{
            popoverPresentationController.sourceView = sender
            editorController.setMemeDetails(meme.image, topTextForMeme: meme.top, bottomTextForMeme: meme.bottom)
        }
        presentViewController(editorController, animated: true, completion: nil)

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
}