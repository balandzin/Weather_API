//
//  Weather.swift
//  Weather API
//
//  Created by Антон Баландин on 6.09.24.
//

import Foundation

struct Weather: Codable {
    let name: String
    let main: Main
    let weather: [WeatherDetails]
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherDetails: Codable {
    let description: String
    let icon: String
}

struct Forecast: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: ForecastMain
    let weather: [WeatherDetails]
    
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }
}

struct ForecastMain: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
