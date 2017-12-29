//
//  WeatherStructure.swift
//  Swy
//
//  Created by Николай Великанец on 12.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation

struct  Sky {
    let description : String
    let weatherIcon : URL
    
    init?(rawWeatherResponse: [[String: Any]]) {
        var temporaryDescription = ""
        var temopraryIcon = URL(string: "")
        for element  in rawWeatherResponse{
            if let descriptionWreatherArray = element ["description"] as? String,
                let icon = element ["icon"] as? String{
                
                temporaryDescription  += descriptionWreatherArray
                temopraryIcon = URL(string: "http://openweathermap.org/img/w/\(icon).png")
            }
    
        }
        guard let iconForWeather = temopraryIcon else {return nil }
        self.description = temporaryDescription
        self.weatherIcon = iconForWeather
    }
    
}


