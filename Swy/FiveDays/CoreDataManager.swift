//
//  CoreDataManager.swift
//  Swy
//
//  Created by Николай Великанец on 25.10.2017.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager{
    var forecast = [DataForecast]()
    var descriptionDate = [DescriptionOfData]()
   
    func fetchDateHour() -> [DataForecast]{
        //print("fetch1")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return forecast}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataForecast")
        
        do {
            forecast = try managedContext.fetch(fetchRequest) as! [DataForecast]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        forecast.sort(by: {$0.dateAndHour! < $1.dateAndHour!})
        return forecast
    }
    
    func fetchDescription(date:String, town :String) -> DescriptionOfData? {
        //print("fetch2")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DescriptionOfData")
        
        do {
            descriptionDate = try managedContext.fetch(fetchRequest) as! [DescriptionOfData]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        var description = DescriptionOfData()
        for i in descriptionDate{
            if i.dateDescription == date && i.townDescription == town{
                description = i
            }
        }
        return description
    }
 
    func updateData(weatherToUpdate : [Weather],completion : @escaping () -> ()){
        //print("called")
        let existingDataArr = fetchDateHour()
        var WeatherArr = weatherToUpdate
        let dateWeather = WeatherArr[0].date.split(separator: ",")
        let onlyDateWeather = dateWeather[0].split(separator: "/")
        print(onlyDateWeather)
        var updated = false
       // print("NewWeather - \(newWeatherArr[0].date)")
        if existingDataArr.isEmpty == false{
            print("exist")
            for i in existingDataArr.reversed(){
                guard let city =  i.cityForDate ,
                    let dateAndTime = i.dateAndHour else {return}
                let dateExist = dateAndTime.split(separator: ",")
                let onlyDateExist = dateExist[0].split(separator: "/")
                if city == WeatherArr[0].cityName && ((onlyDateExist[0] as NSString).integerValue < (onlyDateWeather[0] as NSString).integerValue || (onlyDateExist[1] as NSString).integerValue < (onlyDateWeather[1] as NSString).integerValue || (onlyDateExist[2] as NSString).integerValue < (onlyDateWeather[2] as NSString).integerValue || dateExist[1] < dateWeather[1]){
                    
                    updated  = deleteData(dataToDelete: i)
                    if updated == true{
                        print("was deleted\(i)")
                    }
                }
            }
            if updated == true {
               /* for i in newWeatherArr.enumerated().reversed(){
                    if newWeatherArr[0].date > newWeatherArr[i.offset].date{
                        newWeatherArr.remove(at: i.offset)
                    }
                }//delete if  test data in network class not used */
                saveData(dataToSave: WeatherArr)
                completion()
            }
        }
    }
    func checkData(weatherToCheck : [Weather])->[Weather]{
        var weatherChekedArr = weatherToCheck
         let existingDataArr = fetchDateHour() 
        if existingDataArr.isEmpty == false{
            for i in existingDataArr.enumerated(){
                for j in  weatherChekedArr.enumerated().reversed(){
                    
                    if i.element.cityForDate == weatherChekedArr[j.offset].cityName && i.element.dateAndHour == weatherChekedArr[j.offset].date{
                        print("copy")
                        weatherChekedArr.remove(at: j.offset)
                    }
                }
            }
        }
        return weatherChekedArr
    }
    func saveData(dataToSave : [Weather]){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let  arrayToSave = checkData(weatherToCheck: dataToSave)
        if arrayToSave.isEmpty == false{
            for i in arrayToSave{
                let dataForecastDm = DataForecast(context: managedContext)
                dataForecastDm.dateAndHour = i.date
                dataForecastDm.cityForDate = i.cityName
                let descriptionOfDataDm = DescriptionOfData(context: managedContext)
                descriptionOfDataDm.dataForecast = dataForecastDm
                descriptionOfDataDm.dateDescription = i.date
                descriptionOfDataDm.coordinatesDescription = "\(i.geolocation.ln),\(i.geolocation.lt)"
                descriptionOfDataDm.pressureDescription = i.measurement.pressure
                descriptionOfDataDm.temperatureDescription = i.measurement.temp
                descriptionOfDataDm.temperatureMax = i.measurement.tempMax
                descriptionOfDataDm.temperatureMin = i.measurement.tempMin
                descriptionOfDataDm.skyDescriptionL = i.sky.description
                descriptionOfDataDm.windDescription = i.windSpeed
                descriptionOfDataDm.townDescription = i.cityName
                descriptionOfDataDm.countryDescription = i.counrty
            }
            do {
                try managedContext.save()
                print("saved")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    func deleteData(dataToDelete:DataForecast)->Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(dataToDelete)
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return false
    }
    
}
