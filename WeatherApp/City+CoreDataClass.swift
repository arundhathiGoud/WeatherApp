//
//  City+CoreDataClass.swift
//  WeatherApp
//
//  Created by Four Arms on 15/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import CoreData

public class City: NSManagedObject {

    convenience init(weatherResponseModel: WeatherDetailResponseModel) {
        self.init(context: context)
        
        cityId = weatherResponseModel.cityId ?? 0
        latitude = weatherResponseModel.latitude!
        longitude =  weatherResponseModel.longitude!
        name =  weatherResponseModel.name
        weather = Weather(weatherResponseModel: weatherResponseModel)
    }
    
    var cityWeatherDetailsArray: [CityWeatherDetailForm] {
        return [
            ("ground Level","\(weather?.groundLevel ?? 0)"),
            ("humidity","\(weather?.humidity ?? 0)"),
            ("pressure","\(weather?.pressure ?? 0)"),
            ("sea Level","\(weather?.seaLevel ?? 0)"),
            ("weather Main", weather?.weatherMain ?? ""),
            ("wind Degree","\(weather?.windDegree ?? 0)"),
            ("wind Speed","\(weather?.windSpeed ?? 0)"),
            ("latitude","\(latitude)"),
            ("longitude","\(longitude)")
        ]
    }
}
