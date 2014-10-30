//
//  BarcodeHandler.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/26/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol BarcodeHandlerDelegate {
    func didReceiveBarcodeInformation(info: BarcodeResult)
    func didFailToReceiveBarcodeInformationWithError(errorMessage: String?)
}

typealias BarcodeResult = (brandName: String?, companyName: String?)
typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>

enum BarcodeHandlers {
    case DigitEyes
    case Outpan
}

class BarcodeHandler: NSObject, BarcodeHandlerDelegate {

    var delegate: BarcodeHandlerDelegate?
   
    func handleBarcode(code: String, handler: BarcodeHandlers) {
        self.lookupBarcodeInformation(code, handler: handler)
    }
    
    private func lookupBarcodeInformation(code: String, handler: BarcodeHandlers) {
        if handler == .DigitEyes {
            let apiHandler = DigitEyesAPIHandler()
            apiHandler.delegate = self
            apiHandler.lookupBarcode(code)
        } else {
            let apiHandler = OutPanAPIHandler()
            apiHandler.delegate = self
            apiHandler.lookupBarcode(code)
        }

    }
    
    // MARK: Delegate - BarcodeHandlerDelegate -
    
    func didReceiveBarcodeInformation(info: BarcodeResult) {
        self.delegate?.didReceiveBarcodeInformation(info)
    }
    
    func didFailToReceiveBarcodeInformationWithError(errorMessage: String?) {
        self.delegate?.didFailToReceiveBarcodeInformationWithError(errorMessage)
    }
    
}
