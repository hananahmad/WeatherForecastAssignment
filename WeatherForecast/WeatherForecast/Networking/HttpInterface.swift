//
//  HttpInterface.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 30/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import UIKit

/// A protocol for making network requests
protocol HttpInterface {
    /// Make a network request asynchronously
    func makeRequest(request: URLRequest, callback: @escaping (Data?, URLResponse?, Error?) -> Void)
}
