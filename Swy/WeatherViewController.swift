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
    
    func sortingDataFunc(){
        guard let weatherData = WeatherForNow else {return}
        
        if weatherData.measurement.temp < 0 {
             temperatureDescriptionLabel.textColor = UIColor.lightBlue
        }else if weatherData.measurement.temp > 0 {
            temperatureDescriptionLabel.textColor = UIColor.salatGreen
        }

        windDescriptionLabel.text = "\(weatherData.windSpeed)"
        dateDescriptionLabel.text = weatherData.date
        townDescriptionLabel.text = "\(weatherData.cityName),\(weatherData.counrty)"
        skyDescriptionLabel.text = weatherData.sky.description
        temperatureDescriptionLabel.text = "\(String(format:"%.2f",weatherData.measurement.temp)),Max:\(String(format:"%.2f",weatherData.measurement.tempMax)),Min:\(String(format:"%.2f",weatherData.measurement.tempMin))"
        pressureDescriptionLabel.text = "\(weatherData.measurement.pressure)"
        coordinatesDescriptionLabel .text = "\(weatherData.geolocation.ln),\(weatherData.geolocation.lt)"
        imageForIcon.sd_setImage(with:weatherData.sky.weatherIcon, placeholderImage: UIImage(named: "placeholder.png"))
        
        
    }
    
}
