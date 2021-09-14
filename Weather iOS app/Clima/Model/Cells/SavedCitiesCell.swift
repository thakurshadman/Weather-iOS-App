//
//  SavedCitiesCell.swift
//  Clima
//
//  Created by Shadman Thakur on 12/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

class SavedCitiesCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var weatherObj: Weather?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func updateUI(weatherData: Weather) -> Void {
        locationLabel.text = weatherData.name
        conditionImageView.image = UIImage(named: weatherData.current.weather[0].icon)
        tempLabel.text = String(Int(weatherData.current.temp)) + "°F"
        weatherObj = weatherData
    }
}
