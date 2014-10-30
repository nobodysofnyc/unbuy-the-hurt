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

enum BarcodeAPI {
    case DigitEyes
    case Outpan
}

class BarcodeHandler: NSObject, BarcodeHandlerDelegate {

    var delegate: BarcodeHandlerDelegate?
    
    var api: BarcodeAPI?
    
    init(api: BarcodeAPI!) {
        self.api = api
        super.init()
    }
    
    func handleBarcode(code: String) {
        self.lookupBarcodeInformation(code)
    }
    
    private func lookupBarcodeInformation(code: String) {
        if api == .DigitEyes {
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
