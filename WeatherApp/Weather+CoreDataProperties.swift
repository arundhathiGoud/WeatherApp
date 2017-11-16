//
//  Weather+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Four Arms on 15/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var date: Double
    @NSManaged public var groundLevel: Double
    @NSManaged public var humidity: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var pressure: Double
    @NSManaged public var seaLevel: Double
    @NSManaged public var temp: Double
    @NSManaged public var weatherDescription: String?
    @NSManaged public var weatherMain: String?
    @NSManaged public var windDegree: Double
    @NSManaged public var windSpeed: Double

}
