//
//  InfoController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/29/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class InfoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        view.alpha = 0.0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.alpha = 1.0
        })
    }
}
