//
//  WeatherDetailsResponseModel.swift
//  WeatherApp
//
//  Created by Four Arms on 16/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherDetail: Mappable {
    var weatherMain: String?
    var weatherDescription: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        weatherMain <- map["main"]
        weatherDescription <- map["description"]
    }
}

class WeatherDetailResponseModel: Mappable  {
    
    var cityId: Int64?
    var name: String?
    var windSpeed: Double?
    var windDegree: Double?
    var cloudesAll: Int?
    var date: Double?
    var currentTemperature: Double?
    var minTemperature: Double?
    var maxTemperature: Double?
    var pressure: Double?
    var seaLevel: Double?
    var groundLevel: Double?
    var humidity: Double?
    var latitude: Double?
    var longitude: Double?
    var weather: [WeatherDetail]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        cityId <- map["id"]
        name <- map["name"]
        windSpeed <- map["wind.speed"]
        windDegree <- map["wind.deg"]
        cloudesAll <- map["clouds.all"]
        date <- map["dt"]
        currentTemperature <- map["main.temp"]
        minTemperature <- map["main.temp_min"]
        maxTemperature <- map["main.temp_max"]
        pressure <- map["main.pressure"]
        seaLevel <- map["main.sea_level"]
        groundLevel <- map["main.ground_level"]
        humidity <- map["humidity"]
        latitude <- map["coord.lat"]
        longitude <- map["coord.lon"]
        weather <- map["weather"]
    }
}

extension WeatherDetailResponseModel {
    
    var coordinate: Coordinate? {
        if let lat = latitude, let lon = longitude {
            return Coordinate(latitude: lat, longitude: lon)
        }
        return nil
    }
}
