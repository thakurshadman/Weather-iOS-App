//
//  ViewController.swift
//  Clima
//
//
//  Assets by Angela Yu of AppBrewery.co & OpenWeatherMap.org .
// Modified by Shadman Thakur on 11/26/2020.

import UIKit
import CoreLocation
import CoreData

class WeatherViewController: UIViewController, UITableViewDelegate{
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherTableView: UITableView!
    
    var weatherManager = WeatherManager()
    var weatherObj: Weather?
    //CoreLocation
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var senderTag: Int?
    let soundManager = SoundPlayerManager()
    var listOfSavedCities = [SavedCities]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("version 2")
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        searchTextField.delegate = self
        weatherManager.delegate = self
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
    }
    
    //MARK: - Segue
    @IBAction func segueToMetrics(_ sender: UIButton) {
        soundManager.playSound()
        senderTag = sender.tag
        self.performSegue(withIdentifier: "goToMetrics", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "goToMetrics"){
            let forecastDetailsVC = segue.destination as! ForecastDetailsViewController
            forecastDetailsVC.senderTag = senderTag
            forecastDetailsVC.weatherObj =  weatherObj
        }
        else if(segue.identifier == "savedCities"){
            let savedCitiesVC = segue.destination as! SavedCitiesTableViewController
            savedCitiesVC.delegate = self
        }
    }
    
    @IBAction func segueToSavedCities(_ sender: UIButton) {
        soundManager.playSound()
        self.performSegue(withIdentifier: "savedCities", sender: self)
    }
    
    
    @IBAction func getWeatherFromGPS(_ sender: Any) {
        soundManager.playSound()
        locationManager.requestLocation()
    }
    @IBAction func saveCityPressed(_ sender: UIButton) {
        //MARK: - CoreData
        getData()
        let cell = weatherTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ForecastCell
        let checkIfCityPresent = listOfSavedCities.filter{$0.cityName == cell.currentCityLabel.text}
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if(checkIfCityPresent.isEmpty){
            let cityToSave = SavedCities(context: context)
            cityToSave.cityName = cell.currentCityLabel.text
            cityToSave.latitude = weatherObj?.lat ?? 0.0
            cityToSave.longitude = weatherObj?.lon ?? 0.0
            do{
                try context.save()
            } catch {
                print(error)
            }
        }
        soundManager.playSound()
 
    }
    @objc func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<SavedCities> = SavedCities.fetchRequest()
        request.returnsObjectsAsFaults = false
        do{
            listOfSavedCities = try context.fetch(request)
        } catch {
            print("Error LOADING from COREDATA: \(error)")
        }
    }
    
}

extension WeatherViewController: UITextFieldDelegate{
    //MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {return true}
        else{
            textField.placeholder = "Please Type A Location"
            return false
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let city = searchTextField.text{
            geocoder.geocodeAddressString(city) { (placemarks, error) in
                        if let error = error{
                            print(error)
                        }
                        else if let placemarks = placemarks?.last{
                            let coordinates = placemarks.location!.coordinate
                            self.weatherManager.fetchOneCallWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                            let forecastCell = self.weatherTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ForecastCell
                            forecastCell.updateUI(location: placemarks)
                            self.weatherTableView.reloadData()
                        }
                    }

        }
        searchTextField.text=""
    }
    
}

extension WeatherViewController: UITableViewDataSource{
    //MARK: - TableViewFuncs
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if(indexPath.row == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "otherWeatherDetailCell") as! OtherWeatherDetailCell
                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastCell
                return cell
            }
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return self.view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 50
            
        }
}

extension WeatherViewController : WeatherManagerDelegate{
    //MARK: - WeatherManagerProtocalFunc
    func errorDidOccur(error: Error) {
            print(error)
    }
    func weatherDidUpdate(weather: Weather){
        DispatchQueue.main.async {
            self.weatherObj = weather
            let cell = self.weatherTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ForecastCell
            cell.updateUI(weatherData: weather)
            let otherDetailCell = self.weatherTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as?
            OtherWeatherDetailCell
            otherDetailCell?.updateUI(weatherData: weather)
            self.weatherTableView.reloadData()
        }
    }
}
//MARK: - LocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last{
            locationManager.stopUpdatingLocation()
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            weatherManager.fetchOneCallWeather(latitude: latitude, longitude: longitude)
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                if let error = error{
                    print(error)
                }
                else if let placemarks = placemarks?.last{
                    self.weatherTableView.beginUpdates()
                    let cell = self.weatherTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ForecastCell
                    cell?.updateUI(location: placemarks)
                    self.weatherTableView.reloadData()
                    self.weatherTableView.endUpdates()
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
//MARK: - SavedCitiesDelegate
extension WeatherViewController : SavedCitiesDelegate {
    func didGetDataFromSavedCityCell(weatherObject: Weather) {
        weatherObj = weatherObject
        let foreCastCell = self.weatherTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ForecastCell
        let otherWeatherDetailsCell = self.weatherTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! OtherWeatherDetailCell
        foreCastCell.updateUI(weatherData: weatherObject)
        otherWeatherDetailsCell.updateUI(weatherData: weatherObject)
        self.weatherTableView.reloadData()
    }   
}

