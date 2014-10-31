//
//  InfoController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/29/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import MessageUI

protocol InfoControllerDelegate {
    func infoScreenCloseButtonTapped()
}

class InfoController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: InfoControllerDelegate?
    
    var overlay: UIView?
    
    let animateInDuration  = 0.3
    let animateOutDuration = 0.3
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var toggleAPIButton: UIButton!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateIn()
    }
    
    
    // MARK: Setup
    
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
        if let version: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String {
            versionString += version
            if let build: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String {
                versionString += " (\(build))"
            }
        }
        
        versionLabel.text = versionString
    }
    
    
    // MARK: Fade In/Out transition
    
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
    
    
    // MARK: IBAction
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        animateOut()
    }

    @IBAction func emailButtonTapped(sender: AnyObject) {
        showEmailForm()
    }
    
    @IBAction func veganRabbitButtonTapped(sender: AnyObject) {
        openSafariWithURL("http://veganrabbit.com/list-of-companies-that-do-test-on-animals/")
    }
    
    @IBAction func toggleAPIButtonTapped(sender: UIButton!) {
        setCurrentAPI(_getCurrentAPIPreference() == "Outpan" ? "Digit Eyes" : "Outpan")
    }
    
    @IBAction func closeButtonTouchDown(sender: UIButton!) {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        overlay?.backgroundColor = UIColor.clearColor()
        if let overlayView = overlay {
            view.addSubview(overlayView)
        }
    }
    
    @IBAction func closeButtonTouchOutside(sender: UIButton!) {
        if let overlayView = overlay {
            overlayView.removeFromSuperview()
        }
    }
    
    // MARK: Email 
    
    private func showEmailForm() {
        var mailer = MFMailComposeViewController()
        mailer.mailComposeDelegate = self
        mailer.setSubject("Subject")
        mailer.setToRecipients(["mark.moll@gmail.com"])
        
        presentViewController(mailer, animated: true, completion: nil)
    }
    
    
    // MARK: External URL Handling
    
    private func openSafariWithURL(URLString: String) {
        let url = NSURL(string: URLString)
        if let href = url {
            UIApplication.sharedApplication().openURL(href)
        }
    }
    
    
    // MARK: API Picking (methods on UIViewController extension)
    
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
    
    
    // MARK: Delegate - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
