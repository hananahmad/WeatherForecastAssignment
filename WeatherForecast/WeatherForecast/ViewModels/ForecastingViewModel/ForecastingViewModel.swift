//
//  ForecastingViewModel.swift
//  WeatherForecast
//
//  Created by Hanan Ahmed on 02/08/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import Foundation

class ForecastingViewModel {
    
    //    let apiService: APIServiceProtocol
    private let apiService: WeatherAPI
    
    private var currentWeatherList: [List] = [List]()
    
    
    /// - Parameter api: Used to interact with the network
    init(api: WeatherAPI = APIManager()) {
        self.apiService = api
    }
    
    var forecastData: [ForecastTemperature] = []
    
    private var cellViewModels: [ForecastTemperature] = [ForecastTemperature]() {
        didSet {
            self.reloadCollectionViewClosure?()
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
    
    var reloadCollectionViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    func initFetch(with cityName: String) {
        self.isLoading = true
        
        self.apiService.getForeCastFor5Days(forCity: cityName) { [weak self] (weatherData) in
            
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
    
    func getCellViewModel( at indexPath: IndexPath ) -> ForecastTemperature {
        return cellViewModels[indexPath.row]
    }
    
    private func processFetchedCurrentWeather( weatherList: [List] ) {
        
        var currentDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var secondDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var thirdDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fourthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fifthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var sixthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        
        self.currentWeatherList = weatherList // Cache
        
        var forecastmodelArray : [ForecastTemperature] = []
        var fetchedData : [WeatherInfo] = [] //Just for loop completion
        
        var currentDayForecast : [WeatherInfo] = []
        var secondDayForecast : [WeatherInfo] = []
        var thirddayDayForecast : [WeatherInfo] = []
        var fourthDayDayForecast : [WeatherInfo] = []
        var fifthDayForecast : [WeatherInfo] = []
        var sixthDayForecast : [WeatherInfo] = []
        
        var totalData = currentWeatherList.count //Should be 40 all the time
        
        for day in 0...currentWeatherList.count - 1 {
            
            let listIndex = day//(8 * day) - 1
            let mainTemp = currentWeatherList[listIndex].main?.temp?.rawValue
            let minTemp = currentWeatherList[listIndex].main?.tempMin?.rawValue
            let maxTemp = currentWeatherList[listIndex].main?.tempMax?.rawValue
            let descriptionTemp = currentWeatherList[listIndex].weather?[safe: 0]?.weatherDescription
            let icon = currentWeatherList[listIndex].weather?[safe: 0]?.icon
            let time = currentWeatherList[listIndex].dt?.rawValue ?? ""
            
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.calendar = Calendar(identifier: .gregorian)
            //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = Date(timeIntervalSince1970: ((currentWeatherList[listIndex].dt?.rawValue ?? "") as NSString ).doubleValue)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let calendar = Calendar.current
            let components = calendar.dateComponents([.weekday], from: date)
            let weekdaycomponent = components.weekday! - 1  //Just the integer value from 0 to 6
            
            let f = DateFormatter()
            let weekday = f.weekdaySymbols[weekdaycomponent] // 0 Sunday 6 - Saturday //This is where we are getting the string val (Mon/Tue/Wed...)
            
            let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
            let currentWeekDay = currentDayComponent.weekday! - 1
            let currentweekdaysymbol = f.weekdaySymbols[currentWeekDay]
            
            if weekdaycomponent == currentWeekDay - 1 {
                totalData = totalData - 1
            }
            
            
            if weekdaycomponent == currentWeekDay {
                let info = WeatherInfo(temp: mainTemp ?? "", min_temp: minTemp ?? "", max_temp: maxTemp ?? "", description: descriptionTemp ?? "", icon: icon!, time: time)
                currentDayForecast.append(info)
                currentDayTemp = ForecastTemperature(weekDay: currentweekdaysymbol, hourlyForecast: currentDayForecast)
                fetchedData.append(info)
            }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 1) {
                let info = WeatherInfo(temp: mainTemp ?? "", min_temp: minTemp ?? "", max_temp: maxTemp ?? "", description: descriptionTemp ?? "", icon: icon!, time: time)
                secondDayForecast.append(info)
                secondDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: secondDayForecast)
                fetchedData.append(info)
            }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 2) {
                let info = WeatherInfo(temp: mainTemp ?? "", min_temp: minTemp ?? "", max_temp: maxTemp ?? "", description: descriptionTemp ?? "", icon: icon!, time: time)
                thirddayDayForecast.append(info)
                thirdDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: thirddayDayForecast)
                fetchedData.append(info)
            }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 3) {
                let info = WeatherInfo(temp: mainTemp ?? "", min_temp: minTemp ?? "", max_temp: maxTemp ?? "", description: descriptionTemp ?? "", icon: icon!, time: time)
                fourthDayDayForecast.append(info)
                fourthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fourthDayDayForecast)
                fetchedData.append(info)
            }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 4){
                let info = WeatherInfo(temp: mainTemp ?? "", min_temp: minTemp ?? "", max_temp: maxTemp ?? "", description: descriptionTemp ?? "", icon: icon!, time: time)
                fifthDayForecast.append(info)
                fifthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fifthDayForecast)
                fetchedData.append(info)
            }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 5) {
                let info = WeatherInfo(temp: mainTemp ?? "", min_temp: minTemp ?? "", max_temp: maxTemp ?? "", description: descriptionTemp ?? "", icon: icon!, time: time)
                sixthDayForecast.append(info)
                sixthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: sixthDayForecast)
                fetchedData.append(info)
            }
            
            
            if fetchedData.count == totalData {
                
                if currentDayTemp.hourlyForecast?.count ?? 0 > 0 {
                    forecastmodelArray.append(currentDayTemp)
                }
                
                if secondDayTemp.hourlyForecast?.count ?? 0 > 0 {
                    forecastmodelArray.append(secondDayTemp)
                }
                
                if thirdDayTemp.hourlyForecast?.count ?? 0 > 0 {
                    forecastmodelArray.append(thirdDayTemp)
                }
                
                if fourthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                    forecastmodelArray.append(fourthDayTemp)
                }
                
                if fifthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                    forecastmodelArray.append(fifthDayTemp)
                }
                
                if sixthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                    forecastmodelArray.append(sixthDayTemp)
                }
                
                
                if forecastmodelArray.count <= 6 {
                    self.cellViewModels = forecastmodelArray
                }
                
            }
            
        }
        
    }
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}
