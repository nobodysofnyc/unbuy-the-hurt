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

class BarcodeHandler: NSObject, BarcodeHandlerDelegate {

    var delegate: BarcodeHandlerDelegate?
    
    let apiHandler = OutPanAPIHandler()
   
    func handleBarcode(code: String) {
        self.lookupBarcodeInformation(code)
    }
    
    private func lookupBarcodeInformation(code: String) {
        self.apiHandler.delegate = self
        self.apiHandler.lookupBarcode(code)
    }
    
    // MARK: Delegate - BarcodeHandlerDelegate -
    
    func didReceiveBarcodeInformation(info: BarcodeResult) {
        self.delegate?.didReceiveBarcodeInformation(info)
    }
    
    func didFailToReceiveBarcodeInformationWithError(errorMessage: String?) {
        self.delegate?.didFailToReceiveBarcodeInformationWithError(errorMessage)
    }
    
}
