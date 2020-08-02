//
//  APIManager.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 30/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import UIKit

class APIManager: WeatherAPI {
    
    private let httpInterface: HttpInterface
    static let openWeatherMapBaseURL = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = "656ee95bbc0ccbfc8d6458c04cda4224"
    static let imageBaseURL = "http://openweathermap.org/img/wn/"
    
    /// Create a APIManager.
    ///
    /// - Parameter httpInterface: The interface used to make network requests.
    init(httpInterface: HttpInterface = HttpURLSessionWrapper()) {
        self.httpInterface = httpInterface
    }
    
    func getCities(callback: @escaping CitiesCallback) {
        
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                do {
                    // get the data from JSON file with help of struct and Codable
                    let cities = try decoder.decode([CityModel].self, from: data)
                    // from here we can populate data in tableview
                    //                    print(cities)
                    callback(cities)
                    
                }catch{
                    print(error) // shows error
                    print("Decoding failed")// local message
                    // If we failed to parse the JSON, then send back an empty list
                    callback([])
                    return
                }
                
            } catch {
                print(error) // shows error
                print("Unable to read file")// local message
                // If we failed to parse the JSON, then send back an empty list
                callback([])
                return
            }
        }
    }
    
    func getCurrentWeather(forCities cityIDs: [String], callback: @escaping CurrentWeatherCallback) {
        
        let cities = cityIDs.joined(separator: ",")
        
        let urlString = "\(APIManager.openWeatherMapBaseURL)group?id=\(cities)&units=metric&appid=\(APIManager.apiKey)"
        guard let url = URL(string: urlString) else {
            callback(nil)
            return
        }
        let request = URLRequest(url: url)
        httpInterface.makeRequest(request: request) { (data, response, error) in
            // Ensure the request succeeded
            guard let jsonData = data else {
                callback(nil)
                return
            }
            
            // Parse the JSON
            let decoder = JSONDecoder()
            
            do {
                // get the data from JSON file with help of struct and Codable
                let weather = try decoder.decode(WeatherData.self, from: jsonData)
                callback(weather)                                // from here we can populate data in tableview
                
            } catch {
                print(error) // shows error
                print("Decoding failed")// local message
                // If we failed to parse the JSON, then send back an empty list
                callback(nil)
                return
            }
        }
    }
    
    func getForeCastFor5Days(forCity cityName: String, callback: @escaping CurrentWeatherCallback) {
        let formattedCity = cityName.replacingOccurrences(of: " ", with: "+")

        let urlString = "\(APIManager.openWeatherMapBaseURL)forecast?q=\(formattedCity)&appid=\(APIManager.apiKey)"
        guard let url = URL(string: urlString) else {
            callback(nil)
            return
        }
        let request = URLRequest(url: url)
        httpInterface.makeRequest(request: request) { (data, response, error) in
            // Ensure the request succeeded
            guard let jsonData = data else {
                callback(nil)
                return
            }
            
            // Parse the JSON
            let decoder = JSONDecoder()
            
            do {
                // get the data from JSON file with help of struct and Codable
                let weather = try decoder.decode(WeatherData.self, from: jsonData)
                callback(weather)                                // from here we can populate data in tableview
                
            } catch {
                print(error) // shows error
                print("Decoding failed")// local message
                // If we failed to parse the JSON, then send back an empty list
                callback(nil)
                return
            }
        }
    }
}

