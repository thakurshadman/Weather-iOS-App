//
//  WeatherModel.swift
//  Clima
//
//  Created by Shadman Thakur on 12/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct Weather:Decodable {
    var name: String?
    let lat: Double
    let lon: Double
    let current:Current
    let daily: [Daily]
    
}



struct Current:Decodable{
    let dt:Int
    let sunrise:Int
    let sunset:Int
    let temp:Double
    let clouds:Int
    let feels_like:Double
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Forecast]
//    let pop: Double
}
struct Forecast:Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct DailyTemperature: Decodable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
struct FeelsLikeDaily: Decodable{
    let day: Double
}

struct Daily:Decodable{
    let dt:Int
    let sunrise:Int
    let sunset:Int
    let temp:DailyTemperature
    let feels_like: FeelsLikeDaily
    let pressure: Int //hPa
    let humidity: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Forecast]
    let clouds: Int
    let pop: Double
}
