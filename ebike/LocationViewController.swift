//
//  LocationViewController.swift
//  Serial
//
//  Created by Hank Shieh on 2018/1/12.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI
import MediaPlayer

class LocationViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate {

//--------------------------------------------------------------------//Setting
    @IBOutlet weak var DistanceIndividualRouteDynamicLabel: UILabel!
    @IBOutlet weak var TimeIndividualRouteDynamicLabel: UILabel!
    @IBOutlet weak var TimeIndividualRouteFixedLabel: UILabel!
    @IBOutlet weak var DistanceIndividualRouteFixedLabel: UILabel!
    @IBOutlet weak var SpeedLabel: UILabel!
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var SpeedReferenceLabel: UILabel!
    @IBOutlet weak var userspeedLabel: UILabel!
    
    @IBOutlet weak var ExpectedLeftTimeIndividualRouteLabel: UILabel!
    

    
    @IBOutlet weak var CurrentLeftTimerTotalLabel: UILabel!
    
    @IBAction func StartPressed(_ sender: Any)
    {
        dataManager.userLocation.removeAll(keepingCapacity: false) //clear past information for the user's location
        coords.removeAll(keepingCapacity: false)
        let removeOverlays : [AnyObject]! = self.mapView.overlays
        self.mapView.removeOverlays(removeOverlays as! [MKOverlay])
        StartButton.isHidden = false
        mapView.isHidden = false
        StopButton.isHidden = false
      
        
        detection_flag = true
        
        
    }
    
    @IBAction func StopPressed(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.detection_flag = false
            self.NumberforVoltage = 0
            self.currentLeftTotalTime_dynamic = 0
            serial.sendMessageToDevice("0")
            self.showRoute()
        }
        
        send()


    }
    
    func send(){
        let sendMailAlert = UIAlertController(title: "Email Testing Data Notification", message: "Would you like to receive an email about the control system parameters details of this participant?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void  in
            print("pressed the cancel button")
        })
        let ok =  UIAlertAction(title: "OK", style: .default, handler: {[unowned self] (action) -> Void in
            //send email and then clean up
            self.sendFileToMail()
        })
        sendMailAlert.addAction((ok))
        sendMailAlert.addAction((cancel))
        self.present(sendMailAlert, animated: true, completion: nil)
    }

    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    @IBAction func GenreButtonTapped(_ sender: UIButton)
    {
        audio.play_music(file: "celebration-1", format: "mp3")
    }
    
//-------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
//configure buttons & label
        StartButton.isHidden = false
        StopButton.isHidden = false
        
        TimeIndividualRouteFixedLabel.isHidden = true
        DistanceIndividualRouteFixedLabel.isHidden = true
        
        //---//
        SpeedLabel.isHidden = true
        SpeedReferenceLabel.isHidden = true
        CurrentLeftTimerTotalLabel.isHidden = true
        
  
        DistanceIndividualRouteDynamicLabel.isHidden = true
        TimeIndividualRouteDynamicLabel.isHidden = true
        ExpectedLeftTimeIndividualRouteLabel.isHidden = true
        userspeedLabel.isHidden = true
    
        mapView.isHidden = false
        
        traceUserLocation(location: locationManager.location!)   //draw the route between the user and the next checkpoint, acquire the time left and calculate the speed.
        sendfunctiontimer()
    }
//---------------------------------------------------------------------------------------//
//Define function
    let locationManager = CLLocationManager()
    fileprivate let pins = PinAnnotation()
    fileprivate let pinsIntersection = PinAnnotationIntersection()
    fileprivate let roadManager = RoadManager()
    fileprivate let dataManager = DataManager()
    fileprivate let music = Musicfeedback()
    fileprivate let audio = Audiofeedback()
    
    let control = Control()
    
//used for user location display
    var coords = [CLLocationCoordinate2D]()
 
    var lastlefttime : Double = 0
  
    var speed_current : Double = 0
    var speed_expected : Double = 0
    var speed_reference : Double = 0
    var Voltage_current : Double = 0
    var NumberforVoltage : Int = 0
    var detection_flag : Bool = false
    let INITIAL_DISTANCE_FROM_PATH: Double = 50.0 // unit meter
    let DISTANCE_FOR_SOUND : Double = 15
    
    
    var currentLeftTotalTime_dynamic : Double = 0
    var currentLeftTime_dynamic : Double = 0
    var currentLefttime_fix : Double = 0
    var currentLeftdistance : Double = 0
    var currentLeftdistance_dynamic : Double = 0
    var currentExpectedTime_dynamic : Double = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//------------//Initialization
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        showRoute()
    }


