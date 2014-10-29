//
//  NewScanButton.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class NewScanButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
    }
}
