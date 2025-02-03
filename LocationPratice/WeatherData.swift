//
//  WeatherData.swift
//  LocationPratice
//
//  Created by 권우석 on 2/3/25.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}
