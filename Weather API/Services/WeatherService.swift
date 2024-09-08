//
//  WeatherService.swift
//  Weather API
//
//  Created by Антон Баландин on 6.09.24.
//

import Foundation
import CoreLocation

final class WeatherService {
    private let apiKey = "6e1438a311b0c8d68ab6eb44b19d5ffa"
    
    // MARK: - Public Methods
    func getCurrentWeather(for location: CLLocationCoordinate2D, completion: @escaping (Weather?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            let weather = try? JSONDecoder().decode(Weather.self, from: data)
            completion(weather)
        }
        task.resume()
    }
    
    func getCurrentWeather(for cityName: String, completion: @escaping (Weather?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"
        
        fetchWeatherData(from: urlString, completion: completion)
    }
    
    func getForecast(for cityName: String, completion: @escaping (Forecast?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=metric"
        
        fetchForecastData(from: urlString, completion: completion)
    }
    
    // MARK: - Private Methods
    private func fetchWeatherData(from urlString: String, completion: @escaping (Weather?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weather = try decoder.decode(Weather.self, from: data)
                    completion(weather)
                } catch {
                    print("Ошибка декодирования: \(error)")
                    completion(nil)
                }
            } else {
                print("Ошибка получения данных: \(error?.localizedDescription ?? "неизвестная ошибка")")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    private func fetchForecastData(from urlString: String, completion: @escaping (Forecast?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let forecast = try decoder.decode(Forecast.self, from: data)
                    completion(forecast)
                } catch {
                    print("Ошибка декодирования: \(error)")
                    completion(nil)
                }
            } else {
                print("Ошибка получения данных: \(error?.localizedDescription ?? "неизвестная ошибка")")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
