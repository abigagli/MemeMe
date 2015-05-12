//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Andrea Bigagli on 3/5/15.
//  Copyright (c) 2015 Andrea Bigagli. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var memedImage: UIImage?
    
    var navBarVisible = true
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = memedImage
    }
    
    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        navigationController!.setNavigationBarHidden(navBarVisible, animated: true)
        navBarVisible = !navBarVisible
    }

}
