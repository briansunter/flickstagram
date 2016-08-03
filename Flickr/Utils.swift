//
//  Utils.swift
//  Flickr
//
//  Created by Brian Sunter on 7/22/16.
//  Copyright © 2016 Brian Sunter. All rights reserved.
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }
}
