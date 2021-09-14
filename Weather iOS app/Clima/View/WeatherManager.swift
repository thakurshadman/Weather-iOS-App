//
//  WeatherManager.swift
//  Clima
//
//  Created by Shadman Thakur on 12/2/20.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func weatherDidUpdate(weather:Weather) 
    func errorDidOccur(error:Error)
}

struct WeatherManager{
    var delegate: WeatherManagerDelegate?
    let oneCallUrl = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&units=imperial&appid=93254f7e09840f538a0c392e44fc099d&"
   

    func fetchOneCallWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees,name:String? = nil){
        let apiURL = oneCallUrl + "lon=" + String(longitude) + "&" + "lat=" + String(latitude)
        getDataFromCall(apiUrl: apiURL, name: name)
    }
    func fetchOneCallWeather(lat:Double,lon:Double,name:String? = nil){
        let apiURL = oneCallUrl + "lon=" + String(lon) + "&" + "lat=" + String(lat)
        getDataFromCall(apiUrl: apiURL, name: name)
    }
    func getDataFromCall(apiUrl:String, name:String? = nil){
        let url = URL(string: apiUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                self.delegate?.errorDidOccur(error: error!)
                return
            }
            if let nilSafeData = data {
                if var weather = self.parseJson(json: nilSafeData){
                    weather.name = name
                    self.delegate?.weatherDidUpdate(weather:weather)
                }
                
            }
        }
        task.resume()
    }
    func parseJson(json: Data) -> Weather?{
        let decoder = JSONDecoder()
        do{
             let weatherObj = try decoder.decode(Weather.self, from: json)
            return weatherObj
        } catch {
            delegate?.errorDidOccur(error: error) 
            return nil
        }
    }
}
