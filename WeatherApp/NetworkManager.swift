//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Four Arms on 14/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import GooglePlaces

typealias WeatherResponseCallback = ((WeatherDetailResponseModel?, String?) -> Void)

class NetworkManager {
    
    static let shared = NetworkManager()
    typealias RG = RequestGenerator
    
    class RequestGenerator {
        
        static let baseUrl: String = "http://api.openweathermap.org/data/2.5/"
        static let appKey: String = "8acea145518adf10ed50ebd3ba3b4483"
        
        static func weatherRequestBasedOn(cityIds: [Int64]) -> String {
            var totalCityString: String = cityIds.reduce("") { (res, id) -> String in
                return res + "\(id)" + ","
            }
            let _ = totalCityString.characters.removeLast()
            return appendedAppkeyFor(RG.baseUrl + "group?id=\(totalCityString)&units=metric")
        }
        
        static func weatherRequestBasedOn(latitude: Double, longitude: Double ) -> String {
            return appendedAppkeyFor(baseUrl + "weather?lat=\(latitude)&lon=\(longitude)&units=metric")
        }
        
        static func weatherRequestBasedOn(cityName: String) -> String {
            return appendedAppkeyFor(baseUrl + "weather?q=\(cityName)&units=metric")
        }
        
        static func appendedAppkeyFor(_ string: String) -> String {
            return string + "&appid=\(appKey)"
        }
    }
    
    func fetchWeatherByCityName(cityName: String, completion: @escaping WeatherResponseCallback) {
  
        request(RG.weatherRequestBasedOn(cityName: cityName)).responseJSON { response in
            if let weatherResponse = Mapper<WeatherDetailResponseModel>().map(JSONObject: response.result.value) {
                completion(weatherResponse, nil)
            } else {
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    func fetchCurrentWeatherDetails(forCoordinates coordinate: Coordinate, completion: @escaping WeatherResponseCallback) {
        request(RG.weatherRequestBasedOn(latitude: coordinate.latitude, longitude: coordinate.longitude)).responseJSON { (response) in
            if let weatherResponse = Mapper<WeatherDetailResponseModel>().map(JSONObject: response.result.value) {
                completion(weatherResponse, nil)
            } else {
                completion(nil, response.error?.localizedDescription)
            }
        }
    }
    
    func fetchCurrentWeatherFor(prediction: GMSAutocompletePrediction, completion: @escaping WeatherResponseCallback) {
        
        GMSPlacesClient.shared().lookUpPlaceID( prediction.placeID!) { (place, err) in
            
            if place != nil {
                self.fetchCurrentWeatherDetails(forCoordinates: Coordinate(latitude: place!.coordinate.latitude, longitude: place!.coordinate.longitude),completion: completion)
            } else {
                completion(nil, err?.localizedDescription)
            }
        }
    }
}

extension NetworkManager {
    
    //Default Cities Related.
    func fetchWeatherInfoForCities(cityList: [City], completion: @escaping ([WeatherDetailResponseModel],String?) -> Void ) {
        let cityIds = cityList.map({$0.cityId})
        request(RG.weatherRequestBasedOn(cityIds: cityIds)).responseJSON { response in
            if let weatherDetailsArray = Mapper<WeatherDetailResponseModel>().mapArray(JSONObject: (response.result.value as? [NSString: Any])?["list"]) {
                completion( weatherDetailsArray, nil)
            } else {
                completion([], response.error?.localizedDescription)
            }
        }
    }
}

extension NetworkManager {
    
    //Default Cities Related.
    func fetchWeatherInfoForDefaultCities(completion: @escaping ([WeatherDetailResponseModel],String?) -> Void ) {
        
        let group = DispatchGroup()
        
        var weatherResponseModel: [WeatherDetailResponseModel] = []
        var errorString:String?
        
        for cityName in MetaData.shared.defaultCitiesInfo {
            
            group.enter()
                self.fetchWeatherByCityName(cityName: cityName, completion: { (wdrp, err) in
                    
                    if wdrp != nil {
                        weatherResponseModel.append(wdrp!)
                    } else {
                        errorString = err
                    }
                    group.leave()
                })
        }
        group.notify(queue: DispatchQueue.main, execute: {
            completion(weatherResponseModel, errorString)
        })
    }
}
