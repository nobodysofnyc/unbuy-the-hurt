//
//  OutPanAPIHandler.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

class OutPanAPIHandler: NSObject {
    
    var delegate: BarcodeHandlerDelegate?

    func lookupBarcode(code: String) {
        
        let apiKey = "4f912541e005a516574433fb74c66a1e"
        let url = "http://www.outpan.com/api/get-product.php?apikey=\(apiKey)&barcode=\(code)"
        println(url)
        let manager = AFHTTPRequestOperationManager()
        manager.GET(url, parameters: nil, success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            var info: BarcodeResult
            
            if let error : JSONDictionary = response["error"] as? JSONDictionary {
                self.delegate?.didFailToReceiveBarcodeInformationWithError(error["message"] as String?)
            } else {
                
                if let brand: String = response["name"] as? String {
                    info.brandName = brand
                }
                
                if let manufacturer : JSONDictionary = response["attributes"] as? JSONDictionary {
                    if let company : String = manufacturer["Manufacturer"] as? String {
                        info.companyName = company
                    }
                }
                
                self.delegate?.didReceiveBarcodeInformation(info)
            }
            }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
        }
    }
}
