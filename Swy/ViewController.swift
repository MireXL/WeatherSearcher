//
//  ViewController.swift
//  Swy
//
//  Created by Николай Великанец on 07.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var typeTextField: UITextField!
    
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var fiveDayWeatherByNameButton: UIButton!
    
    @IBOutlet weak var fiveDayWeatherByGeoButton: UIButton!
    
    @IBOutlet weak var geoButton: UIButton!
    
    @objc var nowWeather = true
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
    
    }
 
    @IBAction func writeText(_ sender: Any) {
        
        guard let whatTyped = typeTextField.text else {return}
        
        let typedTown = String(whatTyped.characters.filter {$0 != " "})
        print("\(typedTown)")
        
        let nameSearcher = NetwokService()
        
        if nowWeather == true{
            
            nameSearcher.getWeatherFrom(searchTypeForUrl: "q=\(typedTown)", completion: { nowWeatherData in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
                secondViewController.WeatherForNow =  nowWeatherData
                self.present(secondViewController, animated: true, completion: nil)
                
            })
        }else{
            
            nameSearcher.getWeatherForFiveDays(searchTypeForUrl: "q=\(typedTown)", completion: { fiveForecast in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "FiveDayTableViewController") as! FiveDayTableViewController
                secondViewController.forecast = fiveForecast
                self.present(secondViewController, animated: true, completion: nil)
            })
            
        }
    }
    
    @IBAction func nowWeatherByGeo(_ sender: Any) {
        
        let getGreoLocation = LocationService()
        
        getGreoLocation.getLocation(completion: { location in
            
            let geoSearcher = NetwokService()
            geoSearcher.getWeatherFrom(searchTypeForUrl: location, completion: { nowWeatherData in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
                secondViewController.WeatherForNow =  nowWeatherData
                self.present(secondViewController, animated: true, completion: nil)
                
                
            })
        })

    }
    
    @IBAction func nowWeatherByName(_ sender: Any) {
        
        typeTextField.placeholder = "Type city "
        typeTextField.isHidden = false
        nowWeather = true
    }
    
    @IBAction func showFiveDayWeatherByGeo(_ sender: Any) {
        let getGreoLocation = LocationService()
        
        getGreoLocation.getLocation(completion: { location in
            
            let fiveDaySearcher = NetwokService()
            fiveDaySearcher.getWeatherForFiveDays(searchTypeForUrl: location, completion: { fiveForecast in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "FiveDayTableViewController") as! FiveDayTableViewController
                secondViewController.forecast = fiveForecast
                self.present(secondViewController, animated: true, completion: nil)
            })
            
        })
        
    }
    
    @IBAction func fiveDayforecastByName(_ sender: Any) {
        typeTextField.placeholder = "Type city "
        typeTextField.isHidden = false
        nowWeather = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
