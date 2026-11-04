//
//  StringDecoded.swift
//  OnThisDay
//
//  Created by Kenneth Chua on 11/3/26.
//

import Foundation

extension String {
    /// Decodes HTML character entities (e.g. `&amp;` -> `&`)
    var decodedHTMLEntities: String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, "Any-Hex/HTML" as CFString, false)
        return mutableString as String
    }
}
