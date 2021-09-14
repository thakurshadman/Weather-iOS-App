//
//  TableViewController.swift
//  Clima
//
//  Created by Shadman Thakur on 12/8/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol SavedCitiesDelegate {
    func didGetDataFromSavedCityCell(weatherObject: Weather)
}

class SavedCitiesTableViewController: UITableViewController {
    
   
    var delegate: SavedCitiesDelegate?
    
    let geocoder = CLGeocoder()
    var weatherManager = WeatherManager()
    //List of cities that will be retrieved using CoreData
    var listOfSavedCities = [SavedCities]()
    var weatherObjects = [Weather]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        weatherManager.delegate = self
        getData()
        for city in listOfSavedCities{
            weatherManager.fetchOneCallWeather(lat: city.latitude, lon: city.longitude,name: city.cityName)
        }
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfSavedCities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedCitiesCell", for: indexPath) as! SavedCitiesCell
        // Configure the cell...

        return cell
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Saved Locations"
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = #colorLiteral(red: 0.1380977482, green: 0.1380977482, blue: 0.1380977482, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    //MARK: - fetch locations/Cities from CoreData
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
    //Delete a city from list
    //MARK: - Credit: https://www.youtube.com/watch?v=3Ki9w7yzi9U
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SavedCitiesCell
        if (editingStyle == .delete){
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request: NSFetchRequest<SavedCities> = SavedCities.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format:"cityName = %@", cell.locationLabel.text!)
            do{
                let results = try context.fetch(request)
                // Delete _all_ objects:
                    for object in results {
                        weatherObjects.remove(at: indexPath.row)
                        context.delete(object)
                        listOfSavedCities = listOfSavedCities.filter{$0.cityName != object.cityName}
                        break
                    }
                do{
                    try context.save()
                } catch {print(error)}
            } catch {
                // ... fetch failed, report error
                print( "... fetch failed")
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    //MARK: - Sending Data to initial view via delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SavedCitiesCell
        self.delegate?.didGetDataFromSavedCityCell(weatherObject: cell.weatherObj!)
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
    
    
}
//MARK: filling array for weatherData
extension SavedCitiesTableViewController:WeatherManagerDelegate {
    func weatherDidUpdate(weather: Weather) {
        self.weatherObjects.append(weather)
        DispatchQueue.main.async {
            print("\(String(describing: weather.name)),\(weather.lat),  \(weather.lon)")
            for i in 0..<self.weatherObjects.count{
                let cell = self.tableView.cellForRow(at: IndexPath(row: i , section: 0)) as! SavedCitiesCell
                cell.updateUI(weatherData: self.weatherObjects[i])
            }
            self.tableView.reloadData()
        }
    }
    func errorDidOccur(error: Error) {
        print(error)
    }
}
