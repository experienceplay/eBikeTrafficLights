//
//  Audioback.swift
//  Serial
//
//  Created by Hank Shieh on 2018/3/30.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import Foundation
import AVFoundation
import MapKit
import CoreLocation

class Audiofeedback: NSObject
{
    var audioPlayer = AVAudioPlayer()
    
    
    func play_music(file: String, format: String)
    {
        let url = Bundle.main.url(forResource: file, withExtension: format)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
          audioPlayer.play()
    }
    
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance
    {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    var soundenable : Bool = true
    var soundenable_slowdown : Bool = true
    func feedback_intersection(userCoordinate: CLLocationCoordinate2D, locations: [PinAnnotation.Location], INITIAL_DISTANCE_FROM_PATH: Double)
    {
        var newDistance : Double = 0
        for i in 0..<locations.count
        {
            
            newDistance = self.distance(from: userCoordinate, to: CLLocationCoordinate2DMake(locations[i].latitude, locations[i].longitude))
            
            
            
          
            if newDistance < INITIAL_DISTANCE_FROM_PATH && soundenable == true
            {
               
                soundenable = false
                let delayQueue = DispatchQueue(label: "after10secondsenablesound", qos: .userInitiated)
                let additionalTime: DispatchTimeInterval = .seconds(10)
                
                delayQueue.asyncAfter(deadline: .now() + additionalTime) {
                    self.soundenable = true
                }

                if (AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint)
                {
                    
                }
                else
                {
                    play_music(file: "celebration-3", format: "mp3")
                    
                }
            }
        }
    }
    
    func slowdownfeedback(userspeed: Double, LeftDistance: Double, LeftTimeIndividualRoute: Double)
    {
        
        if (LeftDistance/userspeed + 10 < LeftTimeIndividualRoute) && (LeftDistance/userspeed > 0) || (userspeed > 6.8) && (soundenable_slowdown == true)
        {
            soundenable_slowdown = false
            let delayQueue_slowdown = DispatchQueue(label: "after3secondsenableslowdownsound", qos: .userInitiated)
            let additionalTime_slowdown: DispatchTimeInterval = .seconds(3)
            
            delayQueue_slowdown.asyncAfter(deadline: .now() + additionalTime_slowdown) {
                self.soundenable_slowdown = true
            }
            if (AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint)
            {
                
            }
            else
            {
                
                   play_music(file: "slow-down", format: "mp3")

            }
        }
    }
}

