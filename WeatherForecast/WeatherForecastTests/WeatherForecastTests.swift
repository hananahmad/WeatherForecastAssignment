//
//  WeatherForecastTests.swift
//  WeatherForecastTests
//
//  Created by Hanan Ahmed on 29/07/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

import XCTest
@testable import WeatherForecast

class WeatherForecastTests: XCTestCase {

    /// Fake error case
      enum FakeError: Error {
          case networkError
      }
      /// Fake HTTP interface for faking the network calls
      class FakeHTTPInterface: HttpInterface {
          private let data: Data?
          private let response: URLResponse?
          private let error: Error?
          /// Will use the callback based on these values
          init(data: Data?, response: URLResponse?, error: Error?) {
              self.data = data
              self.response = response
              self.error = error
          }
          func makeRequest(request: URLRequest, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
              callback(data, response, error)
          }
      }
    
//    [833, 2960, 3245]
//{
//  "id": 833,
//  "name": "Ḩeşār-e Sefīd",
//  "state": "",
//  "country": "IR",
//  "coord": {
//    "lon": 47.159401,
//    "lat": 34.330502
//  }
//},
//{
//  "id": 2960,
//  "name": "‘Ayn Ḩalāqīm",
//  "state": "",
//  "country": "SY",
//  "coord": {
//    "lon": 36.321911,
//    "lat": 34.940079
//  }
//},
//{
//  "id": 3245,
//  "name": "Taglag",
//  "state": "",
//  "country": "IR",
//  "coord": {
//    "lon": 44.98333,
//    "lat": 38.450001
//  }
//},
    func testGetCityIDs() {
        // Given
        let json = "".data(using: .utf8)
        let httpInterface = FakeHTTPInterface(data: json, response: nil, error: nil)
        let api = APIManager(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getCities { (items) in
            // Then
            XCTAssertEqual(items.count, 209579)
            XCTAssertEqual(items[0], CityModel(id: 833, name: "Ḩeşār-e Sefīd", state: "", country: "IR", coord: Coord(lon: 47.159401, lat: 34.330502)))
            XCTAssertEqual(items[1], CityModel(id: 2960, name: "‘Ayn Ḩalāqīm", state: "", country: "SY", coord: Coord(lon: 36.321911, lat: 34.940079)))
            XCTAssertEqual(items[2], CityModel(id: 3245, name: "Taglag", state: "", country: "IR", coord: Coord(lon: 44.98333, lat: 38.450001)))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetCityIDsError() {
        // Given
        // Error value to be received
        let error: FakeError = .networkError
        let httpInterface = FakeHTTPInterface(data: nil, response: nil, error: error)
        let api = APIManager(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getCities { (items) in
            let items = [CityModel]()
            // Then
            // Ensure we returned an empty value
            XCTAssertEqual(items.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    /*
    func testGetWeatherData() {
        // Given
//        let response = try JSONDecoder().decode(WeatherData.self, from: data)

        let json = "[833, 2960, 3245]".data(using: .utf8)
        let httpInterface = FakeHTTPInterface(data: json, response: nil, error: nil)
        let api = APIManager(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getCurrentWeather(forCities: ["833", "2960", "3245"]) { (weatherData) in
            // Then
            XCTAssertEqual(weatherData?.list?.count ?? 0, 3)
            XCTAssertEqual(weatherData?.list?[safe: 0]?.name, "Ḩeşār-e Sefīd")
            XCTAssertEqual(weatherData?.list?[safe: 1]?.name, "‘Ayn Ḩalāqīm")
            XCTAssertEqual(weatherData?.list?[safe: 2]?.name, "Taglag")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }*/
    
    func testGetWeatherDataBadJSON() {
        // Given
        // Bad JSON string
        let json = "[kss, dsgs,qwertywrong;;;]".data(using: .utf8)
        let httpInterface = FakeHTTPInterface(data: json, response: nil, error: nil)
        let api = APIManager(httpInterface: httpInterface)
        let expectation = XCTestExpectation(description: "Make network request")
        // When
        api.getCurrentWeather(forCities: ["sdn", "dsd", "fff"]) { (weatherData) in
            // Then
            // Ensure we returned an empty value
            XCTAssertEqual(weatherData?.list?.count, nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
