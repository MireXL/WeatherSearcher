//
//  SavedTableViewController.swift
//  Swy
//
//  Created by Николай Великанец on 25.10.2017.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit

class SavedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var forecaster = [DataForecast]()
    
    @IBOutlet weak var textFieldCityName: UITextField!
    @IBOutlet weak var deleteChoiceView: UIView!
    @IBOutlet weak var noSavedDataLabel: UILabel!
    @IBOutlet weak var tableViewForDate: UITableView!
    override func viewDidLoad() {
      
        getData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showAlert(){
        let alert = UIAlertController(title: "Old Data", message: "Would you like to continue or update?", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { action in
            self.needToBeUpdated()
            print("Update")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
 
        if forecaster.isEmpty == false {
           // guard let forecasterDate = forecaster[0].cityForDate else {return}
          //  print(forecasterDate)
            let networkService = NetwokService()
            networkService.getWeatherFrom(params: ["q":"London"], completion: {
                nowWeatherData in
                guard let weather = nowWeatherData as? Weather else {return}
                print(weather.date)
                print(weather.cityName)
                if weather.date > self.forecaster[0].dateAndHour!{
                    
                    self.showAlert()
                }
            })
        }
    }
    func getData(){
        
        let cDataManger = CoreDataManager()
        forecaster = cDataManger.fetchDateHour()
        print(forecaster.count)
        if forecaster.isEmpty {
            noSavedDataLabel.isHidden = false
        }
    }
    func needToBeUpdated(){
        var cityNameArr = Set<String>()
        for i in forecaster{
            guard let city = i.cityForDate else {return}
            cityNameArr.insert(city)
            
        }
        print(cityNameArr)
        let networkService = NetwokService()
        for i in cityNameArr{
            networkService.getWeatherForFiveDays(params: ["q":i], completion: { fiveForecast in
                guard let forecast = fiveForecast as? [Weather] else{return}
                //print(self.forecaster[3].dateAndHour)
                let cDataManager = CoreDataManager()
                cDataManager.updateDate(weatherToUpdate: forecast, completion: { 
                    
                    self.getData()
                    self.tableViewForDate.reloadData()
                    
                })
            })
        }
    }
   
    @IBAction func updateData(_ sender: Any) {
    
    needToBeUpdated()
    }
    @IBAction func hideDeleteVeiw(_ sender: Any) {
        deleteChoiceView.isHidden = true
    }
    
    @IBAction func DeleteAllData(_ sender: Any) {
        deleteChoiceView.isHidden = true
        for i in forecaster.enumerated().reversed() {
            
            let cDataManager = CoreDataManager()
            let deleted =  cDataManager.deleteData(dataToDelete: i.element)
            if deleted == true{
                forecaster.remove(at: i.offset)
                tableViewForDate.reloadData()
                noSavedDataLabel.isHidden = false
            } else {
                print("Error")
            }
        }
    }
    
    @IBAction func deleteByName(_ sender: Any) {
       // print("sssd")
        guard let toDelete = textFieldCityName.text else {return}
        let cityName = toDelete.filter {$0 != " "}
        deleteChoiceView.isHidden = true
        for i in forecaster.enumerated().reversed() {
            if i.element.cityForDate == cityName{
                
                let cDataManager = CoreDataManager()
                let deleted =  cDataManager.deleteData(dataToDelete: i.element)
                if deleted == true{
                    forecaster.remove(at: i.offset)
                    tableViewForDate.reloadData()
                } else {
                    print("Error")
                }
            }
        }
        if forecaster.isEmpty{
            noSavedDataLabel.isHidden = false
        }
    }
 
    @IBAction func deleteData(_ sender: Any) {
        deleteChoiceView.isHidden = false
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return forecaster.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cellys", for: indexPath)
        cell.textLabel?.text = forecaster[indexPath.row].value(forKeyPath: "cityForDate") as? String
        cell.detailTextLabel?.text = forecaster[indexPath.row].value(forKeyPath: "dateAndHour") as? String
        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let date = forecaster[indexPath.row].value(forKeyPath: "dateAndHour") as? String,
        let town  = forecaster[indexPath.row].value(forKeyPath: "cityForDate") as? String
        else {return}
     
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fiveDaysSavedDate = storyboard.instantiateViewController(withIdentifier: "FiveDaysSavedVC") as! FiveDaysSavedDataVC
        fiveDaysSavedDate.dateForFetch = date
        fiveDaysSavedDate.townForfetch = town
        self.present(fiveDaysSavedDate, animated: true, completion: nil)  
    }

     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(indexPath)
            let cDataManager = CoreDataManager()
            let deleted =  cDataManager.deleteData(dataToDelete: forecaster[indexPath.row])
            if deleted == true{
                print("deleted \(forecaster[indexPath.row])")
                forecaster.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with:.automatic)
                tableView.reloadData()
            }else {
                print("Error")
            }
            
        }
    }

    

}
