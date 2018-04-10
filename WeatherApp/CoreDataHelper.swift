//
//  CoreDataHelper.swift
//  WeatherApp
//
//  Created by Ravi Kumar  on 15/11/17.
//   
//

import Foundation
import CoreData
import UIKit

var context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
var saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    func peristWeatherDetailsReponse(weatherDetail: WeatherDetailResponseModel,completion: (City?,String?) -> Void) {
        
        if let cityId = weatherDetail.cityId {
            
            self.deleteEntitesWith( filter: { (cit: City) in
                return cit.cityId == cityId
            }, completion: { (success, err) in
                if success {
                    let city = City(weatherResponseModel: weatherDetail)
                    saveContext()
                    completion(city, nil)
                } else {
                    completion(nil,err)
                }
            })
        }
    }
    
    func getAllEntities<T: NSManagedObject >(completion: ([T]) -> ()) {
        do {
            let result = try context.fetch(T.fetchRequest())
            completion(result as! [T])
        } catch {
            completion([])
        }
    }
    
    func deleteEntitesWith<T: NSManagedObject>( filter : (T) -> Bool ,  completion: (Bool, String?) -> Void) {
        do {
            
            let result = try context.fetch(T.fetchRequest())
            let filteredResult = result.filter({filter($0 as! T)})
            guard filteredResult.count > 0 else {
                completion(true, nil)
                return
            }
            for obj in filteredResult {
                context.delete(obj as! NSManagedObject)
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                    completion(true, nil)
                } catch {
                    completion(false, error.localizedDescription)
                }
            } else {
                completion(true, nil)
            }
            
        } catch {
            completion(false, error.localizedDescription)
        }
    }
}
