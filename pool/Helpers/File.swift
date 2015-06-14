//
//  File.swift
//  pool
//
//  Created by Devran Uenal on 14.06.15.
//  Copyright (c) 2015 PoolParty. All rights reserved.
//

import Foundation

prefix operator / {}
prefix func /(pattern: String) -> NSRegularExpression {
    var options: NSRegularExpressionOptions = NSRegularExpressionOptions.AnchorsMatchLines | NSRegularExpressionOptions.CaseInsensitive
    return NSRegularExpression(pattern: pattern, options: options, error: nil)!
}

extension String {
    func matchesOf(regex: NSRegularExpression) -> [String] {
        let matches = regex.matchesInString(self, options: nil, range: NSRange(location: 0, length: count(self)))
        var results: [String] = []
        for match in matches {
            var matchIndex = match.numberOfRanges - 1
            var substringForMatch: NSString = (self as NSString).substringWithRange(match.rangeAtIndex(matchIndex))
            results.append(substringForMatch as! String)
        }
        return results
    }
}
