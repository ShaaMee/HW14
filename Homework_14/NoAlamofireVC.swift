//
//  NoAlamofireVCViewController.swift
//  Homework_11
//
//  Created by user on 16.01.2021.
//

import UIKit

class NoAlamofireVC: UIViewController {
  
  private var jsonData = WeatherStructure()
  private var jsonDailyData = DailyWeather()

  @IBOutlet weak var currentTempLabel: UILabel!
  @IBOutlet weak var feelsLikeLabel: UILabel!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var windSpeedLabel: UILabel!
  @IBOutlet weak var weatherDescriptionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ForecastWeatherPersistance.shared.createEmptyPersistance()
    
    let loadedCurrentData = CurrentWeatherPersistance.shared.loadCurrentWeather()
    currentTempLabel.text = loadedCurrentData.currentTemp
    feelsLikeLabel.text = loadedCurrentData.feelsLike
    pressureLabel.text = loadedCurrentData.pressure
    humidityLabel.text = loadedCurrentData.humidity
    windSpeedLabel.text = loadedCurrentData.windSpeed
    weatherDescriptionLabel.text = loadedCurrentData.weatherDescription
    
    
    
    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Saint%20Petersburg&units=metric&lang=ru&appid=dc38330af7832da70e101cc8b4c7e914") else { return }
    let session  = URLSession.shared
    session.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        print("no data")
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonData = try decoder.decode(WeatherStructure.self, from: data)
        let currentTemp = self.jsonData.main?.temp ?? nil
        let feels = self.jsonData.main?.feelsLike ?? nil
        let pressure = self.jsonData.main?.pressure ?? nil
        let humidity = self.jsonData.main?.humidity ?? nil
        let speed = self.jsonData.wind?.speed ?? nil
        let description = self.jsonData.weather?.first?.description ?? nil
        
        guard currentTemp != nil,
              feels != nil,
              pressure != nil,
              humidity != nil,
              speed != nil,
              description != nil
        else { return }
        
        DispatchQueue.main.async {
          self.currentTempLabel.text = "\(Int(currentTemp!)) ºC"
          self.feelsLikeLabel.text = "\(Int(feels!)) ºC"
          self.pressureLabel.text = "\(pressure!) кПа"
          self.humidityLabel.text = "\(humidity!) %"
          self.windSpeedLabel.text = "\(speed!) м/с"
          self.weatherDescriptionLabel.text = description
          
          let currentWeatherToSave = (self.currentTempLabel.text!, self.feelsLikeLabel.text!, self.pressureLabel.text!, self.humidityLabel.text!, self.windSpeedLabel.text!, self.weatherDescriptionLabel.text!)
          
          CurrentWeatherPersistance.shared.saveLastCurrentWeather(for: currentWeatherToSave)
        }
        
      } catch {
        print("Can't decode current forecast")
        return
      }
      
    }.resume()
    
    guard let urlDaily = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=59.937500&lon=30.308611&exclude=current,minutely,hourly,alerts&units=metric&lang=ru&appid=dc38330af7832da70e101cc8b4c7e914") else { return }
    
    let sessionDaily  = URLSession.shared
    sessionDaily.dataTask(with: urlDaily) { (data, response, error) in
      
      guard let data = data else {
        print("no data")
        return
      }
      
      do {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    
        self.jsonDailyData = try decoder.decode(DailyWeather.self, from: data)
        
      } catch {
        
        print("Can't decode daily forecast")
        return
      }
    }.resume()
    
    
  }

}

extension NoAlamofireVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
    
    let cellIndex = indexPath.row
    
    if cellIndex % 2 != 0 {
      cell.backgroundColor = .lightGray
    } else {
      cell.backgroundColor = .clear
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    
    let dontHaveSavedForecast = ForecastWeatherPersistance.shared.isEmpty(for: cellIndex)
    
    if dontHaveSavedForecast {
      cell.isHidden = true
    } else {
      let loadedForecastData = ForecastWeatherPersistance.shared.loadSavedForecast()
      cell.dateLabel.text = loadedForecastData[cellIndex].forecastDate
      cell.tempLabel.text = loadedForecastData[cellIndex].forecastTemp
      cell.minTempLabel.text = loadedForecastData[cellIndex].forecastMin
      cell.maxTempLabel.text = loadedForecastData[cellIndex].forecastMax
      cell.windLabel.text = loadedForecastData[cellIndex].forecastWind
      cell.descriptionLabel.text = loadedForecastData[cellIndex].forecastDescription
    }
    
        let dailyDate = jsonDailyData.daily?[cellIndex].dt ?? nil
        let dayTemp = jsonDailyData.daily?[cellIndex].temp?.day ?? nil
        let minTemp = jsonDailyData.daily?[cellIndex].temp?.min ?? nil
        let maxTemp = jsonDailyData.daily?[cellIndex].temp?.max ?? nil
        let windSpeed = jsonDailyData.daily?[cellIndex].windSpeed ?? nil
        let description = jsonDailyData.daily?[cellIndex].weather?[0].description ?? nil
        
        guard dailyDate != nil,
              dayTemp != nil,
              minTemp != nil,
              maxTemp != nil,
              windSpeed != nil,
              description != nil else { return cell }
              
        let date = Date(timeIntervalSince1970: TimeInterval(dailyDate!))
          cell.dateLabel.text = dateFormatter.string(from: date)
          cell.tempLabel.text = "\(Int(dayTemp!)) ºC"
          cell.minTempLabel.text = "\(Int(minTemp!)) ºC"
          cell.maxTempLabel.text = "\(Int(maxTemp!)) ºC"
          cell.windLabel.text = "\(Int(windSpeed!.rounded())) м/с"
          cell.descriptionLabel.text = description

          
          let forecastToSave = (cell.dateLabel.text!, cell.tempLabel.text!, cell.minTempLabel.text!, cell.maxTempLabel.text!, cell.descriptionLabel.text!, cell.windLabel.text!)
          
    ForecastWeatherPersistance.shared.updateLoadedForecast(for: forecastToSave, atIndex: cellIndex)
          
          cell.isHidden = false
          
    return cell
  }

}
