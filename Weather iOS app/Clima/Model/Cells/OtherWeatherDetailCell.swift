//
//  OtherWeatherDetailCell.swift
//  Clima
//
//  Created by Shadman Thakur on 12/2/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit

class OtherWeatherDetailCell : UITableViewCell {
    @IBOutlet weak var realFeelLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    func updateUI(weatherData:Weather) -> Void {
        realFeelLabel.text = String(Int(weatherData.current.feels_like)) + "°F"
        humidityLabel.text = String(weatherData.current.humidity) + "%"
        cloudinessLabel.text = String(weatherData.current.clouds) + "%"
        pressureLabel.text = String(weatherData.current.pressure) + " hPa"
        windSpeedLabel.text = String(Int(weatherData.current.wind_speed)) + " MPH"
        windDirectionLabel.text = convertToCompassDirection(degree: weatherData.current.wind_deg)
    }
    private func convertToCompassDirection(degree:Int)->String{
        if (degree>338) {return "N"}
        if (degree>293) {return "NW"}
        if(degree>248) {return "W"}
        if(degree>203) {return "SW"}
        if(degree>158) {return "S"}
        if(degree>123) {return "SE"}
        if(degree>68) {return "E"}
        if(degree>23) {return "NE"}
        else {return "N"}
    }
}
