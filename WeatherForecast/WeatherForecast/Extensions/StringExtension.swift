//
//  StringExtension.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 31/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import Foundation

extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        
        return self.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? ""
    }
    
    // Trim excess whitespace from the start and end of the string.
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var trimmedCommas: String {
        return self.replacingOccurrences(of: "\\s*(\\p{Po}\\s?)\\s*",
                                                with: "$1",
                                                options: [.regularExpression])
    }
    
    var isBackspace: Bool {
      let char = self.cString(using: String.Encoding.utf8)!
      return strcmp(char, "\\b") == -92
    }
    
}