//----------------------------------------------------------------------------//function
//Send the file to the email address
    func sendFileToMail() {
        dataManager.createCSV()
        
        //send email
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
//Configure Mail Composer Interface
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["...@student.unimelb.edu.au"]) // trype in the email for mail application
        mailComposerVC.setSubject("Ebike_Participant_Data")
        mailComposerVC.setMessageBody("Hi, \n\nThe .csv data export is attached\n\n\nSent from Smart e-bike app", isHTML: false)
        
        let fileURL = URL(fileURLWithPath: dataManager.tmpDir).appendingPathComponent(dataManager.fileName)
        do {
            try mailComposerVC.addAttachmentData(NSData(contentsOf: fileURL) as Data, mimeType: "text/csv", fileName: dataManager.fileName)
            print("File Data Loaded")
        } catch {
            print("fail to attach file")
            print("\(error)")
        }
        return mailComposerVC
    }
    
//Condition when there's something wrong with sending mail
    func showSendMailErrorAlert() {
        DispatchQueue.main.async { [unowned self] in
            let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            sendMailErrorAlert.addAction(OKAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dataManager.deleteFile()
        controller.dismiss(animated: true, completion: nil)
    }

//----------------------------------------------------//
    func showRoute()
    {
        let locations = pins.locations

        for location in locations
        {
            let annotation = MKPointAnnotation()
            
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            currentLeftTotalTime_dynamic = currentLeftTotalTime_dynamic + location.required_time

            roadManager.checkPoints.append(annotation.coordinate)
            mapView.addAnnotation(annotation)
            
        }


//----//draw line between point and point
        for i in 0..<pins.locations.count{
            
            var directions : MKDirections
 
            directions = directionget(sourcecoordinate: CLLocationCoordinate2DMake(pins.locations[i].latitude, pins.locations[i].longitude), destcoordinate: CLLocationCoordinate2DMake(pins.locations[min(i+1,pins.locations.count - 1)].latitude, pins.locations[min(i+1,pins.locations.count - 1)].longitude))
            directions.calculate
                {
                    (response, error) in
                    guard let response = response else
                    {
                        if error != nil
                        {
                            print("something went wrong ")
                        }
                        return
                    }
//drawing the optimal routes
                    
                    var route: MKRoute
                    route = response.routes[0]
                    
                    route.polyline.title = "pathToFollow2"
                    self.mapView.add(route.polyline)
            }
            
        }
        
    }
    
//------------------draw user's route
    func drawUserPolyLine(userLocation: CLLocation) {
        
        
        coords.append(userLocation.coordinate)
      
        let polyLine = MKPolyline(coordinates: &coords, count: coords.count)
        polyLine.title = "userPath"
        self.mapView.add(polyLine)
        
    }
    
//----------Display range of map
    func mapRegion() -> MKCoordinateRegion
    {
        if let currentLocation = dataManager.userLocation.last
        {
            return MKCoordinateRegion (
                center: currentLocation.coordinate,
                span: MKCoordinateSpanMake(0.01, 0.01))
        }
        else
        {
            return MKCoordinateRegion (
                center: CLLocationCoordinate2D(latitude: -25.274398, longitude: 133.77513599999997),
                span: MKCoordinateSpanMake(3.8, 3.8))
        }
    }
//------------------Measure Distance
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance
    {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }

//-----Measure Distance and acquire required time--------//
    
    func traceUserLocation (location : CLLocation)
    {
        let userCoordinate = location.coordinate
//waypoint used for pinpoint which waypoint the user is
 
        audio.feedback_intersection(userCoordinate: userCoordinate, locations: pins.intersection, INITIAL_DISTANCE_FROM_PATH: DISTANCE_FOR_SOUND)
        for i in 0..<pins.locations.count
        {
            let newDistance = self.distance(from: userCoordinate, to: CLLocationCoordinate2DMake(pins.locations[i].latitude, pins.locations[i].longitude))
            if newDistance < INITIAL_DISTANCE_FROM_PATH
                    {
                            currentLefttime_fix = pins.locations[i].required_time
                            currentLeftTime_dynamic = pins.locations[i].required_time
                            lastlefttime = pins.locations[i].required_time
                            speed_expected = pins.locations[i].rough_expected_speed
                        
                            var directions_route_fixed: MKDirections
                            var directions_route_dynamic: MKDirections
 
                            directions_route_fixed = directionget(sourcecoordinate: CLLocationCoordinate2DMake(pins.locations[i].latitude, pins.locations[i].longitude), destcoordinate: CLLocationCoordinate2DMake(pins.locations[min(i+1,pins.locations.count - 1)].latitude, pins.locations[min(i+1,pins.locations.count - 1)].longitude))
                        
                            directions_route_dynamic = directionget(sourcecoordinate: userCoordinate, destcoordinate: CLLocationCoordinate2DMake(pins.locations[min(i+1,pins.locations.count - 1)].latitude, pins.locations[min(i+1,pins.locations.count - 1)].longitude))
                            directions_route_fixed.calculate
                                    {
                                            (response, error) in
                                            guard let response = response else
                                            {
                                                    if error != nil
                                                    {
                                                        print("something went wrong ")
                                                    }
                                                    return
                                            }
//drawing the optimal routes
                                        var route: MKRoute
                                        route = response.routes[0]
                        
                                        //         self.mapView.add(route.polyline, level: .aboveRoads)
                        
                                        var rekt: MKMapRect?
                                        rekt = route.polyline.boundingMapRect
                                        self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt!), animated: true)
                        
                                        //显示需要距离 display required distance
                                        self.currentLeftdistance = (response.routes.first?.distance)!
                                //        self.DistanceIndividualRouteFixedLabel.text = "The fixed distance for route:" + String(self.currentLeftdistance)+"m"
                        
                                        route.polyline.title = "pathToFollow2"
                                        self.mapView.add(route.polyline)
                                    }
                        directions_route_dynamic.calculate
                            {
                                (response, error) in
                                guard let response = response else
                                {
                                    if error != nil
                                    {
                                        print("something went wrong ")
                                    }
                                    return
                                }
                                //drawing the optimal routes
                                var route: MKRoute
                                route = response.routes[0]
                                //display required distance
                                self.currentLeftdistance_dynamic = (response.routes.first?.distance)!
                            
                                
                        }
                        
                            }
                        else
                                {
                                    currentLefttime_fix = lastlefttime
                                }
        }
    }
    
