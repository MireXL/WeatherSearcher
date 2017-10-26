//
//  FiveDaysSavedDataVC.swift
//  Swy
//
//  Created by Николай Великанец on 25.10.2017.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit

class FiveDaysSavedDataVC: UIViewController {
    var WeatherForDate = DescriptionOfData()
    var DateForFetch = ""
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
        let cDataManger = CoreDataManager()
        WeatherForDate = cDataManger.fetchDescription(date: DateForFetch)
        sortingDataFunc()
        print(DateForFetch)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sortingDataFunc(){
       
        if WeatherForDate.temperatureDescription < 0 {
            temperatureDescriptionLabel.textColor = UIColor.lightBlue
        }else if WeatherForDate.temperatureDescription > 0 {
            temperatureDescriptionLabel.textColor = UIColor.salatGreen
        }
        
        windDescriptionLabel.text = WeatherForDate.windDescription
        dateDescriptionLabel.text = WeatherForDate.dateDescription
        townDescriptionLabel.text = WeatherForDate.townDescription
        skyDescriptionLabel.text = WeatherForDate.skyDescriptionL
        temperatureDescriptionLabel.text = "\(String(format:"%.2f",WeatherForDate.temperatureDescription)),Min:\(String(format:"%.2f",WeatherForDate.temperatureMin)),Max:\(String(format:"%.2f",WeatherForDate.temperatureMax))"
        pressureDescriptionLabel.text = "\(WeatherForDate.pressureDescription)"
        coordinatesDescriptionLabel .text = WeatherForDate.coordinatesDescription
        
        
        
    }


}
