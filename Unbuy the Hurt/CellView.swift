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
        super.touchesBegan(touches, withEvent: event)
        
        for view in subviews {
            if let v: UIView = view as? UIView {
                UIView.animateWithDuration(0.15, animations: {
                    v.alpha = 0.4
                })
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        for view in subviews {
            if let v: UIView = view as? UIView {
                UIView.animateWithDuration(0.15, animations: {
                    v.alpha = 1.0
                })
            }
        }
    }
}
