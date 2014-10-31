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
ResultsViewControllerDelegate,
InfoControllerDelegate {
    
    var parser: HTMLParser?
    
    var infoController: InfoController?
    
    var barcodeResult: BarcodeResult?
    
    var firstAppearance = true;

    let scanner = ScanditSDKBarcodePicker(appKey: "synwen4yKux/jyTZR23VcUEb/f8lkwcDBU4ifYuDnRk")
    
    var resultsViewController: ResultsViewController?
    
    var barcodeHandler: BarcodeHandler?
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true;
        
        if firstAppearance {
            firstAppearance = false
            setupBarcodePicker()
            view.backgroundColor = UIColor.blackColor()
        }
    }
    
    
    // MARK: Setup
    
    func setup() {
        setupHTMLParser()
        self.view.backgroundColor = UIColor.uth_lightGreen()
    }
    
    func setupHTMLParser() {
        parser = HTMLParser()
        parser?.delegate = self
    }
    
    private func setupBarcodePicker() {
        scanner.overlayController.delegate = self
        scanner.overlayController.setVibrateEnabled(false)
        let left = Float(23.0 / view.frame.size.width)
        let top = Float(23.0 / view.frame.size.height)
        scanner.overlayController.setTorchButtonRelativeX(left, relativeY: top, width: 67, height: 33)
        showScanner(false)
        startScanning()
    }
    
    func handleBarcode(code: String) {
        let api: BarcodeAPI = _getCurrentAPIPreference() == "Outpan" ? .Outpan : .DigitEyes
        barcodeHandler = BarcodeHandler(api: api)
        barcodeHandler?.delegate = self
        barcodeHandler?.handleBarcode(code)
    }
    
    // MARK: IBAction
    
    @IBAction func infoButtonTapped(sender: AnyObject) {
        showInfoScreen()
    }
    
    func showInfoScreen() {
        stopScanning()
        
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        let viewController: InfoController = storyboard.instantiateInitialViewController() as InfoController
        infoController = viewController
        if let controller = infoController {
            controller.delegate = self
            addContentViewController(controller)
        }
    }


    // MARK: Show results state
    
    func showResults(state: ResultsState, text: String?) {
        if let viewController = resultsViewController {
            viewController.updateForState(state, name: text)
        }
    }

    func transitionToResultsScreen() {
        let storyboard = UIStoryboard(name: "ResultsViewController", bundle: nil)
        resultsViewController = storyboard.instantiateInitialViewController() as? ResultsViewController

        if let resultsController  = resultsViewController {
            resultsController.delegate = self
            addContentViewController(resultsController)
            hideScanner(false)
        }

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
    
    
    // MARK: Delegate - BarcodeHandlerDelegate
    
    func didReceiveBarcodeInformation(info: BarcodeResult) {
        barcodeResult = info
        parser?.parseHTML()
    }
    
    func didFailToReceiveBarcodeInformationWithError(errorMessage: String?) {
        showResults(.Neutral, text: nil)
    }
    
    
    // MARK: Delegate - HTMLParserDelegate
    
    func didFinishParsingHTML(data: Dictionary<String, AnyObject>) {
        var tested = false
        var unsterilizedCompanyName: String?
        var unsterilizedBrandName: String?
        let companies = data["companies"] as Array<String>
        let brands = data["brands"] as Array<String>
        
        var brandName = ""
        if let brand = self.barcodeResult?.brandName {
            brandName = brand.sterilize()
            unsterilizedBrandName = brand
        }
        
        var companyName = ""
        if let company = self.barcodeResult?.companyName {
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
                
                // begin the shit
                if companyName == "pg" {
                    companyName = "proctergamble"
                }
                if companyName == "colgatepalmolivecompany" {
                    companyName = "colgatepalmolive"
                }
                if companyName == "henkelcompany" {
                    companyName = "henkel"
                }
                if companyName == "thecloroxpetproductscompany" {
                    companyName = "thecloroxcompany"
                }
                if companyName == "reckittbenckiserinc" {
                    companyName = "reckittbenckiser"
                }
                if companyName == "marsincorporated" {
                    companyName = "mars"
                }
                
                if brandName == name || companyName == name {
                    tested = true
                    break
                }
            }
        }
        
        var displayName: String?
        if let name = unsterilizedCompanyName {
            displayName = name
        } else if let name = unsterilizedBrandName {
            displayName = name
        }
        
        if tested {
            showResults(.Positive, text: displayName)
        } else {
            showResults(.Negative, text: displayName)
        }
    }
    
    
    // MARK: Delegate - ScanditSDKOverlayControllerDelegate

    func scanditSDKOverlayController(overlayController: ScanditSDKOverlayController!, didScanBarcode scanner: [NSObject : AnyObject]!) {
        stopScanning()
        let barcode: AnyObject? = scanner["barcode"];
        if let code = barcode as? String {
            self.transitionToResultsScreen()
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
        if let viewController = resultsViewController {
            viewController.reset({
                self.removeContentViewController(viewController)
                self.resultsViewController = nil
                self.startScanning()
                return ()
            })
        }
    }
    
    func didTapInfoButton() {
        showScanner(false)
        self.showInfoScreen()
        
        if let viewController = resultsViewController {
            viewController.reset({
                self.removeContentViewController(viewController)
                self.resultsViewController = nil
                return ()
            })
        }
    }
    
    
    // MARK: Delegate - InfoControllerDelegate
    
    func infoScreenCloseButtonTapped() {
        if let viewController = infoController {
            removeContentViewController(viewController)
            infoController = nil
            startScanning()
        }
    }
    

    // MARK: Utility
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

