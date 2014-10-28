//
//  ViewController.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/26/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ScanditSDKOverlayControllerDelegate, BarcodeHandlerDelegate, HTMLParserDelegate, UIAlertViewDelegate {
    
    let parser : HTMLParser = HTMLParser()
    
    let testing = true
    
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
        super.viewDidAppear(animated)
        
        setup()
    }
    
    func setup() {
        setupBarcodePicker()
        setupSettings()
    }
    
    private func setupSettings() {
    }
    
    private func youFucked(message: String) {
        showAlert("TESTED", message: message);
    }
    
    private func youGood(message: String) {
        showAlert("NOT TESTED", message: message)
    }
    
    func handleBarcode(code: String) {
        barcodeHandler.handleBarcode(code)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Dismiss")
        alert.show()
    }
    
    private func setupBarcodePicker() {
        if testing {
            self.handleBarcode("732913228546")
        } else {
            self.scanner.overlayController.delegate = self
            self.scanner.startScanning()
            self.presentViewController(self.scanner, animated: true, completion: nil)
        }
    }
    
    private func stopScanning() {
        if !testing {
            self.scanner.stopScanning()
        }
    }
    
    // MARK: Delegate - BarcodeHandlerDelegate
    
    func didReceiveBarcodeInformation(info: BarcodeResult) {
        stopScanning()
        self.barcodeResult = info
        parser.parseHTML()
    }
    
    func didFailToReceiveBarcodeInformationWithError(errorMessage: String?) {
        stopScanning()
        
        if let error = errorMessage {
            self.showAlert("Uh oh", message: error)
        } else {
            self.showAlert("Uh oh", message: "There was a problem finding this product")
        }
    }
    
    // MARK: Delegate - HTMLParserDelegate
    
    func didFinishParsingHTML(data: Dictionary<String, AnyObject>) {
        var tested = false
        let companies = data["companies"] as Array<String>
        let brands = data["brands"] as Array<String>
        var message : String = ""
        
        var brandName = ""
        if let brand = self.barcodeResult.brandName {
            brandName = brand
            message += "\(brandName) \n"
        }
        
        var companyName = ""
        if let company = self.barcodeResult.companyName {
            companyName = company
            message += companyName
        }

        for i in 0...(brands.count - 1) {
            let name: String = brands[i] as String
            if companyName == "lysolbrand" {
                companyName = "lysol"
            }
            println(companyName)
            println("\(name) \n")
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
        if !testing {
            self.scanner.startScanning()
        }
    }

}

