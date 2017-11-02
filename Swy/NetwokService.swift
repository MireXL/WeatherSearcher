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
    
    func getWeatherFrom(params : [String:Any],completion:@escaping (Any) -> ()){
       let url = "http://api.openweathermap.org/data/2.5/weather?"
        var params = params
        params["appid"] = "88827621993174d747441071f4422821"
        Alamofire.request(url,
                         method: .get,
                         parameters: params)
            .validate { request, response, data in
                
                return .success
                
            }
            .responseJSON { response in
               
                if let dict = response.result.value as? [String : Any] {
                  //  print(dict)
                    if dict["cod"] as? String == "404"{
                        
                        completion(404)
                    }
                    guard let weatherDictioanry = dict["weather"] as? [[String: Any]] else { return }  
                    
                    if let nowWeatherData = Weather.init(rawResponseForNow: dict, weatherArray: weatherDictioanry){
 
                        //print("d - \(nowWeatherData)")
                        completion(nowWeatherData)
                        
                    }else{
                        
                        print("ErrorErorNetworkOneDay1")
                        completion("NetworkError")
                    }
                    
                }
                else{
                    
                    print("ErrorNetworkOneDay2")
                    completion("NetworkError")
                }
        }
    }
    func getWeatherForFiveDays(params : [String:Any],completion:@escaping (Any) -> ()) {
        let url = "http://api.openweathermap.org/data/2.5/forecast"
        var params = params
        params["appid"] = "88827621993174d747441071f4422821"
    
        Alamofire.request(url,
                          method: .get,
                          parameters: params)
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
                    // print("tset working")
                    let testData = DataForTest()
                    guard let dataForTest = testData.fillWithTestData() else {return}
                    forecastArray.append(dataForTest)
                    completion(forecastArray)
                }else{
                    
                    print("ErrorNetwork5days")
                    completion("NetworkError")
                }
        }
        
    }
    
}
