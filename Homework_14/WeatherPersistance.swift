//
//  WeatherPersistance.swift
//  Homework_14
//
//  Created by user on 01.03.2021.
//

import Foundation
import RealmSwift

class CurrentWeater: Object {
  @objc dynamic var currentTemp: String?
  @objc dynamic var feelsLike: String?
  @objc dynamic var pressure: String?
  @objc dynamic var humidity: String?
  @objc dynamic var windSpeed: String?
  @objc dynamic var weatherDescription: String?
}

class OneDayForecast: Object {
  @objc dynamic var forecastDate: String?
  @objc dynamic var forecastTemp: String?
  @objc dynamic var forecastMin: String?
  @objc dynamic var forecastMax: String?
  @objc dynamic var forecastDescription: String?
  @objc dynamic var forecastWind: String?
  
}

class CurrentWeatherPersistance {
  static let shared = CurrentWeatherPersistance()
  private let realm = try! Realm()
  
  func loadCurrentWeather() -> (currentTemp: String, feelsLike: String, pressure: String, humidity: String, windSpeed: String, weatherDescription: String) {
    
    let currentWeatherObjects = realm.objects(CurrentWeater.self)
    
    let currentTemp = currentWeatherObjects.first?.currentTemp ?? "Loading..."
    let feelsLike = currentWeatherObjects.first?.feelsLike ?? "Loading..."
    let pressure = currentWeatherObjects.first?.pressure ?? "Loading..."
    let humidity = currentWeatherObjects.first?.humidity ?? "Loading..."
    let windSpeed = currentWeatherObjects.first?.windSpeed ?? "Loading..."
    let weatherDescription = currentWeatherObjects.first?.weatherDescription ?? "Loading..."
    
    return (currentTemp, feelsLike, pressure, humidity, windSpeed, weatherDescription)
  }
  
  func saveLastCurrentWeather(for weather: (currentTemp: String, feelsLike: String, pressure: String, humidity: String, windSpeed: String, weatherDescription: String)) {
    
    let existingCurrentWeather = realm.objects(CurrentWeater.self)
    
    if existingCurrentWeather.isEmpty {
      
      let forecast = CurrentWeater()
      forecast.currentTemp = weather.currentTemp
      forecast.feelsLike = weather.feelsLike
      forecast.pressure = weather.pressure
      forecast.humidity = weather.humidity
      forecast.windSpeed = weather.windSpeed
      forecast.weatherDescription = weather.weatherDescription
      try! realm.write {
        realm.add(forecast)
      }
    } else {
      
      try! realm.write {
        existingCurrentWeather.first?.currentTemp = weather.currentTemp
        existingCurrentWeather.first?.feelsLike = weather.feelsLike
        existingCurrentWeather.first?.pressure = weather.pressure
        existingCurrentWeather.first?.humidity = weather.humidity
        existingCurrentWeather.first?.windSpeed = weather.windSpeed
        existingCurrentWeather.first?.weatherDescription = weather.weatherDescription
      }
    }

    
  }
}

class ForecastWeatherPersistance {
  static let shared = ForecastWeatherPersistance()
  private let realm = try! Realm()
  
  func createEmptyPersistance() {
    let allObjects = realm.objects(OneDayForecast.self)
    
    if allObjects.isEmpty {
      for _ in 0..<7 {
        try! realm.write {
          realm.add(OneDayForecast())
        }
      }
    }
  }
  
  func loadSavedForecast() -> [(forecastDate: String, forecastTemp: String, forecastMin: String, forecastMax: String, forecastDescription: String, forecastWind: String)]{
    
    let currentWeatherObjects = realm.objects(OneDayForecast.self)
    var forecastToLoad: [(String, String, String, String, String, String)] = []
    
    for object in currentWeatherObjects {
      let date = object.forecastDate ?? ""
      let temp = object.forecastTemp ?? ""
      let min = object.forecastMin ?? ""
      let max = object.forecastMax ?? ""
      let desc = object.forecastDescription ?? ""
      let wind = object.forecastWind ?? ""
      forecastToLoad.append((date, temp, min, max, desc, wind))
    }
    
    return forecastToLoad
  }
  
  
  func updateLoadedForecast(for weather: (forecastDate: String, forecastTemp: String, forecastMin: String, forecastMax: String, forecastDescription: String, forecastWind: String), atIndex index: Int) {
    
    let existingForecast = realm.objects(OneDayForecast.self)
    let singleDayForecast = existingForecast[index]
      
      try! realm.write {
        singleDayForecast.forecastDate = weather.forecastDate
        singleDayForecast.forecastTemp = weather.forecastTemp
        singleDayForecast.forecastMin = weather.forecastMin
        singleDayForecast.forecastMax = weather.forecastMax
        singleDayForecast.forecastDescription = weather.forecastDescription
        singleDayForecast.forecastWind = weather.forecastWind
      }

      }

  
  func isEmpty(for index: Int) -> Bool {
    let checkFlag = realm.objects(OneDayForecast.self)[index].forecastDate
    return (checkFlag == nil)
    
  }
}
