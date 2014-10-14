//
//  DetailsViewController.swift
//  Lect3
//
//  Created by admin on 2014/10/15.
//  Copyright (c) 2014年 emon. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var album: Album?
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.album!.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)))
    }
}