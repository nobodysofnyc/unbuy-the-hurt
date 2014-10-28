//
//  BarcodeHandler.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/26/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol BarcodeHandlerDelegate {
    func didReceiveBarcodeInformation(info: (brand: NSString?, company: NSString?))
}

class BarcodeHandler: NSObject {

    var delegate: BarcodeHandlerDelegate?
    
    typealias JSON = AnyObject
    typealias JSONDictionary = Dictionary<String, JSON>
   
    func handleBarcode(code: String) {
        self.lookupBarcodeInformation(code)
    }
    
    private func lookupBarcodeInformation(code: String) {
        let key = "/2ewENuLw81W"
        let auth = "Tf59X3m8q6My2Yg2"
        let codeAsNSString = code as NSString
        let signature = codeAsNSString.hashedValue(auth)
        let fields = "brand,gpc_name_address,manufacturer"
        let urlString = "http://digit-eyes.com/gtin/v2_0/?upc_code=\(code)&app_key=\(key)&signature=\(signature)&language=en&field_names=\(fields)"
        
        let manager = AFHTTPRequestOperationManager()
        manager.GET(urlString, parameters: nil, success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            let json : JSONDictionary = response as JSONDictionary
            var brandName : NSString?
            var companyName : NSString?
            
            if let brand: String = json["brand"] as? String {
                brandName = brand as NSString
                
            }
            
            if let manufacturer : JSONDictionary = json["manufacturer"] as JSONDictionary? {
                if let company : String = manufacturer["company"] as? String {
                    companyName = company as NSString
                }
            }
            
            self.delegate?.didReceiveBarcodeInformation((brandName, companyName))
        }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            let alert = UIAlertView(title: "WHERE AM I???", message: "There is no information on this product. Consume at your own risk", delegate: nil, cancelButtonTitle: "Dismiss")
            alert.show()
        }
    }
}
