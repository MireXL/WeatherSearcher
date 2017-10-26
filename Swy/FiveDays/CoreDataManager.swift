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
        print("fetch1")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return forecast}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DataForecast")
        
        do {
            forecast = try managedContext.fetch(fetchRequest) as! [DataForecast]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        forecast.sort(by: {$0.dateAndHour! < $1.dateAndHour!})
       // print(forecast)
        return forecast
    }
    
    func fetchDescription(date:String) -> DescriptionOfData{
        print("fetch2")
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return DescriptionOfData()}
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "DescriptionOfData")
        
        do {
            descriptionDate = try managedContext.fetch(fetchRequest) as! [DescriptionOfData]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        //print(descriptionDate[0])
        var descriptionArr = DescriptionOfData()
        for i in descriptionDate{
            if i.dateDescription == date{
                
                descriptionArr = i
            }
        }
        print("Desctr \(descriptionArr)")
        return descriptionArr
    }
    func saveData(weatherToSave : [Weather]){
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext

        for i in weatherToSave{
            let dataForecastDm = DataForecast(context: managedContext)
            dataForecastDm.dateAndHour = i.date
            let descriptionOfDataDm = DescriptionOfData(context: managedContext)
            descriptionOfDataDm.dataForecast = dataForecastDm
            descriptionOfDataDm.dateDescription = i.date
            descriptionOfDataDm.coordinatesDescription = "\(i.geolocation.ln),\(i.geolocation.lt)"
            descriptionOfDataDm.pressureDescription = i.measurement.pressure
            descriptionOfDataDm.temperatureDescription = i.measurement.temp
            descriptionOfDataDm.temperatureMax = i.measurement.tempMax
            descriptionOfDataDm.temperatureMin = i.measurement.tempMin
            descriptionOfDataDm.skyDescriptionL = i.sky.description
        }
        
        do {
            try managedContext.save()
            print("saved")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func deleteData(dataToDelete:DataForecast)->Bool{
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {return false }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
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
