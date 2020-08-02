//
//  Collection.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 31/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


