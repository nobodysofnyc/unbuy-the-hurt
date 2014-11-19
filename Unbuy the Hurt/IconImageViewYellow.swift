//
//  IconImageViewYellow.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 11/19/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class IconImageViewYellow: IconImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.backgroundColor = UIColor.uth_cautionColor().CGColor
    }

}
