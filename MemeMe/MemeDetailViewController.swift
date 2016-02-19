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
    
    func goToDetails(sender: UIButton!) {
        let editorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        editorController.meme = meme
        editorController.imageViewer?.image = meme.image
        editorController.topText?.text = meme.top
        editorController.bottomText?.text = meme.bottom
        navigationController!.pushViewController(editorController, animated: true)
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
}