//
//  InfoController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/29/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol InfoControllerDelegate {
    func infoScreenCloseButtonTapped()
}

class InfoController: UIViewController, UIActionSheetDelegate {
    
    var delegate: InfoControllerDelegate?
    
    let animateInDuration  = 0.3
    let animateOutDuration = 0.3
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var toggleAPIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateIn()
    }
    
    private func setup() {
        setupInitialUI()   // set initial colors and alphas
        setVersionString() // set version
        setCurrentAPI(nil) // set current API selection
    }
    
    private func setupInitialUI() {
        view.backgroundColor = UIColor.clearColor()
        view.alpha = 0.0
    }
    
    private func setVersionString() {
        var versionString = ""
        if let version: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String? {
            versionString += version
            if let build: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as String? {
                versionString += " (\(build))"
            }
        }
        
        versionLabel.text = versionString
    }
    
    func animateIn() {
        UIView.animateWithDuration(animateInDuration, animations: {
            self.view.alpha = 1.0
        })
    }
    
    func animateOut() {
        UIView.animateWithDuration(animateOutDuration, animations: { _ in
            self.view.alpha = 0.0
        }) { _ in
            self.delegate?.infoScreenCloseButtonTapped()
            return()
        }
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        animateOut()
    }

    @IBAction func litteThingsButtonTapped(sender: AnyObject) {
        openSafariWithURL("http://www.navs.org/cruelty-free/little-things-mean-a-lot")
    }
    
    @IBAction func pledgeButtonTapped(sender: AnyObject) {
        openSafariWithURL("https://secure.peta.org/site/Advocacy?cmd=display&page=UserAction&id=2061")
    }
    
    @IBAction func veganRabbitButtonTapped(sender: AnyObject) {
        openSafariWithURL("http://veganrabbit.com/list-of-companies-that-do-test-on-animals/")
    }
    
    private func openSafariWithURL(URLString: String) {
        let url = NSURL(string: URLString)
        if let href = url {
            UIApplication.sharedApplication().openURL(href)
        }
    }
    
    // MARK: API Picking (methods on UIViewController extension)
    
    @IBAction func toggleAPIButtonTapped(sender: AnyObject) {
        self.setCurrentAPI(_getCurrentAPIPreference() == "Outpan" ? "Digit Eyes" : "Outpan")
    }
    
    private func setCurrentAPI(name: String?) {
        if let selection = name {
            _setCurrentAPIPreference(selection)
            _setAPIButtonTitle(name)
        } else {
            _setAPIButtonTitle(_getCurrentAPIPreference())
        }
    }
    
    private func _setAPIButtonTitle(name: String!) {
        toggleAPIButton.setTitle("UPC Database: \(name)", forState: .Normal)
    }

}
