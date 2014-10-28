//
//  ViewController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/26/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScanditSDKOverlayControllerDelegate, BarcodeHandlerDelegate, HTMLParserDelegate, UIAlertViewDelegate {
    
    typealias BarcodeResult = (brandName: NSString?, companyName: NSString?)
    
    let parser : HTMLParser = HTMLParser()
    
    let scanner = ScanditSDKBarcodePicker(appKey: "synwen4yKux/jyTZR23VcUEb/f8lkwcDBU4ifYuDnRk")
    
    var barcodeResult : BarcodeResult
    
    lazy var barcodeHandler: BarcodeHandler = {
        var handler = BarcodeHandler()
        handler.delegate = self;
        return handler
    }()
    
    required init(coder aDecoder: NSCoder) {
        self.barcodeResult = ("","")
        super.init(coder: aDecoder)
        self.parser.delegate = self;
    }
    
    override func viewDidAppear(animated: Bool) {
        setupBarcodePicker()
    }
    
    func setupBarcodePicker() {
        self.scanner.overlayController.delegate = self
        self.scanner.startScanning()
        self.presentViewController(self.scanner, animated: true, completion: nil)
    }
    
    func handleBarcode(code: String) {
        barcodeHandler.handleBarcode(code)
    }
    
    private func youFucked(message: String) {
        showAlert("TESTED", message: message);
    }
    
    private func youGood(message: String) {
        showAlert("NOT TESTED", message: message)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Dismiss")
        alert.show()
    }
    
    // MARK: Delegate - BarcodeHandlerDelegate
    
    func didReceiveBarcodeInformation(info: (brand: NSString?, company: NSString?)) {
        self.scanner.stopScanning()
        self.barcodeResult = info as BarcodeResult
        parser.parseHTML()
    }
    
    // MARK: Delegate - HTMLParserDelegate
    
    func didFinishParsingHTML(data: Dictionary<String, AnyObject>) {
        var tested = false
        let companies = data["companies"] as NSArray
        let brands = data["brands"] as NSArray!
        var message : String = ""
        
        if let b = self.barcodeResult.brandName {
            message += "\(b) \n"
        }
        if let c = self.barcodeResult.companyName {
            message += "\(c)"
        }

        // Optimize this by using a dictionary with brand/company keys
        if let brandName = self.barcodeResult.brandName {
            for i in 0...(brands.count - 1) {
                let name : NSString = (brands.objectAtIndex(i) as NSString).lowercaseString
                let brand : NSString = brandName.lowercaseString as NSString
                if brand == name {
                    tested = true
                    break
                }
            }
        }
        if let companyName = self.barcodeResult.companyName {
            if !tested {
                for i in 0...(companies.count - 1) {
                    let name : NSString = (companies.objectAtIndex(i) as NSString).lowercaseString
                    var company : NSString = companyName.lowercaseString as NSString
                    println(company)
                    
                    // begin the shit
                    if company == "p & g" {
                        company = "procter & gamble"
                    }
                    if company == "colgate-palmolive company" {
                        company = "colgate-palmolive"
                    }
                    if company == "henkel company" {
                        company = "henkel"
                    }
                    if company == "the clorox pet products company" {
                        company = "the clorox company"
                    }
                    if company == "reckitt benckiser inc." {
                        company = "reckitt benckiser"
                    }
                    // end the shit
                    
                    if company == name {
                        tested = true
                        break;
                    }
                }
            }
        }
        
        if tested {
            youFucked(message)
        } else {
            youGood(message)
        }
    }
    
    // MARK: Delegate - ScanditSDKOverlayControllerDelegate

    func scanditSDKOverlayController(overlayController: ScanditSDKOverlayController!, didScanBarcode scanner: [NSObject : AnyObject]!) {
        let barcode: AnyObject? = scanner["barcode"];
        if let code = barcode as? String {
            handleBarcode(code)
        }

    }
    
    func scanditSDKOverlayController(overlayController: ScanditSDKOverlayController!, didCancelWithStatus status: [NSObject : AnyObject]!) {
    
    }
    
    func scanditSDKOverlayController(overlayController: ScanditSDKOverlayController!, didManualSearch text: String!) {
        
    }
    
    // MARK: Delegate - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.scanner.startScanning()
    }

}