//--Configure color of lines in the map-//
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.alpha = 0.7
        renderer.lineWidth = 4.0
        

        if overlay.title!! == "userPath"
        {
            renderer.strokeColor = UIColor.green
        }
        else if overlay.title!! == "pathToFollow2"
        {
            renderer.strokeColor = UIColor.red
        }
        return renderer
    }
    
    
//--Update location-//
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
            for location in locations
                {
                    dataManager.userLocation.append(location)  //record user's address
                    drawUserPolyLine(userLocation: location)   //draw user's route
                    traceUserLocation(location: location)
//update left tiem and expected speed+user's speed
            
                   
                    
                    self.SpeedLabel.text = "The expected speed :" + String(format:"%2f",speed_expected)+"m/s"
                    
                }
        
        userspeedLabel.text = "Userspeed:" + String(locations[0].speed)
        DistanceIndividualRouteDynamicLabel.text = "The Left distance for route:" + String(currentLeftdistance_dynamic)+"m"
        CurrentLeftTimerTotalLabel.text = "Count Down Timer:" + String(currentLeftTotalTime_dynamic)
        
//display current speed
        speed_current = locations[0].speed
        currentExpectedTime_dynamic = currentLeftdistance_dynamic/speed_current 
        
        ExpectedLeftTimeIndividualRouteLabel.text = "Expected Left Time:" + String(currentExpectedTime_dynamic)
            + "s"
        
        audio.slowdownfeedback(userspeed: speed_current, LeftDistance: currentLeftdistance_dynamic, LeftTimeIndividualRoute: currentLeftTime_dynamic)
        
 
        
    }
//------------------------------------------------------------------------------//
    func sendfunctiontimer()
    {
        let interval : Int = 1200000
        let queue = DispatchQueue.global(qos: .default)
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        
        timer.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: DispatchTimeInterval.microseconds(interval))
 
        let workItem = DispatchWorkItem
        {
            if self.currentLeftTotalTime_dynamic <= -1000
             {
                timer.cancel()
             }else
             {
       
           
                if self.detection_flag == true
                {
                    self.currentLeftTotalTime_dynamic = self.currentLeftTotalTime_dynamic - 1.5
                    self.currentLeftTime_dynamic = self.currentLeftTime_dynamic - 1.5
                    serial.sendMessageToDevice(String(self.NumberforVoltage))
                }
                else{
                    self.NumberforVoltage = 0
                    serial.sendMessageToDevice("0")
                    
                }
                DispatchQueue.main.async {
      
                    self.TimeIndividualRouteDynamicLabel.text = "Left Time for individual route:" + String(self.currentLeftTime_dynamic) + "s"
                    self.NumberforVoltage = self.control.PID_realize(speed_current: self.speed_current, speed_reference: self.speed_expected)
                    self.SpeedReferenceLabel.text = "Voltage level:" + String(self.NumberforVoltage)
                
                    
                }
                
             }
        }
        timer.setEventHandler(handler: workItem)
        timer.resume()
    }
    
    
    func directionget(sourcecoordinate: CLLocationCoordinate2D,destcoordinate : CLLocationCoordinate2D) -> MKDirections
    {
        let destCoordinate = destcoordinate
        let destPlacemark = MKPlacemark(coordinate: destCoordinate)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        var sourceCoordinate: CLLocationCoordinate2D?
        sourceCoordinate = sourcecoordinate
        
        var sourcePlacemark: MKPlacemark?
        sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate!)
        
        var sourceItem: MKMapItem
        sourceItem = MKMapItem(placemark: sourcePlacemark!)
        
        var directionRequest: MKDirectionsRequest?
        directionRequest = MKDirectionsRequest()
        directionRequest?.source = sourceItem
        directionRequest?.destination = destItem
        directionRequest?.transportType = .walking
    
        var directions: MKDirections
        directions = MKDirections(request: directionRequest!)
        return directions
    }
}
