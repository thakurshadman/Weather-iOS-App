//
//  ForecastDetailsViewController.swift
//  Clima
//
//  Created by Shadman Thakur on 12/1/20.


import UIKit

class ForecastDetailsViewController: UIViewController, UITableViewDelegate{

    var weatherObj: Weather?
    var senderTag: Int?
    
    @IBOutlet weak var metricsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metricsTableView.dataSource = self
        metricsTableView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ForecastDetailsViewController : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDescriptionCell") as! WeatherDescriptionCell
            if (weatherObj != nil){cell.weatherDescriptionLabel.text =  weatherObj?.daily[senderTag!].weather[0].description.capitalized}
            return cell

        }
        if(indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsTypeLabel.text = "High"
            if (weatherObj != nil){cell.metricsValueLabel.text = String(Int((weatherObj?.daily[senderTag!].temp.max)!)) + "°F"}
            cell.metricsImageView.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            return cell
        }
        if(indexPath.row == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsTypeLabel.text = "Low"
            if (weatherObj != nil){cell.metricsValueLabel.text = String(Int((weatherObj?.daily[senderTag!].temp.min)!)) + "°F"}
            cell.metricsImageView.tintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            return cell
        }
        if(indexPath.row == 4) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            if (weatherObj != nil){cell.metricsValueLabel.text = String(Int((weatherObj?.daily[senderTag!].feels_like.day)!)) + "°F"}
            cell.metricsTypeLabel.text = "Real Feel"
            cell.metricsImageView.tintColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
            return cell
        }
        if(indexPath.row == 5) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsTypeLabel.text = "Precipitation Chance"
            if (weatherObj != nil){cell.metricsValueLabel.text = String((weatherObj?.daily[senderTag!].pop)! * 100) + "%"}
            cell.metricsImageView.image = UIImage(systemName: "cloud.rain.fill" )
            cell.metricsImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return cell
        }
        if(indexPath.row == 6) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsTypeLabel.text = "Humidity"
            if (weatherObj != nil){cell.metricsValueLabel.text = String((weatherObj?.daily[senderTag!].humidity)!) + "%"}
            cell.metricsImageView.image = UIImage(systemName: "percent" )
            return cell
        }
        if(indexPath.row == 7) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsImageView.image = UIImage(systemName: "wind" )
            if (weatherObj != nil){cell.metricsValueLabel.text = String((weatherObj?.daily[senderTag!].wind_speed)!) + " MPH"}
            cell.metricsTypeLabel.text = "Wind Speed"
            return cell
        }
        if(indexPath.row == 8) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsImageView.image = UIImage(systemName: "location.north.fill" )
            if (weatherObj != nil){cell.metricsValueLabel.text = convertToCompassDirection(degree: (weatherObj?.daily[senderTag!].wind_deg)!)}
            cell.metricsTypeLabel.text = "Wind Direction"
            cell.metricsImageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return cell
        }
        if(indexPath.row == 9) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsTypeLabel.text = "Cloudiness"
            cell.metricsImageView.image = UIImage(systemName: "cloud.fill" )
            if (weatherObj != nil){cell.metricsValueLabel.text = String((weatherObj?.daily[senderTag!].clouds)!) + "%"}
            cell.metricsImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return cell
        }
        if(indexPath.row == 10) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "extraMetricsCell") as! ExtraMetricsCell
            cell.metricsImageView.image = UIImage(systemName: "barometer" )
            if (weatherObj != nil){cell.metricsValueLabel.text = String((weatherObj?.daily[senderTag!].pressure)!) + " hPa"}
            cell.metricsTypeLabel.text = "Pressure"
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherIconCell") as! WeatherIconCell
            if (weatherObj != nil) {cell.weatherIconImageView.image = UIImage(named: (weatherObj?.daily[senderTag!].weather[0].icon)!)}
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 180
        } else {return 74}
    }
}

// MARK: Credit https://stackoverflow.com/questions/36475255/i-have-wind-direction-data-coming-from-openweathermap-api-and-the-data-is-repre
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
