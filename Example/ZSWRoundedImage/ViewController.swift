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
        simpleRounded.image = UIImage.imageWithRoundedCorners(roundedCorners: .allCorners, cornerRadius: 10.0, resizingDirection: .both, foregroundColor: .black, backgroundColor: .clear)
        
        // For pill-like images, only resize horizontally so there's no tile pixel
        pill.image = UIImage.imageWithRoundedCorners(roundedCorners: .allCorners, cornerRadius: pill.bounds.height/2.0, resizingDirection: .horizontal, foregroundColor: .black, backgroundColor: .clear)
    }
}

