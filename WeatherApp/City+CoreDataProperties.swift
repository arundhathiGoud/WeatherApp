//
//  City+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ravi Kumar  on 15/11/17.
//   
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
