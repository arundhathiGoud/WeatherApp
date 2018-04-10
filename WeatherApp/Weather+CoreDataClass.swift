//
//  Weather+CoreDataClass.swift
//  WeatherApp
//
//  Created by Ravi Kumar  on 15/11/17.
//   
//

import Foundation
import CoreData

typealias CityWeatherDetailForm = (title: String, value: String)

public class Weather: NSManagedObject {

    convenience init(weatherResponseModel: WeatherDetailResponseModel) {
        self.init(context: context)
        
        date = weatherResponseModel.date ?? Date().timeIntervalSince1970
        groundLevel = weatherResponseModel.groundLevel ?? 0
        humidity = weatherResponseModel.humidity ?? 0
        maxTemp = weatherResponseModel.maxTemperature ?? 0
        minTemp = weatherResponseModel.minTemperature ?? 0
        pressure = weatherResponseModel.pressure ?? 0
        seaLevel = weatherResponseModel.seaLevel ?? 0
        temp = weatherResponseModel.currentTemperature ?? 0
        weatherDescription = weatherResponseModel.weather!.first!.weatherDescription
        weatherMain = weatherResponseModel.weather!.first!.weatherMain
        windDegree = weatherResponseModel.windDegree ?? 0
        windSpeed = weatherResponseModel.windSpeed ?? 0
    }
    
    var dateFormatString: String? {
        
        let df = DateFormatter(withFormat: "MMM d, h:mm a", locale: "en-US")
        return df.string(from: Date(timeIntervalSince1970: self.date))
    }
}
