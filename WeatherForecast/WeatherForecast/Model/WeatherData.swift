//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 31/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let cnt: Int?
    let list: [List]?
    
    enum CodingKeys: String, CodingKey {
        case cnt, list
    }
    
}

// MARK: - List
struct List: Codable {
    let coord: Coordinates?
    let sys: Sys?
    let weather: [Weather]?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let id: Int?
    let dt: ValueWrapper?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case coord, sys, weather, main, visibility, wind, clouds, dt, id, name
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coordinates: Codable {
    let lon, lat: Double?
    
    enum CodingKeys: String, CodingKey {
        case lon, lat
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: ValueWrapper?
    let pressure, humidity, tempMin, tempMax: ValueWrapper?
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}


enum ValueWrapper: Codable {
    case stringValue(String)
    case intValue(Int)
    case doubleValue(Double)
    case boolValue(Bool)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .stringValue(value)
            return
        }
        if let value = try? container.decode(Bool.self) {
            self = .boolValue(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self = .doubleValue(value)
            return
        }
        if let value = try? container.decode(Int.self) {
            self = .intValue(value)
            return
        }

        throw DecodingError.typeMismatch(ValueWrapper.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueWrapper"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .stringValue(value):
            try container.encode(value)
        case let .boolValue(value):
            try container.encode(value)
        case let .intValue(value):
            try container.encode(value)
        case let .doubleValue(value):
            try container.encode(value)
        }
    }

    var rawValue: String {
        var result: String
        switch self {
        case let .stringValue(value):
            result = value
        case let .boolValue(value):
            result = String(value)
        case let .intValue(value):
            result = String(value)
        case let .doubleValue(value):
            result = String(value)
        }
        return result
    }

    var intValue: Int? {
        var result: Int?
        switch self {
        case let .stringValue(value):
            result = Int(value)
        case let .intValue(value):
            result = value
        case let .boolValue(value):
            result = value ? 1 : 0
        case let .doubleValue(value):
            result = Int(value)
        }
        return result
    }

    var boolValue: Bool? {
        var result: Bool?
        switch self {
        case let .stringValue(value):
            result = Bool(value)
        case let .boolValue(value):
            result = value
        case let .intValue(value):
            result = Bool(truncating: value as NSNumber)
        case let .doubleValue(value):
            result = Bool(truncating: value as NSNumber)
        }
        return result
    }
}


internal let kKelvinZeroInCelsius = 273.15
internal let kFahrenheitZeroInKelvin = -459.67

func toCelsius(kelvin: Double) -> Double {
    return kelvin - kKelvinZeroInCelsius
}

func toFahrenheit(celsius: Double) -> Double {
    return celsius * 9 / 5 + 32
}
