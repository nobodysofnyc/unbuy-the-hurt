//
//  ResultsViewController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreImage

protocol ResultsViewControllerDelegate {
    func didFinishPreparing()
    func isReadyForNewScan()
    func didTapInfoButton()
}

enum ResultsState {
    case Positive
    case Negative
    case Neutral
    case Default
}

class ResultsViewController: UIViewController, ResultsViewDelegate {
    
    var screenshotView: UIView?
    
    var currentStateView: ResultsView?
    
    var timer: NSTimer?
    
    let time: NSTimeInterval = 1.2
    
    var timerHasFired = false
    
    var state: ResultsState = .Default
    
    var companyName: String?
    
    var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    @IBOutlet weak var screenshotContainerView: UIView!
    
    var blurView: UIVisualEffectView?
    
    var notBlurView: UIView?
    
    var delegate: ResultsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        loader.center = self.view.center
        
        if iOS8 {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
            if let blur = blurView {
                blur.frame = view.bounds
                blur.alpha = 0.0
                view.addSubview(blur)
                blur.contentView.addSubview(loader)
            }
        } else {
            notBlurView = UIView()
            if let notBlur = notBlurView {
                notBlur.frame = view.bounds
                notBlur.alpha = 0.0
                view.addSubview(notBlur)
                notBlur.addSubview(loader)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        addScreenshot()
        delegate?.didFinishPreparing() // hide scanner
        if let blur = blurView {
            blur.contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        } else {
            if let notBlur = notBlurView {
                notBlur.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            }
        }
        
        loader.startAnimating()
        
        setTimer()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(0.4, animations: {
            if let blur = self.blurView {
                blur.alpha = 1.0
            } else {
                if let notBlur = self.notBlurView {
                    notBlur.alpha = 1.0
                }
            }
            
            if let screenshot = self.screenshotView {
                screenshot.transform = CGAffineTransformMakeScale(0.92, 0.92)
                screenshot.alpha = 0.7
            }
        })
    }
    
    func updateForState(state: ResultsState, name: String?) {
        
        self.state = state
        self.companyName = name
        
        if timerHasFired {
            timerHasFired = false
            
            loader.stopAnimating()
        
            currentStateView = viewForState(state)
            if let stateView = currentStateView {
                self.view.addSubview(stateView)
                stateView.alpha = 0.0
            }
            
            if let company = self.companyName {
                if let stateView = currentStateView {
                    stateView.brandLabel.text = company
                }
            }
            
            UIView.animateWithDuration(0.4, animations: {
                if let stateView = self.currentStateView {
                    stateView.alpha = 1.0
                }
                if let blur = self.blurView {
                    blur.contentView.backgroundColor = self.colorForState(state).colorWithAlphaComponent(0.6)
                } else {
                    if let notBlur = self.notBlurView {
                        notBlur.backgroundColor = self.colorForState(state).colorWithAlphaComponent(0.93)
                    }
                }
            })
        }
    }
    
    func didTapNewScanButton() {
        delegate?.isReadyForNewScan()
    }
    
    func didTapInfoButton() {
        delegate?.didTapInfoButton()
    }
    
    func reset(onComplete: (() -> ())?) {
        
        UIView.animateWithDuration(0.2, animations: {
            if let screenshot = self.screenshotView {
                screenshot.alpha = 0.0
            }
            self.view.backgroundColor = UIColor.clearColor()
            if let stateView = self.currentStateView {
                stateView.alpha = 0.0
            }
        }) { (finished: Bool) -> Void in
            UIView.animateWithDuration(0.4, animations: {
                if let blur = self.blurView {
                    blur.alpha = 0.0
                } else {
                    if let notBlur = self.notBlurView {
                        notBlur.alpha = 0.0
                    }
                }
            }, completion: { (finished: Bool) -> Void in
                if let complete = onComplete {
                    complete()
                }
            })
        }
    }
    
    func addScreenshot() {
        screenshotView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
        if let screenshot = screenshotView {
            screenshotContainerView.backgroundColor = UIColor.clearColor()
            screenshotContainerView.addSubview(screenshot)
        }
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
    
    // MARK: Timer
    
    private func setTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: "doThatTimer", userInfo: nil, repeats: false)
    }
    
    func doThatTimer() {
        timerHasFired = true
        
        if state != .Default {
            updateForState(self.state, name: self.companyName)
        }
    }

}
