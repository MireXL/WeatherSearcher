//
//  CoordinateStructre.swift
//  Swy
//
//  Created by Николай Великанец on 12.09.17.
//  Copyright © 2017 RockinHat. All rights reserved.
//

import Foundation

struct Coordinates {
    let ln: Double
    let lt:Double
    
    init?(rawCoordResponse : [String: Any]) {
       
        guard let cord = rawCoordResponse["coord"] as? [String:Any],
            let lon = cord["lon"] as? Double,
            let lat = cord["lat"] as? Double else {return nil}
        
         self.ln = lon
        self.lt = lat
    }
}

