//
//  SelfConfiguringCell.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 02/08/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ForecastTemperature)
}
