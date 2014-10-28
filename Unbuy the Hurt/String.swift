//
//  String.swift
//  Unbuy the Hurt
//
//  Created by Mike Kavouras on 10/28/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import Foundation

extension String {
    func sterilize() -> String {
        let notAllowedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet
        let parts = self.componentsSeparatedByCharactersInSet(notAllowedCharacters)
        return "".join(parts).lowercaseString
    }
}