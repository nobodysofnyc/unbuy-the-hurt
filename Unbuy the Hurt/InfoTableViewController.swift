//
//  InfoTableViewController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 11/1/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 0:
            return headerForAttributeSection()
        case 1:
            return headerForLearningSection()
        case 2:
            return headerForContactSection()
        default:
            return UIView()
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 0:
            return headerForAttributeSection().systemLayoutSizeFittingSize(CGSizeZero())
        case 1:
            return headerForLearningSection().systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        case 2:
            return headerForContactSection().systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        default:
            return 30.0
        }
    }
    
    func headerForAttributeSection() -> UIView {
        let header = UIView()
        let label = labelWithText("Company and product names are referenced from VeganRabbit's website")
        header.addSubview(label)
        
        return header
    }
    
    func headerForLearningSection() -> UIView {
        let header = UIView()
        let label = labelWithText("Learn more about animal testing:")
        header.addSubview(label)
        
        return header
    }
    
    func headerForContactSection() -> UIView {
        let header = UIView()
        let label = labelWithText("Fell free to reach out regarding any comments or concerns.")
        header.addSubview(label)
        
        return header
    }
    
    private func labelWithText(text: String) -> UILabel {
        let label = UILabel()
        label.frame = CGRect(x: 23, y: 0, width: view.frame.size.width - 50, height: 44)
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.text = text
        
        return label
    }
}
