//
//  MeasurementStructure.swift
//  Swy
//
//  Created by Николай Великанец on 20.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation

struct Measurement {
    let temp: Double
    let pressure : Double
    let tempMin: Double
    let tempMax: Double
    
    init?(rawMainWResponse: [String: Any]) {
        
        guard let data = rawMainWResponse["main"] as? [String:Any],
            let temperature =  data["temp"] as? Double,
            let minTemperature = data["temp_min"] as? Double,
            let maxTemperature = data["temp_max"] as? Double,
            let pressure = data["pressure"] as? Double else { return nil}
        
        self.temp = temperature - 273.15
        self.pressure = pressure
        self.tempMin = minTemperature - 273.15
        self.tempMax = maxTemperature - 273.15
    }
}
