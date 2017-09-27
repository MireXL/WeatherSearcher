//
//  WeatherTableViewController.swift
//  Swy
//
//  Created by Николай Великанец on 11.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherViewController: UIViewController{
    var WeatherForNow : Weather?
    @IBOutlet weak var imageForIcon: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDescriptionLabel: UILabel!
    
    @IBOutlet weak var skyLabel: UILabel!
    @IBOutlet weak var skyDescriptionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDescriptionLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDescriptionLabel: UILabel!
    
    @IBOutlet weak var townLabel: UILabel!
    @IBOutlet weak var townDescriptionLabel: UILabel!
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var coordinatesDescriptionLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pressureDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        
        sortingDataFunc()

        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func sortingDataFunc(){
        guard let date = WeatherForNow?.date,
        let skyDescription = WeatherForNow?.sky.description,
        let skyIcon = WeatherForNow?.sky.weatherIcon,
        let temperature = WeatherForNow?.measurement.temp,
        let maxTemperature = WeatherForNow?.measurement.tempMax,
        let minTemperature = WeatherForNow?.measurement.tempMin,
        let windSpeed = WeatherForNow?.windSpeed,
        let cityName = WeatherForNow?.cityName,
        let counrty = WeatherForNow?.counrty,
        let coordinatesLn = WeatherForNow?.geolocation.ln,
        let coordinatesLt = WeatherForNow?.geolocation.lt,
        let pressure = WeatherForNow?.measurement.pressure else {return}
        
        
        windLabel.text = "Wind Speed"
        dateLabel.text = "Date"
        townLabel.text = "Town,Country"
        skyLabel.text = "Weather"
        temperatureLabel.text = "Temperature"
        pressureLabel.text = "Pressure"
        coordinatesLabel.text = "Cooredinates"
        
        if temperature < 0 {
             temperatureDescriptionLabel.textColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        }else if temperature > 0{
            temperatureDescriptionLabel.textColor = UIColor(red:76/255, green: 217/255, blue: 100/255, alpha: 1)
            
        }

        windDescriptionLabel.text = "\(windSpeed)"
        dateDescriptionLabel.text = date
        townDescriptionLabel.text = "\(cityName),\(counrty)"
        skyDescriptionLabel.text = skyDescription
        temperatureDescriptionLabel.text = "\(String(format:"%.2f",temperature)),Max:\(String(format:"%.2f",maxTemperature)),Min:\(String(format:"%.2f",minTemperature))"
        pressureDescriptionLabel.text = "\(pressure)"
        coordinatesDescriptionLabel .text = "\(coordinatesLn),\(coordinatesLt)"
        imageForIcon.sd_setImage(with:skyIcon, placeholderImage: UIImage(named: "placeholder.png"))
        
        
    }
    
}
