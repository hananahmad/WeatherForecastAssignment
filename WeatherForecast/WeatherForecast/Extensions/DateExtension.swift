//
//  DateExtension.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 02/08/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
