//
//  IconImageViewGreen.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/29/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class IconImageViewGreen: IconImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.backgroundColor = UIColor.uth_lightGreen().CGColor
    }
    
}
