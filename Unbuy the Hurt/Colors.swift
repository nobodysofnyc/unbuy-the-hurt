//
//  Colors.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func uth_lightGreen() -> UIColor {
        return UIColor(red: 166/255.0, green: 217/255.0, blue: 70/255.0, alpha: 1.0)
    }
    
    class func uth_darkGreen() -> UIColor {
        return UIColor(red: 103/255.0, green: 150/255.0, blue: 63/255.0, alpha: 1.0)
    }
    
    class func uth_greenOverlay() -> UIColor {
        return self.uth_lightGreen().colorWithAlphaComponent(0.44)
    }
    
    class func uth_lightRed() -> UIColor {
        return UIColor(red: 237/255.0, green: 28/255.0, blue: 36/255.0, alpha: 1.0)
    }
    
    class func uth_darkRed() -> UIColor {
        return UIColor(red: 158/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
    }
    
    class func uth_redOverlay() -> UIColor {
        return self.uth_lightRed().colorWithAlphaComponent(0.44)
    }
    
    class func uth_lightGray() -> UIColor {
        return UIColor(red: 205/255.0, green: 209/255.0, blue: 212/255.0, alpha: 1.0)
    }
    
    class func uth_darkGray() -> UIColor {
        return UIColor(red: 158/255.0, green: 162/255.0, blue: 163/255.0, alpha: 1.0)
    }
    
    class func uth_cautionColor() -> UIColor {
        return UIColor(red: 235/255.0, green: 170/255.0, blue: 58/255.0, alpha: 1.0)
    }
    
    class func uth_redTextColor() -> UIColor {
        return UIColor(red: 145/255.0, green: 11/255.0, blue: 16/255.0, alpha: 1.0)
    }
    
    class func uth_greenTextColor() -> UIColor {
        return UIColor(red: 92/255.0, green: 134/255.0, blue: 12/255.0, alpha: 1.0)
    }
    
    class func uth_grayTextColor() -> UIColor {
        return UIColor(red: 106/255.0, green: 110/255.0, blue: 112/255.0, alpha: 1.0)
    }
    
    class func uth_yellowTextColor() -> UIColor {
        return UIColor(red: 138/255.0, green: 98/255.0, blue: 33/255.0, alpha: 1.0)
    }

}