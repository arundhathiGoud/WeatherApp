//
//  CityWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Four Arms on 16/11/17.
//  Copyright © 2017 Tilicho Labs. All rights reserved.
//

import Foundation
import UIKit

class CityWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}

class AddCityWeatherTableViewCell: UITableViewCell {}


class CityWeatherDetailCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}
class SearchLocaltionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationAreaLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
    }
}
