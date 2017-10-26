//
//  NetwokService.swift
//  Swy
//
//  Created by Николай Великанец on 11.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation
import Alamofire

class NetwokService {
    func getWeatherFrom(searchTypeForUrl :String,completion:@escaping (Any) -> ()){
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?"
            + searchTypeForUrl + "&appid=88827621993174d747441071f4422821", encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                
                return .success
                
            }
            .responseJSON { response in
               
                if let dict = response.result.value as? [String : Any] {
                    print(dict)
                    if dict["cod"] as? String == "404"{
                        
                        completion(404)
                    }
                    guard let weatherDictioanry = dict["weather"] as? [[String: Any]] else { return }
                    
                    
                    if let nowWeatherData = Weather.init(rawResponseForNow: dict, weatherArray: weatherDictioanry){
 
                        //print("d - \(nowWeatherData)")
                        completion(nowWeatherData)
                        
                    }else{
                        
                        print("Eror")
                        completion("NetworkError")
                    }
                    
                }
                else{
                    
                    print("Eror")
                    completion("NetworkError")
                }
        }
    }
    
    func getWeatherForFiveDays(searchTypeForUrl :String,completion:@escaping (Any) -> ()) {
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/forecast?"+searchTypeForUrl+"&appid=88827621993174d747441071f4422821", encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                
                return .success
                
            }
            .responseJSON { response in
                
                if let forecastDictionary = response.result.value as? [String : Any] {
                    if forecastDictionary["cod"] as? String == "404"{
                        
                        completion(404)
                    }
                    guard let weatherDictionary = forecastDictionary["list"] as? [[String: Any]] else { return }
                    
                    
                    guard let CityDictionary = forecastDictionary["city"] as? [String: Any] else { return }
                    
                    var forecastArray = [Weather]()
                    for weatherElement in weatherDictionary{
                        
                        if let forecastData = Weather.init(rawResponseForForecast:weatherElement, cityResponse: CityDictionary) {
                            //print(weatherElement)
                            forecastArray.append(forecastData)
                        }
                    }
                    
                 /*  var cityArr = [String:Any]()
                    cityArr  = ["id":1907296,"name":"Tawarano","coord":["lat":35.0164,"lon":139.0077],"country":"none"]
                    
                     var lastElement2 = [String:Any]()
                    lastElement2 = ["dt":Double(1485799200),"main":["temp":262.15,"temp_min":283.76,"temp_max":283.761,"pressure":1017.24,"sea_level":1026.83,"grnd_level":1017.24,"humidity":100,"temp_kf":0],"weather":[["id":800,"main":"Clear","description":"clear sky","icon":"01n"]],"wind":["speed":7.27,"deg":15.0048]]
                    if let pre = Weather.init(rawResponseForForecast: lastElement2, cityResponse: cityArr){
                        
                        forecastArray.append(pre)
                    }
                    var lastElement3 = [String:Any]()
                     lastElement3 = ["dt":Double(1485799200),"main":["temp":273.15,"temp_min":283.76,"temp_max":283.761,"pressure":1017.24,"sea_level":1026.83,"grnd_level":1017.24,"humidity":100,"temp_kf":0],"weather":[["id":800,"main":"Clear","description":"clear sky","icon":"01n"]],"wind":["speed":7.27,"deg":15.0048]]
                     if let pre2 = Weather.init(rawResponseForForecast: lastElement3, cityResponse: cityArr){
                     
                     forecastArray.append(pre2)
                     }
                    
                      var lastElement = [String:Any]()
                  lastElement = ["dt":Double(1485799200),"main":["temp":245.15,"temp_min":283.76,"temp_max":283.761,"pressure":1017.24,"sea_level":1026.83,"grnd_level":1017.24,"humidity":100,"temp_kf":0],"weather":[["id":800,"main":"Clear","description":"clear sky","icon":"01n"]],"wind":["speed":7.27,"deg":15.0048]]
                    if let lastElem = Weather.init(rawResponseForForecast: lastElement, cityResponse: cityArr){
                        //print("its g \(lastElem)")
                        forecastArray.append(lastElem)
                    }*/
    
                    completion(forecastArray)
                }else{
                    
                    print("Eror")
                    completion("NetworkError")
                }
        }
        
    }
    
}
