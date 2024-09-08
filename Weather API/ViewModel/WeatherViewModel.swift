//
//  WeatherViewModel.swift
//  Weather API
//
//  Created by Антон Баландин on 6.09.24.
//

import Foundation
import CoreLocation

final class WeatherViewModel {
    // MARK: - Private Properties
    private let weatherService = WeatherService()
    private let locationManager = LocationManager()
    
    // MARK: - Public Properties
    var onUpdate: (() -> Void)?
    var onAuthorizationDenied: (() -> Void)?
    var weather: Weather? {
        didSet {
            onUpdate?()
        }
    }
    var forecast: Forecast?
    
    var advice: String {
        guard let temp = weather?.main.temp else { return "" }
        if temp < 0 {
            return "Температура меньше 0 градусов\nБерегитесь холода!"
        } else if temp <= 15 {
            return "Пожалуйста, оденьтесь тепло!"
        } else {
            return "Отличная погода на улице!"
        }
    }
    
    init() {
        locationManager.onLocationUpdate = { [weak self] location in
            self?.fetchWeather(for: location)
        }
        
        locationManager.onAuthorizationDenied = { [weak self] in
            self?.handleAuthorizationDenied()
        }
    }
    
    func fetchWeather(for location: CLLocationCoordinate2D) {
        weatherService.getCurrentWeather(for: location) { [weak self] weather in
            DispatchQueue.main.async {
                self?.weather = weather
            }
        }
    }
    
    func fetchWeather(for cityName: String) {
        weatherService.getCurrentWeather(for: cityName) { [weak self] weather in
            DispatchQueue.main.async {
                self?.weather = weather
            }
        }
    }
    
    func fetchForecast(for cityName: String) {
        weatherService.getForecast(for: cityName) { [weak self] forecast in
            DispatchQueue.main.async {
                self?.forecast = forecast
            }
        }
        
        saveForecastToUserDefaults()
    }
    
    func getWeatherIcon(for iconCode: String) -> String {
        let weatherIconMapping: [String: String] = [
            "01d": "sun",
            "01n": "moon",
            "02d": "few_clouds",
            "02n": "few_clouds_night",
            "03d": "scattered_clouds",
            "04d": "broken_clouds",
            "09d": "shower_rain",
            "10d": "rain",
            "11d": "thunderstorm",
            "13d": "snow",
            "50d": "mist"
        ]
        
        if let imageName = weatherIconMapping[iconCode] {
            return imageName
        } else {
            return "default_image"
        }
    }
    
    private func handleAuthorizationDenied() {
        onAuthorizationDenied?()
    }
}

extension WeatherViewModel {
    func saveForecastToUserDefaults() {
        if let forecast = try? JSONEncoder().encode(self.forecast) {
            UserDefaults.standard.set(forecast, forKey: "savedForecast")
        }
    }
    
    func loadForecastFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "savedForecast") {
            if let savedForecast = try? JSONDecoder().decode(Forecast.self, from: data) {
                self.forecast = savedForecast
                self.onUpdate?()
            }
        }
    }
}
