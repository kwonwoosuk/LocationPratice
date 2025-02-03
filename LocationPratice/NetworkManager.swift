//
//  NetworkManager.swift
//  LocationPratice
//
//  Created by 권우석 on 2/3/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func getWeatherData(lat: Double, lon: Double, completionHandler: @escaping (Result<WeatherData,AFError>) -> Void ) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Key.OpenWeather)&units=metric" //  화씨로 주네 참나
        AF.request(url)
            .responseDecodable(of: WeatherData.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
