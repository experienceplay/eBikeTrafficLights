//
//  audiofeedback.swift
//  Serial
//
//  Created by Hank Shieh on 2018/3/27.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import Foundation
import MediaPlayer
import MapKit
import CoreLocation

class Musicfeedback: NSObject
{
   // let pin_intersection = PinAnnotationIntersection()
    
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    func playGenre(genre: String)
    {
        
        musicPlayer().stop()
        let query = MPMediaQuery()
        let predicate  = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
        
        query.addFilterPredicate(predicate)
        
        musicPlayer().setQueue(with: query)
        musicPlayer().shuffleMode = .songs
        musicPlayer().play()
        
        let time: TimeInterval = 10.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time)
        {
            self.musicPlayer().stop()
        }
 
    }
    
    func play(genre: String)
    {
        MPMediaLibrary.requestAuthorization
            { (status) in
            if status == .authorized
                {
                    DispatchQueue.main.async
                        {
                            self.playGenre(genre: genre)
                        }
                
                }
            }
    }
    
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance
    {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    
    func feedback(userCoordinate: CLLocationCoordinate2D, locations: [PinAnnotation.Location], INITIAL_DISTANCE_FROM_PATH: Double)
    {
        var lastDistance : Double = 0
        var newDistance : Double = 0
        for i in 0..<locations.count
        {
            
            newDistance = self.distance(from: userCoordinate, to: CLLocationCoordinate2DMake(locations[i].latitude, locations[i].longitude))
            
            
            
            
            if newDistance < INITIAL_DISTANCE_FROM_PATH
         //   if newDistance < INITIAL_DISTANCE_FROM_PATH
            {
               // if MPMusicPlayerController.systemMusicPlayer().playbackState == .playing
                if (AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint)
                {
                    
                }
                else{
                    play(genre: "Pop")
                    print("1")
                    
                }
                
            }
            lastDistance = newDistance
        }
    }
    
   

}

