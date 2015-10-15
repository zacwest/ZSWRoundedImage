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

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image = UIImage.imageWithRoundedCorners(.AllCorners, cornerRadius: 5.0, resizingDirection: .Both, foregroundColor: UIColor.orangeColor(), backgroundColor: UIColor.blackColor())
        imageView.image = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

