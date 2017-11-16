//
//  City+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Four Arms on 15/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var cityId: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var weather: Weather?

}
