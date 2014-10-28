//
//  HTMLParser.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/27/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

protocol HTMLParserDelegate {
    func didFinishParsingHTML(data: Dictionary<String, AnyObject>)
}

class HTMLParser: NSObject {

    typealias JSON = AnyObject
    typealias JSONDictionary = Dictionary<String, JSON>
    typealias JSONArray = Array<JSONDictionary>
    
    var delegate : HTMLParserDelegate?
    
    let JSONFileName : String = "/cache.json"
    
    lazy var parser : TFHpple = {
        let HTMLURL: NSURL? = NSURL(string: "http://veganrabbit.com/list-of-companies-that-do-test-on-animals/")
        if let url = HTMLURL {
            let HTMLData : NSData? = NSData(contentsOfURL: url)
            if let data = HTMLData {
                return TFHpple(HTMLData: data)
            }
        }
        return TFHpple()
    }()
    
    override init() {
        super.init()
        var parser = self.parser
    }
    
    func parseHTML() {
    
        if let cache : Dictionary<String, AnyObject> = cachedResuts() as? Dictionary<String,AnyObject> {
            // TODO: bust cache
            self.delegate?.didFinishParsingHTML(cache)
        } else {
            let data = self.fetchAndParseHTML()
            self.cacheResults(data)
            
            self.delegate?.didFinishParsingHTML(data)
        }
    }
    
    private func fetchAndParseHTML() -> Dictionary<String, AnyObject> {
        let companies : [String] = self.parseHeaders()
        let brands : [String] = self.parseBrands()
        let data : [String:AnyObject] = ["date" : NSDate(), "companies" : companies, "brands" : brands]
        
        return data
    }

    private func parseHeaders() -> [String] {
        var headers : [String] = []
        let queryString = "//div[@class='entry-content']/h2"
        let headerNodesArray : NSArray = parser.searchWithXPathQuery(queryString) as NSArray
        for nodeJSON in headerNodesArray {
            let node : TFHppleElement = nodeJSON as TFHppleElement
            let children : NSArray = node.children as NSArray
            if let firstChild : TFHppleElement = children.firstObject as? TFHppleElement {
                let attributes = firstChild.attributes
                if !attributes.isEmpty {
                    let headerNode : NSArray = firstChild.children as NSArray
                    if let header : TFHppleElement = headerNode.firstObject as? TFHppleElement {
                        if header.content != nil {
                            headers.append(header.content as NSString)
                        }
                    }
                }
            }
        }
        return headers
    }
    
    private func parseBrands() -> [String] {
        var brands : [String] = []
        let queryString = "//div[@class='entry-content']/ul/li"
        let listNodesArray : NSArray = parser.searchWithXPathQuery(queryString) as NSArray
        for nodeJSON in listNodesArray {
            let node : TFHppleElement = nodeJSON as TFHppleElement
            let children : NSArray = node.children as NSArray
            if let firstChild : TFHppleElement = children.firstObject as? TFHppleElement {
                let attributes = firstChild.attributes
                if attributes.isEmpty {
                    if firstChild.content != nil {
                        brands.append(firstChild.content as NSString)
                    }
                }
            }
        }
        return brands
    }
    
    private func cacheResults(data: Dictionary<String, AnyObject>) {
        let written = (data as NSDictionary).writeToFile(filePath(), atomically: true)
        println(written)
    }
    
    private func cachedResuts() -> NSDictionary? {
        let results = NSDictionary(contentsOfFile: filePath())
        return results
    }
    
    private func filePath() -> String {
        let documentsPath : NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = documentsPath.stringByAppendingPathComponent("cache.json")
        return destinationPath
    }
    
}
