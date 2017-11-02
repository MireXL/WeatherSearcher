//
//  WeatherStructure.swift
//  Swy
//
//  Created by Николай Великанец on 20.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation

struct Weather {
    let sky: Sky
    let measurement : Measurement
    let windSpeed : Double
    let date : String
    let cityName : String
    let counrty : String
    let geolocation : Coordinates
    
    init?(rawResponseForNow: [String: Any],weatherArray: [[String:Any]]) {
        
        guard
            let skyDetails = Sky(rawWeatherResponse: weatherArray),
            let MeasurementDetails =  Measurement(rawMainWResponse: rawResponseForNow),
            let wind = rawResponseForNow["wind"] as? [String:Any],
            let windSpeedInit = wind["speed"] as? Double,
            let dateDetails = rawResponseForNow["dt"] as? Double,
            let CityDetails = rawResponseForNow["sys"] as? [String:Any],
            let countryOfTheCity = CityDetails["country"] as? String,
            let name = rawResponseForNow["name"]as? String,
            let coordinates = Coordinates(rawCoordResponse: rawResponseForNow)
            else { return nil }
        
        let dateConverter = NSDate(timeIntervalSince1970: TimeInterval(dateDetails))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: dateConverter as Date)
        
        self.sky = skyDetails
        self.measurement = MeasurementDetails
        self.windSpeed = windSpeedInit
        self.date = localDate
        self.cityName = name
        self.counrty = countryOfTheCity
        self.geolocation = coordinates
    }
    
    init?(rawResponseForForecast : [String: Any],cityResponse:[String:Any]) {
        
        guard let skyResponser = rawResponseForForecast["weather"] as? [[String:Any]],
            let skyDetails = Sky(rawWeatherResponse: skyResponser),
            let MeasurementDetails =  Measurement(rawMainWResponse:rawResponseForForecast),
            let wind = rawResponseForForecast["wind"] as? [String:Any],
            let windSpeedInit = wind["speed"] as? Double,
            let countryInit = cityResponse["country"] as? String,
            let nameInit = cityResponse["name"] as? String,
            let dateDetails = rawResponseForForecast["dt"] as? Double,
            let coordinates = Coordinates(rawCoordResponse: cityResponse)
            else {return nil }
        
        
        let dateConverter = NSDate(timeIntervalSince1970: TimeInterval(dateDetails))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: dateConverter as Date)
        
        self.sky = skyDetails
        self.measurement = MeasurementDetails
        self.windSpeed = windSpeedInit
        self.date = localDate
        self.cityName = nameInit
        self.counrty = countryInit
        self.geolocation = coordinates
    
    }
}
