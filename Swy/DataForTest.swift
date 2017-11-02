//
//  DataForTest.swift
//  Swy
//
//  Created by Николай Великанец on 01.11.2017.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation
class DataForTest{
    func fillWithTestData()->Weather?{
        
        var cityArr = [String:Any]()
        cityArr  = ["id":1907296,"name":"Saint-Laurent-des-Bâtons","coord":["lat":35.0164,"lon":139.0077],"country":"none"]
        //Saint-Laurent-des-Bâtons Tawaran
        var lastElement2 = [String:Any]()
        lastElement2 = ["dt":Double(1485789200),"main":["temp":262.15,"temp_min":283.76,"temp_max":283.761,"pressure":1017.24,"sea_level":1026.83,"grnd_level":1017.24,"humidity":100,"temp_kf":0],"weather":[["id":800,"main":"Clear","description":"clear sky","icon":"01n"]],"wind":["speed":7.27,"deg":15.0048]]
        if let pre = Weather.init(rawResponseForForecast: lastElement2, cityResponse: cityArr){
            return pre
        }
        /*var lastElement3 = [String:Any]()
        lastElement3 = ["dt":Double(1485864000),"main":["temp":273.15,"temp_min":283.76,"temp_max":283.761,"pressure":1017.24,"sea_level":1026.83,"grnd_level":1017.24,"humidity":100,"temp_kf":0],"weather":[["id":800,"main":"Clear","description":"clear sky","icon":"01n"]],"wind":["speed":7.27,"deg":15.0048]]
        if let pre2 = Weather.init(rawResponseForForecast: lastElement3, cityResponse: cityArr){
            
            forecastArray.append(pre2)
        }
        
        var lastElement = [String:Any]()
        lastElement = ["dt":Double(1485799200),"main":["temp":245.15,"temp_min":283.76,"temp_max":283.761,"pressure":1017.24,"sea_level":1026.83,"grnd_level":1017.24,"humidity":100,"temp_kf":0],"weather":[["id":800,"main":"Clear","description":"clear sky","icon":"01n"]],"wind":["speed":7.27,"deg":15.0048]]
        if let lastElem = Weather.init(rawResponseForForecast: lastElement, cityResponse: cityArr){
            //print("its g \(lastElem)")
            forecastArray.append(lastElem)
        }*/
        return nil
    }
}
