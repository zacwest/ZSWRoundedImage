//
//  ViewController.swift
//  ZSWRoundedImage
//
//  Created by Zachary West on 10/15/2015.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

import UIKit
import ZSWRoundedImage

class ViewController: UIViewController {
    @IBOutlet weak var simpleRounded: UIImageView!
    @IBOutlet weak var pill: UIImageView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // For normal rounded rectangles, resize both directions
        simpleRounded.image = UIImage.imageWithRoundedCorners(.AllCorners, cornerRadius: 10.0, resizingDirection: .Both, foregroundColor: UIColor.blackColor(), backgroundColor: UIColor.clearColor())
        
        // For pill-like images, only resize horizontally so there's no tile pixel
        pill.image = UIImage.imageWithRoundedCorners(.AllCorners, cornerRadius: pill.bounds.height/2.0, resizingDirection: .Horizontal, foregroundColor: UIColor.blackColor(), backgroundColor: UIColor.clearColor())
    }
}

