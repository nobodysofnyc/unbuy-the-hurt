//
//  ResultsViewController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ResultsViewControllerDelegate {
    func didFinishPreparing()
    func isReadyForNewScan()
}

enum ResultsState {
    case Positive
    case Negative
    case Neutral
    case Default
}

class ResultsViewController: UIViewController, ResultsViewDelegate {
    
    var screenshotView = UIView()
    
    var currentStateView: ResultsView = ResultsView()
    
    var state: ResultsState = .Default
    
    var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    @IBOutlet weak var screenshotContainerView: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var delegate: ResultsViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        blurView.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addScreenshot()
        delegate?.didFinishPreparing()
        
        loader.center = self.view.center
        loader.startAnimating()
        blurView.contentView.addSubview(loader)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.2, animations: {
            self.blurView.alpha = 1.0
            self.screenshotView.transform = CGAffineTransformMakeScale(0.88, 0.88)
        }) { (finished: Bool) -> Void in
        }
    }
    
    func updateForState(state: ResultsState, name: String?) {
        
        self.state = state
        
        loader.stopAnimating()
        
        currentStateView = viewForState(state)
        if let companyName = name {
            currentStateView.brandLabel.text = companyName
        }
        self.view.addSubview(currentStateView)
        
        UIView.animateWithDuration(0.4, animations: {
            self.blurView.contentView.backgroundColor = self.colorForState(state).colorWithAlphaComponent(0.6)
        }) { (finished: Bool) -> Void in
            
        }
    }
    
    func didTapNewScanButton() {
        delegate?.isReadyForNewScan()
    }
    
    func addScreenshot() {
        screenshotView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
        screenshotContainerView.addSubview(self.screenshotView)
    }
    
    func reset() {
        screenshotView.removeFromSuperview()
        blurView.alpha = 0.0;
        loader.stopAnimating()
        currentStateView.removeFromSuperview()
        blurView.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
    }
    
    private func colorForState(state: ResultsState) -> UIColor {
        switch state {
        case .Positive:
            return UIColor.uth_lightRed()
        case .Negative:
            return UIColor.uth_lightGreen()
        case .Neutral:
            return UIColor.uth_lightGray()
        case .Default:
            return UIColor.uth_lightGray()  
        }
    }
    
    private func viewForState(state: ResultsState) -> ResultsView {
        var nibName = ""
        switch state {
        case .Positive:
            nibName = "PositiveResults"
        case .Negative:
            nibName = "NegativeResults"
        case .Neutral:
            nibName = "NeutralResults"
        case .Default:
            nibName = "DefaultResults"
        }
        
        let views: NSArray = NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil)
        let view: UIView? = views[0] as? UIView
        
        if let resultsView: ResultsView = view as? ResultsView {
            resultsView.delegate = self
            resultsView.frame = self.view.bounds
            return resultsView
        }
        return ResultsView()
    }
    
    private func classname(node: AnyObject!) -> String {
        return _stdlib_getTypeName(node)
    }

}
