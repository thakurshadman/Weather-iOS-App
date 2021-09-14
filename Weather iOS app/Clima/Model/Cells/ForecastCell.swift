//
//  Cells.swift
//  Clima
//
//  Created by Shadman Thakur on 12/2/20.


import Foundation
import UIKit
import CoreLocation


class ForecastCell : UITableViewCell {
   
    let daysOfTheWeek = ["SUN","MON","TUE","WED","THU", "FRI", "SAT"]
    var date = Date()
    var currentDate = Calendar.current
    
    @IBOutlet weak var forcastDay1ImageView: UIImageView!
    @IBOutlet weak var forcastDay1HighLabel: UILabel!
    @IBOutlet weak var forecastDay1LowLabel: UILabel!
    @IBOutlet weak var forcast1DayOfWeekLabel: UILabel!
    
    @IBOutlet weak var forcastDay2ImageView: UIImageView!
    @IBOutlet weak var forcastDay2HighLabel: UILabel!
    @IBOutlet weak var forecastDay2LowLabel: UILabel!
    @IBOutlet weak var forcast2DayOfWeekLabel: UILabel!
    
    @IBOutlet weak var forcastDay3ImageView: UIImageView!
    @IBOutlet weak var forcastDay3HighLabel: UILabel!
    @IBOutlet weak var forecastDay3LowLabel: UILabel!
    @IBOutlet weak var forcast3DayOfWeekLabel: UILabel!
    
    @IBOutlet weak var forcastDay4ImageView: UIImageView!
    @IBOutlet weak var forcastDay4HighLabel: UILabel!
    @IBOutlet weak var forecastDay4LowLabel: UILabel!
    @IBOutlet weak var forcast4DayOfWeekLabel: UILabel!
    
    @IBOutlet weak var forcastDay5ImageView: UIImageView!
    @IBOutlet weak var forcastDay5HighLabel: UILabel!
    @IBOutlet weak var forecastDay5LowLabel: UILabel!
    @IBOutlet weak var forcast5DayOfWeekLabel: UILabel!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    

    func updateUI(weatherData: Weather) -> Void {
        let numericalRepOf = currentDate.component(.weekday, from: date)
        
        if(weatherData.name != nil){currentCityLabel.text = weatherData.name}
        currentTempLabel.text = String(Int(weatherData.current.temp)) + "°F"
        currentWeatherLabel.text = weatherData.current.weather[0].description.capitalized
        currentWeatherImageView.image = UIImage(named: "\(weatherData.current.weather[0].icon)")

        forcastDay1ImageView.image = UIImage(named:"\(weatherData.daily[0].weather[0].icon)")
        forcastDay1HighLabel.text = String(Int(weatherData.daily[0].temp.max.rounded(.toNearestOrAwayFromZero))) + "°F"
        forecastDay1LowLabel.text = String(Int(weatherData.daily[0].temp.min.rounded(.toNearestOrAwayFromZero))) + "°F"
        forcast1DayOfWeekLabel.text = daysOfTheWeek[(numericalRepOf-1)%7]

        forcastDay2ImageView.image = UIImage(named:"\(weatherData.daily[1].weather[0].icon)")
        forcastDay2HighLabel.text = String(Int(weatherData.daily[1].temp.max.rounded(.toNearestOrAwayFromZero))) + "°F"
        forecastDay2LowLabel.text = String(Int(weatherData.daily[1].temp.min.rounded(.toNearestOrAwayFromZero))) + "°F"
        forcast2DayOfWeekLabel.text = daysOfTheWeek[(numericalRepOf)%7]

        forcastDay3ImageView.image = UIImage(named:"\(weatherData.daily[2].weather[0].icon)")
        forcastDay3HighLabel.text = String(Int(weatherData.daily[2].temp.max.rounded(.toNearestOrAwayFromZero))) + "°F"
        forecastDay3LowLabel.text = String(Int(weatherData.daily[2].temp.min.rounded(.toNearestOrAwayFromZero))) + "°F"
        forcast3DayOfWeekLabel.text = daysOfTheWeek[(numericalRepOf+1)%7]

        forcastDay4ImageView.image = UIImage(named:"\(weatherData.daily[3].weather[0].icon)")
        forcastDay4HighLabel.text = String(Int(weatherData.daily[3].temp.max.rounded(.toNearestOrAwayFromZero))) + "°F"
        forecastDay4LowLabel.text = String(Int(weatherData.daily[3].temp.min.rounded(.toNearestOrAwayFromZero))) + "°F"
        forcast4DayOfWeekLabel.text = daysOfTheWeek[(numericalRepOf+2)%7]


        forcastDay5ImageView.image = UIImage(named:"\(weatherData.daily[4].weather[0].icon)")
        forcastDay5HighLabel.text = String(Int(weatherData.daily[4].temp.max.rounded(.toNearestOrAwayFromZero))) + "°F"
        forecastDay5LowLabel.text = String(Int(weatherData.daily[4].temp.min.rounded(.toNearestOrAwayFromZero))) + "°F"
        forcast5DayOfWeekLabel.text = daysOfTheWeek[(numericalRepOf+3)%7]
    }
    func updateUI(location:CLPlacemark){
        if let cityNotNil = location.locality{
            currentCityLabel.text = cityNotNil + ", " + location.country!
        } else {currentCityLabel.text = location.country}
    }
}


