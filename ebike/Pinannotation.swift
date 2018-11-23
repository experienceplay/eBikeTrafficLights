//
//  Pinannotation.swift
//  Serial
//
//  Created by Hank Shieh on 2018/1/12.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreLocation
import simd

class PinAnnotation: NSObject {
    
    struct Location {
        let title: String
        let latitude: Double
        let longitude: Double
        let required_time: Double
        let rough_expected_speed: Double
    }

    
    let locations = [
        


//--------//Simpson+Powlett+Clarendon+POS at Eades
//-37.811028, 144.988905 simpson
//-37.811149, 144.988934 simpson
//
        Location(title: "Simpson_front", latitude :  -37.811149, longitude : 144.988934, required_time: 273*3.6/22, rough_expected_speed: 22/3.6),
//-37.810730,144.985959 ACQUIRE SPEED
//-37.810816,144.986125
        Location(title: "Powlett_front", latitude :  -37.810816, longitude : 144.986125, required_time: 271*3.6/22, rough_expected_speed: 22/3.6),
//-37.810461,144.983386
//-37.810524, 144.983503
//-37.810490, 144.983546 OK SOUND
        Location(title: "Clarendon_front", latitude :  -37.810490, longitude : 144.983546, required_time: 258*3.6/22, rough_expected_speed: 22/3.6),
        
        Location(title: "Eades_front", latitude :  -37.810176, longitude : 144.980848, required_time: 0, rough_expected_speed: 0),
 //
        
    ]
    let intersection = [
        
//234m 22km/h
//-37.810816, 144.986125
//-37.810771, 144.985986
        Location(title: "Powlett_back", latitude :  -37.810771, longitude : 144.985986, required_time: 38.29, rough_expected_speed: 15/3.6),
//234m 15km/h
//-37.810524, 144.983503
//-37.810460, 144.983358
//-37.810443, 144.983240
        Location(title: "Clarendo_back", latitude :  -37.810443, longitude : 144.983240, required_time: 56.16, rough_expected_speed: 22/3.6),
//250m 22km/h
//-37.810125,144.980848
//-37.810167, 144.980749


        Location(title: "Eades_back", latitude :   -37.810167, longitude : 144.980749, required_time: 40.9, rough_expected_speed: 0),
    ]
    
    let location_corner = [
        
        //234m 22km/h
        //-37.810816, 144.986125
        //-37.810771, 144.985986
        Location(title: "Powlett", latitude :  -37.810771, longitude : 144.985986, required_time: 38.29, rough_expected_speed: 15/3.6),
        //234m 15km/h
        //-37.810524, 144.983503
        //-37.810460, 144.983358
        //-37.810443, 144.983240
        Location(title: "Clarendo", latitude :  -37.810443, longitude : 144.983240, required_time: 56.16, rough_expected_speed: 22/3.6),
        //250m 22km/h
        //-37.810125,144.980848
        //-37.810167, 144.980749
        
        Location(title: "Eades", latitude :   -37.810167, longitude : 144.980749, required_time: 40.9, rough_expected_speed: 0),
        ]
    
    
}





