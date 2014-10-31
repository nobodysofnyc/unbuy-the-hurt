//
//  CellButton.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/31/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class CellButton: UIButton {
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        nextResponder()?.touchesBegan(touches, withEvent: event)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        nextResponder()?.touchesEnded(touches, withEvent: event)
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        nextResponder()?.touchesCancelled(touches, withEvent: event)
        super.touchesCancelled(touches, withEvent: event)
    }
}
