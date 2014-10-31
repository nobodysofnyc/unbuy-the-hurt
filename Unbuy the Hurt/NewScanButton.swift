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
        layer.cornerRadius = frame.height / 2.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        UIView.animateWithDuration(0.15, animations: {
            self.alpha = 0.4
        })
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 1.0
        })
    }
}
