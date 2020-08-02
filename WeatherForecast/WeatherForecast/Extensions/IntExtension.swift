//
//  IntExtension.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 02/08/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import Foundation

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}
