//
//  CellView.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/31/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class CellView: UIView {

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        fadeOut()
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        fadeIn()
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        fadeIn()
        super.touchesCancelled(touches, withEvent: event)
    }
    
    private func fadeIn() {
        for view in subviews {
            if let v: UIView = view as? UIView {
                UIView.animateWithDuration(0.15, animations: {
                    v.alpha = 1.0
                })
            }
        }
        UIView.animateWithDuration(0.15, animations: {
            self.backgroundColor = UIColor.clearColor()
        })
    }
    
    private func fadeOut() {
        for view in subviews {
            if let v: UIView = view as? UIView {
                UIView.animateWithDuration(0.15, animations: {
                    v.alpha = 0.4
                })
            }
        }
    }
}
