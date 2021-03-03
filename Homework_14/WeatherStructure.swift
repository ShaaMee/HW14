//
//  WeatherStructure.swift
//  Homework_11
//
//  Created by user on 17.01.2021.
//

import Foundation

//Structure for current weather

struct WeatherStructure: Decodable {
  
  var main: Main?
  var wind: Wind?
  var weather: [Weather]?
  
}

struct Main: Decodable {
  var temp: Double?
  var feelsLike: Double?
  var pressure: Int?
  var humidity: Int?
  
  
}

struct Weather: Decodable {
  var description: String?
}

struct Wind: Decodable{
  var speed: Int?
}


// Structure for daily weather forecast


struct DailyWeather: Decodable{
  
  var daily: [DailyWeatherData]?
  
}

struct DailyWeatherData: Decodable{
  
  var dt: Int?
  var temp: DailyTemp?
  var windSpeed: Double?
  var weather: [DailyWeatherDescription]?
  
}

struct DailyTemp: Decodable{
  
  var day: Double?
  var min: Double?
  var max: Double?
  
}

struct DailyWeatherDescription: Decodable{
  
  var description: String?
  
}
