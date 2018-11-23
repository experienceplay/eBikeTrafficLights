//
//  Pinannotation.swift
//  Serial
//
//  Created by tianshu on 2018/1/12.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreLocation
import simd

class PinAnnotationIntersection: NSObject {
    
    struct Location {
        let title: String
        let latitude: Double
        let longitude: Double
        let required_time: Double
    }
    
    
    let locations = [
        
        
        Location(title: "checkPoint1", latitude : -37.799427, longitude : 144.961818, required_time: 300),
        
        Location(title: "checkPoint2", latitude :  -37.799649, longitude : 144.962117, required_time: 0),
        
   
    ]
}














