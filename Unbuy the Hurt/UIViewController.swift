//
//  UIViewController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/29/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import Foundation

extension UIViewController {
    func addContentViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
        viewController.willMoveToParentViewController(self)
    }
    
    func addContentViewController(viewController: UIViewController, atIndex index: Int) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.view.bounds
        self.view.insertSubview(viewController.view, atIndex: index)
        viewController.willMoveToParentViewController(self)
    }
    
    func addContentViewController(viewController: UIViewController, toView view: UIView) {
        self.addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.willMoveToParentViewController(self)
    }
    
    func removeContentViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func _setCurrentAPIPreference(name: String!) {
        NSUserDefaults.standardUserDefaults().setValue(name, forKey: "api_selection")
    }
    
    func _getCurrentAPIPreference() -> String {
        if let selection = NSUserDefaults.standardUserDefaults().valueForKey("api_selection") as String? {
            if selection.isEmpty {
                _setCurrentAPIPreference("Outpan")
                return "Outpan"
            } else {
                return selection
            }
        } else {
            _setCurrentAPIPreference("Outpan")
            return "Outpan"
        }
    }

}
