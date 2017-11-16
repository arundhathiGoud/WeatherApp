//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Four Arms on 15/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import GooglePlaces
import UIKit

class CityListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cityList: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        fetchCitiesFromLocalStore()
    }
    
    func setUpTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func fetchCitiesFromLocalStore() {
        
       CoreDataHelper.shared.getAllEntities(completion: postFetchCitiesFromLocalStore)
    }
    
    fileprivate func reloadWithLocalStoreData() {
        CoreDataHelper.shared.getAllEntities(completion: {(cities: [City]) in
            self.cityList = cities
            self.tableView.reloadData()
        })
    }
}

//Fetch logic flow
extension CityListViewController {

    fileprivate func postFetchCitiesFromLocalStore(fetchedCities cities: [City]) {
        if cities.count == 0 {
            self.fetchDefaultCitiesAndWeatherDetails()
        } else {
            self.cityList = cities
            self.tableView.reloadData()
            self.refreshCurrentCityWeatherDetails()
        }
    }
    
    fileprivate func fetchDefaultCitiesAndWeatherDetails() {
        NetworkManager.shared.fetchWeatherInfoForDefaultCities(completion: { (weatherDetailsList, err) in
            if weatherDetailsList.count > 0 {
                self.onSuccessWeatherDetailsFetchOfDefaultCities(weatherDetails: weatherDetailsList)
            } else {
                self.handleError(string: err)
            }
        })
    }
    
    fileprivate func onSuccessWeatherDetailsFetchOfCities(weatherDetails: [WeatherDetailResponseModel]) {
        
        let group = DispatchGroup()
        var errorString: String?
        
        for weatherDetail in weatherDetails {
            group.enter()
            CoreDataHelper.shared.peristWeatherDetailsReponse(weatherDetail: weatherDetail, completion: { _, err in
                errorString = err
                group.leave()
            })
        }
        group.notify(queue: .main, execute: {
            
            if errorString != nil {
                self.handleError(string: errorString)
            } else {
                self.reloadWithLocalStoreData()
            }
        })
    }
    
    fileprivate func onSuccessWeatherDetailsFetchOfDefaultCities(weatherDetails: [WeatherDetailResponseModel]) {
        onSuccessWeatherDetailsFetchOfCities(weatherDetails: weatherDetails)
    }
    
    fileprivate func handleError(string:String?) {
        let alert = UIAlertController(title: "Error", message: string ?? "Someting went wrong", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default, handler: nil)
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func refreshCurrentCityWeatherDetails() {
        
        NetworkManager.shared.fetchWeatherInfoForCities(cityList: self.cityList) { (weatherDetailsList, err) in
            if weatherDetailsList.count > 0 {
                self.onSuccessWeatherDetailsFetchOfCities(weatherDetails: weatherDetailsList)
            } else {
                self.handleError(string: err)
            }
        }
    }
}

extension CityListViewController {
    
    func onCityPredictionSelected(prediction: GMSAutocompletePrediction) {
        
        NetworkManager.shared.fetchCurrentWeatherFor(prediction: prediction) { (weatherDetail, err) in
            if weatherDetail != nil {
                CoreDataHelper.shared.peristWeatherDetailsReponse(weatherDetail: weatherDetail!, completion: { (city, err) in
                    if city != nil {
                        
                        self.cityList.append(city!)
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: [IndexPath(row: self.cityList.count - 1, section: 0)] , with: .fade)
                        self.tableView.endUpdates()
                        
                    } else {
                        self.handleError(string: err)
                    }
                })
            } else {
                self.handleError(string: err)
            }
        }
    }
}

extension CityListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count + 1 // Extra one for addCity
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.cityList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCityWeatherTableViewCell") as! AddCityWeatherTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherTableViewCell") as! CityWeatherTableViewCell
        let city = self.cityList[indexPath.row]
        cell.cityNameLabel.text = city.name!
        cell.dateLabel.text = city.weather!.dateFormatString
        cell.tempLabel.text = "\(Int(city.weather!.temp))º"
        return  cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < self.cityList.count {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.row < self.cityList.count {
            return [
                UITableViewRowAction(
                    style: .default,
                    title: "Delete",
                    handler: {
                        (_, indexPath) in
                        context.delete(self.cityList[indexPath.row])
                        self.cityList.remove(at: indexPath.row)
                        saveContext()
                        self.tableView.beginUpdates()
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.tableView.endUpdates()
                    })
            ]
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == self.cityList.count {
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == cityList.count {
            let searchNavVC = ViewControllerFactory.shared.citySearchNavigation(onCityPredictionSelected: onCityPredictionSelected)
            self.present(searchNavVC, animated: true, completion: nil)
        } else {
            let vc = ViewControllerFactory.shared.cityWeatherDetailsVC(city: cityList[indexPath.row])
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.cityList.count {
            return 55
        }
        return 64
    }
}
