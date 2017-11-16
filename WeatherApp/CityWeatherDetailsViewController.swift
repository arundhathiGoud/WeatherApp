//
//  CityWeatherDetailsViewController.swift
//  WeatherApp
//
//  Created by Four Arms on 16/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import UIKit

class CityWeatherDetailsViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherSmallDescription: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headerViewContainer: UIView!
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var city: City!
    
    var cityWeatherDetailsArray: [CityWeatherDetailForm] {
        return city.cityWeatherDetailsArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
        setUpTableView()
        populateViews()
    }
    
    func populateViews() {
        
        cityNameLabel.text = city.name
        weatherSmallDescription.text = city.weather!.weatherDescription
        temperatureLabel.text = "\(Int(city.weather!.temp))º"
        minTemperatureLabel.text = "\(Int(city.weather!.minTemp))º"
        maxTemperatureLabel.text = "\(Int(city.weather!.maxTemp))º"
        dateLabel.text = city.weather?.dateFormatString
    }
    
    func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    func addConstraints() {
        
        //Attach top
        self.view.addConstraint(NSLayoutConstraint(item: self.headerViewContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
    }
}

extension CityWeatherDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffSet = scrollView.contentOffset.y
        
        if yOffSet >= 0 {
            temperatureLabel.alpha = 1 - min((yOffSet/40), 1)
            minTemperatureLabel.alpha = 1 - min((yOffSet/40), 1)
            maxTemperatureLabel.alpha = 1 - min((yOffSet/40), 1)
            dateLabel.alpha = 1 - min((yOffSet/40), 1)
        } else {
            temperatureLabel.alpha = 1
            minTemperatureLabel.alpha = 1
            maxTemperatureLabel.alpha = 1
            dateLabel.alpha = 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherDetailCell") as! CityWeatherDetailCell
        cell.titleLabel.text = cityWeatherDetailsArray[indexPath.row].title.uppercased()
        cell.valueLabel.text = cityWeatherDetailsArray[indexPath.row].value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .darkGray
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}
 
