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
    
    var delegate: ResultsViewDelegate?
    
    @IBAction func newScanButtonTapped(sender: AnyObject) {
        self.delegate?.didTapNewScanButton()
    }
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        self.delegate?.didTapInfoButton()
    }
    
}
