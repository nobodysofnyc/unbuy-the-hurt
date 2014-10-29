//
//  ViewController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/26/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
ScanditSDKOverlayControllerDelegate,
BarcodeHandlerDelegate,
HTMLParserDelegate,
ResultsViewControllerDelegate {
    
    let parser: HTMLParser = HTMLParser()
    
    var firstAppearance = true;
    
    let scanner = ScanditSDKBarcodePicker(appKey: "synwen4yKux/jyTZR23VcUEb/f8lkwcDBU4ifYuDnRk")
    
    var barcodeResult: BarcodeResult
    
    var resultsViewController: ResultsViewController = {
        let storyboard = UIStoryboard(name: "ResultsViewController", bundle: nil)
        let viewController: ResultsViewController = storyboard.instantiateInitialViewController() as ResultsViewController
        return viewController
    }()
    
    lazy var barcodeHandler: BarcodeHandler = {
        var handler = BarcodeHandler()
        handler.delegate = self;
        return handler
    }()
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
        barcodeResult = ("","")
        super.init(coder: aDecoder)
        parser.delegate = self;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true;
        
        if firstAppearance {
            firstAppearance = false
            setupBarcodePicker()
        }
    }
    
    func handleBarcode(code: String) {
        barcodeHandler.handleBarcode(code)
    }
    
    func transitionToResults() {
        resultsViewController.delegate = self
        addContentViewController(resultsViewController)
        hideScanner(false)
    }
    
    // MARK: IBAction
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        stopScanning()
        
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        let viewController: InfoController = storyboard.instantiateInitialViewController() as InfoController
        addContentViewController(viewController)
    }
    
    // MARK: Show results state
    
    func showTested(name: String?) {
        resultsViewController.updateForState(.Positive, name: name)
    }
    
    func showNotTested(name: String?) {
        resultsViewController.updateForState(.Negative, name: name)
    }
    
    func showProductNotFound() {
        resultsViewController.updateForState(.Neutral, name: "Unknown")
    }
    
    // MARK: Scanner state
    
    private func showScanner(animated: Bool) {
        addContentViewController(scanner, atIndex: 0)
    }
    
    private func hideScanner(animated: Bool) {
        removeContentViewController(scanner)
    }
    
    private func startScanning() {
        self.scanner.startScanning()
    }
    
    private func stopScanning() {
        self.scanner.stopScanning()
    }
    
    // MARK: Setup

    private func setupBarcodePicker() {
        scanner.overlayController.delegate = self
        showScanner(false)
        startScanning()
    }
    
    // MARK: Delegate - BarcodeHandlerDelegate
    
    func didReceiveBarcodeInformation(info: BarcodeResult) {
        barcodeResult = info
        parser.parseHTML()
    }
    
    func didFailToReceiveBarcodeInformationWithError(errorMessage: String?) {
        self.showProductNotFound()
    }
    
    // MARK: Delegate - HTMLParserDelegate
    
    func didFinishParsingHTML(data: Dictionary<String, AnyObject>) {
        var tested = false
        var unsterilizedCompanyName: String?
        let companies = data["companies"] as Array<String>
        let brands = data["brands"] as Array<String>
        
        var brandName = ""
        if let brand = self.barcodeResult.brandName {
            brandName = brand.sterilize()
        }
        
        var companyName = ""
        if let company = self.barcodeResult.companyName {
            companyName = company.sterilize()
            unsterilizedCompanyName = company
        }

        for i in 0...(brands.count - 1) {
            let name: String = brands[i] as String
            if companyName == "lysolbrand" {
                companyName = "lysol"
            }
            if brandName == name || companyName == name {
                tested = true
                break
            }
        }
        
        if !tested {
            for i in 0...(companies.count - 1) {
                let name: String = companies[i] as String
                if companyName == "colgatepalmoliveco" {
                    companyName = "colgatepalmolive"
                }
                if brandName == name || companyName == name {
                    tested = true
                    break
                }
            }
        }
        if tested {
            showTested(unsterilizedCompanyName)
        } else {
            showNotTested(unsterilizedCompanyName)
        }
    }
    
    // MARK: Delegate - ScanditSDKOverlayControllerDelegate

    func scanditSDKOverlayController(overlayController: ScanditSDKOverlayController!, didScanBarcode scanner: [NSObject : AnyObject]!) {
        stopScanning()
        let barcode: AnyObject? = scanner["barcode"];
        if let code = barcode as? String {
            self.transitionToResults()
            handleBarcode(code)
        }
    }
    
    func scanditSDKOverlayController(overlayController: ScanditSDKOverlayController!, didCancelWithStatus status: [NSObject : AnyObject]!) {
    }
    
    func scanditSDKOverlayController(overlayController: ScanditSDKOverlayController!, didManualSearch text: String!) {
        
    }
    
    // MARK: Delegate - ResultsViewControllerDelegate
    
    func didFinishPreparing() {
        hideScanner(false)
    }
    
    func isReadyForNewScan() {
        showScanner(false)
        startScanning()
        resultsViewController.reset()
        removeContentViewController(resultsViewController)
    }
    

    // MARK: Utility
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

