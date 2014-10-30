//
//  DigitEyesAPIHandler.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

class DigitEyesAPIHandler: NSObject {
    
    var delegate: BarcodeHandlerDelegate?
    
    let appKey: String  = "/4JIJ5iDFkU5"
    let authKey: String = "Il67Z0u8n1Hs7Om3"
    
    func lookupBarcode(code: String) {

        let signature = (code as NSString).hashedValue(authKey)
        let fields = "brand,gpc_name_address,manufacturer"
        let urlString = "http://digit-eyes.com/gtin/v2_0/?upc_code=\(code)&app_key=\(appKey)&signature=\(signature)&language=en&field_names=\(fields)"
        
        var info: BarcodeResult
        
        let manager = AFHTTPRequestOperationManager()
        manager.GET(urlString, parameters: nil, success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        
            let json : JSONDictionary = response as JSONDictionary
        
            if let brand: String = json["brand"] as? String {
                info.brandName = brand
            }
            
            if let manufacturer : JSONDictionary = json["manufacturer"] as JSONDictionary? {
                if let company : String = manufacturer["company"] as? String {
                    info.companyName = company
                }
            }
        
            self.delegate?.didReceiveBarcodeInformation(info)
            
        }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
            self.delegate?.didFailToReceiveBarcodeInformationWithError(nil)
            return()
        }
    }
}
