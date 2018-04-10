//
//  ViewControllerFactory.swift
//  WeatherApp
//
//  Created by Ravi Kumar  on 16/11/17.
//   
//

import Foundation
import UIKit
import GooglePlaces

class ViewControllerFactory {
    
    static let shared = ViewControllerFactory()
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let citySearchNavigation: String = "CitySearchNavigation"
    let cityWeatherDetailsViewController: String = "CityWeatherDetailsViewController"
    
    
    fileprivate func vcWithId(_ id: String) -> UIViewController {
        return mainStoryboard.instantiateViewController(withIdentifier:id)
    }
    
    func cityWeatherDetailsVC(city: City) -> CityWeatherDetailsViewController {
        let vc = vcWithId(cityWeatherDetailsViewController) as! CityWeatherDetailsViewController
        vc.city = city
        return vc
    }
    func citySearchNavigation(onCityPredictionSelected: @escaping (_ prediction: GMSAutocompletePrediction) -> Void ) -> UINavigationController {
        let navVC = vcWithId(citySearchNavigation) as! UINavigationController
        let searchVC = navVC.topViewController as! CitySearchViewController
        searchVC.onCityPredictionSelected = onCityPredictionSelected
        return navVC
    }
    
}
