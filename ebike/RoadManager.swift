//
//  RoadManager.swift
//  Serial
//
//  Created by Hank Shieh on 2018/1/12.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class RoadManager{
    
    //-----------
    final let MIN_SPEED = 1.5 // unit m/s
    final let MAX_OFF_THE_PATH = 70.0 // unit meter
    final let INITIAL_DISTANCE_FROM_PATH = 300.0 // unit meter
    final let INITIAL_NOTIFICATION_RANGE = 50.0...70.0 // unit meter
    final let SECOND_NOTIFICATION_RANGE = 20.0...40.0 // unit meter
    final let MINIMUM_DEGREE_THRESHOLD = 20.0
    //-------------//
    //--------------
    var checkPoints = [CLLocationCoordinate2D]()
    //  var currentLefttime : Double
    
    
    var prevPoint : CLLocationCoordinate2D?
    var pointWithMinDistance : CLLocationCoordinate2D?
    var nextPoint : CLLocationCoordinate2D?
    
    //track user's location
    func traceUserLocation (location : CLLocation) {
        var MinDistanceFromPath = INITIAL_DISTANCE_FROM_PATH // unit meter
        let userCoordinate = location.coordinate
        //check which waypoint is near the user
        for i in 0..<checkPoints.count {
            let newDistance = self.distance(from: userCoordinate, to: checkPoints[i])
            if newDistance < MinDistanceFromPath {
                MinDistanceFromPath = newDistance
                prevPoint = checkPoints[max(i-1,0)]
                pointWithMinDistance = checkPoints[i]
                nextPoint = checkPoints[min(i+1,checkPoints.count - 1)]
                
                
            }
        }
    }
    //Measure Distance
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}

