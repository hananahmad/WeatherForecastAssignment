//
//  WeatherAPI.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 30/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

// TODO: propogate errors through here
protocol WeatherAPI {
    /// A callback for retrieving a list of cities
    typealias CitiesCallback = (([CityModel]) -> Void)
    /// a callback for receiving a
    typealias CurrentWeatherCallback = ((WeatherData?) -> Void)
    
    /// Get all cities. This returns a list of Cities that can be used to query
    /// specific Cities
    func getCities(callback: @escaping CitiesCallback)
    
    /// Get a current weather based on an city ID's that can be retrieved via `getCities`
    func getCurrentWeather(forCities cityIDs: [String], callback: @escaping CurrentWeatherCallback)
    
    /// Get a current forecast based on city name that can be retrieved via `getCurrentWeather` or users current geocode location
    func getForeCastFor5Days(forCity cityName: String, callback: @escaping CurrentWeatherCallback)

}
