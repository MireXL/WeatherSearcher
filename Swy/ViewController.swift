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
    
    @IBOutlet weak var activityIndicatorForApiRequest: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var fiveDayWeatherByNameButton: UIButton!
    
    @IBOutlet weak var fiveDayWeatherByGeoButton: UIButton!
    
    @IBOutlet weak var geoButton: UIButton!
    
    @objc var nowWeather = true
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        UIView.animate(withDuration: 0.5, delay: 0,
                       options: .curveEaseOut, animations: {
                        self.nameButton.center.x -= self.view.bounds.width
        })
        UIView.animate(withDuration: 0.5, delay: 0.2,
                       options: .curveEaseOut, animations: {
                        self.geoButton.center.x -= self.view.bounds.width

        })
        UIView.animate(withDuration: 0.5, delay: 0.3,
                       options: .curveEaseOut, animations: {
                        self.fiveDayWeatherByGeoButton.center.x += self.view.bounds.width
                        
        })
        UIView.animate(withDuration: 0.5, delay: 0.4,
                       options: .curveEaseOut, animations: {
                        self.fiveDayWeatherByNameButton.center.x += self.view.bounds.width
                        
        })
        
    }
    func showWeatherForNow(nowWeatherData : Any){
        if nowWeatherData as? Int == 404 {
            self.errorLabel.isHidden = false
            self.errorLabel.text  = "City not found"
        } else if nowWeatherData as? String == "NetworkError"{
            self.errorLabel.isHidden = false
            self.errorLabel.text  = "Network Error"
        }else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            secondViewController.WeatherForNow =  nowWeatherData as? Weather
            secondViewController.modalTransitionStyle = .flipHorizontal
            self.present(secondViewController, animated: true, completion: nil)
        }
        
    }
    func showFiveDayForecast(fiveForecast : Any){
        if fiveForecast as? Int == 404 {
            self.errorLabel.isHidden = false
            self.errorLabel.text  = "City not found"
        }else if fiveForecast as? String == "NetworkError"{
            self.errorLabel.isHidden = false
            self.errorLabel.text  = "Network Error"
        }else {
            guard let fiveData = fiveForecast as? [Weather] else {return}
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "FiveDayTableViewController") as! FiveDayTableViewController
            secondViewController.forecast = fiveData
            secondViewController.modalTransitionStyle = .flipHorizontal
            self.present(secondViewController, animated: true, completion: nil)
        }
        
    }
    @IBAction func writeText(_ sender: Any) {
        activityIndicatorForApiRequest.startAnimating()
        
        guard let whatTyped = typeTextField.text else {return}
        
        let typedTown = String(whatTyped.characters.filter {$0 != " "})
        print("\(typedTown)")
        
        let nameSearcher = NetwokService()
        
        if nowWeather == true{
            
            nameSearcher.getWeatherFrom(searchTypeForUrl: "q=\(typedTown)", completion: { nowWeatherData in
                self.activityIndicatorForApiRequest.stopAnimating()
                self.showWeatherForNow(nowWeatherData: nowWeatherData)
            })
        }else{
            
            nameSearcher.getWeatherForFiveDays(searchTypeForUrl: "q=\(typedTown)", completion: { fiveForecast in
                self.activityIndicatorForApiRequest.stopAnimating()
                self.showFiveDayForecast(fiveForecast: fiveForecast)
            })
            
        }
    }
    
    @IBAction func nowWeatherByGeo(_ sender: Any) {
        activityIndicatorForApiRequest.startAnimating()
        
        LocationService.sharedInstance.getLocation(completion: { location in
            
            let geoSearcher = NetwokService()
            geoSearcher.getWeatherFrom(searchTypeForUrl: location, completion: { nowWeatherData in
                self.activityIndicatorForApiRequest.stopAnimating()
                self.showWeatherForNow(nowWeatherData: nowWeatherData)
            })
        })
        
    }
    
    @IBAction func nowWeatherByName(_ sender: Any) {
        
        typeTextField.placeholder = "Type city "
        typeTextField.isHidden = false
        nowWeather = true
    }
    
    @IBAction func showFiveDayWeatherByGeo(_ sender: Any) {
        activityIndicatorForApiRequest.startAnimating()
        LocationService.sharedInstance.getLocation(completion: { location in
            
            let fiveDaySearcher = NetwokService()
            fiveDaySearcher.getWeatherForFiveDays(searchTypeForUrl: location, completion: { fiveForecast in
                self.activityIndicatorForApiRequest.stopAnimating()
                self.showFiveDayForecast(fiveForecast: fiveForecast)
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
