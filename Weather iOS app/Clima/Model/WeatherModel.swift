//
//  WeatherModel.swift
//  Clima
//
//  Created by Shadman Thakur on 12/4/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let currentTemperature: Double
    let sunrise: Int
    let pressure: Int
    let humidity: Int

        
    var currentTemperatureString: String {
        return String(format: "%.1f", currentTemperature)
    }
}
