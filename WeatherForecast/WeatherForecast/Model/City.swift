//
//  City.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 30/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import Foundation

struct CityModel: Codable, Equatable {
    let id: Int?
    let name, state, country: String?
    let coord: Coord?
    
    
    init(id: Int? = nil, name: String? = nil, state: String? = nil, country: String? = nil, coord: Coord? = nil) {
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.coord = coord
    }
}

// MARK: - Coord
struct Coord: Codable, Equatable {
    let lon, lat: Double?
}
