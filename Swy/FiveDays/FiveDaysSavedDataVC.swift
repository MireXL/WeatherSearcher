//
//  FiveDaysSavedDataVC.swift
//  Swy
//
//  Created by Николай Великанец on 25.10.2017.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit

class FiveDaysSavedDataVC: UIViewController {
    var weatherForDate = DescriptionOfData()
    var dateForFetch = ""
    var townForfetch = ""
  
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
        guard let descriptionDate = cDataManger.fetchDescription(date: dateForFetch, town: townForfetch) else {return}
        weatherForDate = descriptionDate
        sortingDataFunc()
        //print(DateForFetch)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sortingDataFunc(){
       
        if weatherForDate.temperatureDescription < 0 {
            temperatureDescriptionLabel.textColor = UIColor.lightBlue
        }else if weatherForDate.temperatureDescription > 0 {
            temperatureDescriptionLabel.textColor = UIColor.salatGreen
        }
        let pattern = "\\b([0-9]|[012][0-9]|):([0-9])([0-9]):([0-9])([0-9])\\b"
        let regex = try? NSRegularExpression(pattern: pattern, options:[])
        guard let date = weatherForDate.dateDescription,
            let match = regex?.firstMatch(in: date, options: [], range: NSRange(location: 0, length: date.count)),
            let town = weatherForDate.townDescription,
            let city = weatherForDate.countryDescription else {return}
        var onlyHourText = ""
        
        for charr in date.enumerated(){
            if match.range.contains(charr.offset){
                
                onlyHourText += "\(charr.element)"
            }
        }
  
        windDescriptionLabel.text = "\(weatherForDate.windDescription)"
        dateDescriptionLabel.text =  onlyHourText
        townDescriptionLabel.text = town + "," + city
        skyDescriptionLabel.text = weatherForDate.skyDescriptionL
        temperatureDescriptionLabel.text = "\(String(format:"%.2f",weatherForDate.temperatureDescription)),Min:\(String(format:"%.2f",weatherForDate.temperatureMin)),Max:\(String(format:"%.2f",weatherForDate.temperatureMax))"
        pressureDescriptionLabel.text = "\(weatherForDate.pressureDescription)"
        coordinatesDescriptionLabel .text = weatherForDate.coordinatesDescription
  
    }
}
