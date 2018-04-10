//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ravi Kumar  on 04/11/17.
//   
//

import UIKit
import Foundation
import GooglePlaces
import Alamofire
import ObjectMapper

struct Coordinate {
    
    var latitude: Double
    var longitude: Double
}

class ViewController: UIViewController, GMSAutocompleteFetcherDelegate {

    var fetcher: GMSAutocompleteFetcher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onlyCitiesFilter = GMSAutocompleteFilter()
        onlyCitiesFilter.type = .city
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: onlyCitiesFilter)
        fetcher?.delegate = self
        fetcher?.sourceTextHasChanged("London")
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        GMSPlacesClient.shared().lookUpPlaceID(predictions.first!.placeID!) { (place, err) in
            if place != nil {
                
                let urlString = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=8acea145518adf10ed50ebd3ba3b4483&lang=en-US"
                Alamofire.request(urlString).responseJSON { response in
                    print(response)
                }
            }
        }
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        // No Op
    }
}

