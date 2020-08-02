//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 30/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import Foundation

class CurrentWeatherViewModel {
    
    //    let apiService: APIServiceProtocol
    private let apiService: WeatherAPI
    
    private var currentWeatherList: [List] = [List]()
    
    
    /// - Parameter api: Used to interact with the network
    init(api: WeatherAPI = APIManager()) {
        self.apiService = api
    }
    
    private var cities: [CityModel] = [CityModel]()
    
    private var cellViewModels: [WeatherListCellViewModel] = [WeatherListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    
    var selectedWeather: List?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    func initFetch(with cityNames: [String]) {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.apiService.getCities(callback: { [unowned self] (cities) in
                
                if cities.count == 0 {
                    self.isLoading = false
                    self.alertMessage = "Failed to load cities"
                    return
                } else {
                    var cityIDs = [String]()
                    for city in cityNames {
                        if let index = cities.firstIndex(where: { $0.name?.lowercased() == city.lowercased() }) {
                            cityIDs.append("\((cities[safe: index]?.id)!)")
                        }
                    }
                    
                    self.apiService.getCurrentWeather(forCities: cityIDs) { [weak self] (weatherData) in
                        
                        self?.isLoading = false
                        // Ensure we successfully received a weatherData
                        guard let wd = weatherData else {
                            self?.alertMessage = "Failed to load weather data."
                            return
                        }
                        // Update the state using new data
                        self?.processFetchedCurrentWeather(weatherList: wd.list ?? [List]())
                    }
                }
            })
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> WeatherListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( weather: List ) -> WeatherListCellViewModel {
        
        //Wrap a description
        var tempTextContainer: [String] = [String]()
        if let tempMin = weather.main?.tempMin {
            tempTextContainer.append("Min Temperature: \(tempMin.rawValue)°")
        }
        if let tempMax = weather.main?.tempMax {
            tempTextContainer.append( "Max Temperature: \(tempMax.rawValue)°" )
        }
        let temperature = tempTextContainer.joined(separator: " - ")
        
        let windSpeed = "Wind Speed: \(weather.wind?.speed ?? 0.00) m/s"
        
        /// Description
        let description = weather.weather?[safe: 0]?.weatherDescription ?? "No Description Found"
        
//        http://openweathermap.org/img/wn/10d@2x.png
        /// Weather Icon
        let weatherIconURL = "\(APIManager.imageBaseURL)\(weather.weather?[safe: 0]?.icon ?? "01d")@2x.png"
        
        let cityName = weather.name ?? ""
        
        return WeatherListCellViewModel( temperatureText: temperature,
                                         windSpeed: windSpeed,
                                         descText: description,
                                         weatherIcon: weatherIconURL,
                                         cityName: cityName)
    }
    
    private func processFetchedCurrentWeather( weatherList: [List] ) {
        self.currentWeatherList = weatherList // Cache
        var vms = [WeatherListCellViewModel]()
        for weatherObj in weatherList {
            vms.append( createCellViewModel(weather: weatherObj) )
        }
        self.cellViewModels = vms
    }
}

extension CurrentWeatherViewModel {
    func userPressed( at indexPath: IndexPath ){
        let weatherObj = self.currentWeatherList[safe: indexPath.row]
        if (weatherObj?.name ?? "").count > 0 {
            self.isAllowSegue = true
            self.selectedWeather = weatherObj
        }else {
            self.isAllowSegue = false
            self.selectedWeather = nil
            self.alertMessage = "Weather data corrupted."
        }
    }
}

struct WeatherListCellViewModel {
    let temperatureText: String
    let windSpeed: String
    let descText: String
    let weatherIcon: String
    let cityName: String
}
