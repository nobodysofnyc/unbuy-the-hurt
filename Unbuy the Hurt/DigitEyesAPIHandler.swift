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
    
    func lookupBarcode(code: String) {

        let key = "/2ewENuLw81W"
        let auth = "Tf59X3m8q6My2Yg2"
        let codeAsNSString = code as NSString
        let signature = codeAsNSString.hashedValue(auth)
        let fields = "brand,gpc_name_address,manufacturer"
        let urlString = "http://digit-eyes.com/gtin/v2_0/?upc_code=\(code)&app_key=\(key)&signature=\(signature)&language=en&field_names=\(fields)"
        
        var info: BarcodeResult
        
        let manager = AFHTTPRequestOperationManager()
        manager.GET(urlString, parameters: nil, success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        
            let json : JSONDictionary = response as JSONDictionary
        
            if let brand: String = json["brand"] as? String {
                info.brandName = brand.sterilize()
            }
            
            if let manufacturer : JSONDictionary = json["manufacturer"] as JSONDictionary? {
                if let company : String = manufacturer["company"] as? String {
                    info.companyName = company.sterilize()
                }
            }
        
            self.delegate?.didReceiveBarcodeInformation(info)
            
        }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
            
        }
    }
}
