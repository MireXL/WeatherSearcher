//
//  FiveDaysTableViewCell.swift
//  Swy
//
//  Created by Николай Великанец on 14.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit

class FiveDaysTableViewCell: UITableViewCell {
    
    
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
    
    @IBOutlet weak var iconImage: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    func  cellFillFunc(cellFiller : Weather) {
       
        let element = cellFiller
        townDescriptionLabel.text = "\(element.cityName),\(element.counrty)"
        coordinatesDescriptionLabel.text = "\(element.geolocation.ln),\(element.geolocation.lt)"
        dateDescriptionLabel.text = "\(element.date)"
        windDescriptionLabel.text = "\( element.windSpeed)"
        skyDescriptionLabel.text = "\(element.sky.description)"
        if element.measurement.temp < 0 {
            
            temperatureDescriptionLabel.textColor = UIColor.lightBlue
            
        }else if element.measurement.temp > 0 {
            temperatureDescriptionLabel.textColor = UIColor.salatGreen
        }else {
            temperatureDescriptionLabel.textColor = UIColor.black
        }
        temperatureDescriptionLabel.text = "\(String(format:"%.2f",element.measurement.temp)),Min:\(String(format:"%.2f",element.measurement.tempMax)),Max:\(String(format:"%.2f",element.measurement.tempMax))"
        
        pressureDescriptionLabel.text = "\(String(format:"%.2f",element.measurement.pressure))"
        
        iconImage.sd_setImage(with: element.sky.weatherIcon,
                              placeholderImage: UIImage(named: "placeholder.png"))
    }
    
}
