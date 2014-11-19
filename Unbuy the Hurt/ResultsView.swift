//
//  ResultsView.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ResultsViewDelegate {
    func didTapNewScanButton()
    func didTapInfoButton()
}

class ResultsView: UIView {
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var checkListHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var checkTheListButton: NewScanButton!
    
    @IBOutlet weak var iconImageView: UIImageView!
    var delegate: ResultsViewDelegate?
    
    @IBAction func newScanButtonTapped(sender: AnyObject) {
        self.delegate?.didTapNewScanButton()
    }
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        self.delegate?.didTapInfoButton()
    }
    
    @IBAction func checkListButtonTapped(sender: AnyObject) {
        let url = NSURL(string: "http://veganrabbit.com/list-of-companies-that-do-test-on-animals/")
        if let href = url {
            UIApplication.sharedApplication().openURL(href)
        }

    }

    func setState(state: ResultsState) {
        iconImageView.image = imageForState(state)
        iconImageView.backgroundColor = backgroundColorForState(state)
        resultsLabel.text = resultsTextForState(state)
        brandLabel.textColor = textColorForState(state)
        checkTheListButton.setTitleColor(backgroundColorForState(state), forState: .Normal)
        
        if state == .Positive || state == .Negative {
            checkTheListButton.hidden = true
            checkListHeightConstraint.constant = 0.0
        }
    }
    
    func imageForState(state: ResultsState) -> UIImage {
        var image: UIImage
        
        switch state {
        case .Positive:
            image = UIImage(named: "no")!
            break
        case .Negative:
            image = UIImage(named: "yes")!
            break
        case .Neutral:
            image = UIImage(named: "unknown")!
            break
        case .Caution:
            image = UIImage(named: "notSure")!
            break
        case .Default:
            image = UIImage()
            break
        }
        
        return image
    }
    
    func resultsTextForState(state: ResultsState) -> String {
        var text: String
        
        switch state {
        case .Positive:
            text = "Tests on animals"
            break
        case .Negative:
            text = "Does not test on animals"
            break
        case .Neutral:
            text = "Not found"
            break
        case .Caution:
            text = "Potential Match"
            break
        case .Default:
            text = ""
            break
        }
        
        return text

    }
    
    func backgroundColorForState(state: ResultsState) -> UIColor {
        var color: UIColor
        
        switch state {
        case .Positive:
            color = UIColor.uth_lightRed()
            break
        case .Negative:
            color = UIColor.uth_lightGreen()
            break
        case .Neutral:
            color = UIColor.uth_lightGray()
            break
        case .Caution:
            color = UIColor.uth_cautionColor()
            break
        case .Default:
            color = UIColor.whiteColor()
            break
        }
        
        return color
        
    }
    
    func textColorForState(state: ResultsState) -> UIColor {
        var color: UIColor
        
        switch state {
        case .Positive:
            color = UIColor.uth_redTextColor()
            break
        case .Negative:
            color = UIColor.uth_greenTextColor()
            break
        case .Neutral:
            color = UIColor.uth_grayTextColor()
            break
        case .Caution:
            color = UIColor.uth_yellowTextColor()
            break
        case .Default:
            color = UIColor.whiteColor()
            break
        }
        
        return color
        
    }

    
}
