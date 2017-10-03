//
//  GraphDraw.swift
//  Swy
//
//  Created by Николай Великанец on 02.10.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import UIKit
import Foundation
class GraphDraw {
    
    func drawGraphFunc(forecast: [Weather], viewHeight: Int) -> (x: [Int], y: [Int], temp: [Int]) {
        var xAxisArr = [Int]()
        var yAxisArr = [Int]()
        var temperatureArr = [Int]()
        var path = 12
        for temp in forecast {
            temperatureArr.append(Int(temp.measurement.temp))
        }
        guard let maxTemp = temperatureArr.max(),
            let minTemp = temperatureArr.min() else {return ([],[],[])}
        let multiplierForMax = Int(viewHeight/maxTemp)
        let multiplierForMin = Int(viewHeight/minTemp)
        var graphMultiplier = Int()
        var yAxis = Int()
       if -multiplierForMin < multiplierForMax &&  multiplierForMin < 0{
            graphMultiplier = -(multiplierForMin-1)/2
        } else  if multiplierForMin < multiplierForMax &&  multiplierForMin < 0{
            graphMultiplier = (multiplierForMax-1)/2
        }else {
            graphMultiplier = multiplierForMax - 1
        }
        for temp in temperatureArr {
            if minTemp < 0 {
                
                if temp < 0 {
                    
                    if  Int(temp)*graphMultiplier > viewHeight {
                        yAxis = viewHeight
                    }else {
                        
                        yAxis = viewHeight/2-Int(temp)*graphMultiplier
                    }
                    
                }else{
                    
                    if  temp*graphMultiplier > viewHeight/2 - 20 {
                        yAxis = 20
                    }else {
                        
                        yAxis = viewHeight/2 - temp*graphMultiplier
                    }
                }              
            }else {
                
                if temp*graphMultiplier > viewHeight - 20 {
                    yAxis = 20
                }else {
                    yAxis = viewHeight - temp*graphMultiplier
                }
            }
            path += 23
            xAxisArr.append(path)
            yAxisArr.append(yAxis)
            
        }
        return (xAxisArr ,yAxisArr,temperatureArr)
    }
    
}

