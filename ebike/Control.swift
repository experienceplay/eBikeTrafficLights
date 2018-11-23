//
//  Control.swift

//  Created by Hank Shieh on 2018/1/12.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import Foundation
import Foundation
import CoreBluetooth
import QuartzCore
import CoreLocation

class Control: NSObject
{

    struct PID {
                var speed_reference : CLLocationSpeed
                var speed_current : CLLocationSpeed
                var voltage_current : Double
                var ek :Double
                var ek_next : Double//k-1
                var ek_last : Double//k-2
                var kp : Double
                var ki : Double
                var kd : Double
                }
    var PID1 = PID(speed_reference: 0, speed_current: 0, voltage_current: 0, ek: 0, ek_next: 0, ek_last: 0, kp: 0.6, ki: 0.3, kd: 0.03)
    var Voltage_expected : Double = 0
    var NumberforVoltage : Int = 0

     //----//calculate the reference speed
        func PID_realize(speed_current : CLLocationSpeed, speed_reference :CLLocationSpeed) -> Int {
                PID1.speed_current = speed_current
                PID1.speed_reference = speed_reference
                PID1.ek = PID1.speed_reference - PID1.speed_current
            
                var incrementVoltage : Double


            if PID1.ek <= 0.1 && PID1.ek >= 0{
                incrementVoltage = 0
            }
            else
            {
                incrementVoltage = PID1.kp * (PID1.ek - PID1.ek_next) + PID1.ki * PID1.ek + PID1.kd * (PID1.ek - 2*PID1.ek_next + PID1.ek_last)
            }
   
            if PID1.ek >= 5
            {
                PID1.voltage_current = 3.35
            }
            else
            {
                PID1.voltage_current = incrementVoltage + PID1.voltage_current
                if PID1.voltage_current > 3.35
                {
                    PID1.voltage_current = 3.35
                }
                if PID1.voltage_current < 1.4
                {
                    PID1.voltage_current = 1.4
                }
             
            }
     
            
   
    //            incrementVoltage = PID1.kp * (PID1.ek - PID1.ek_next) + PID1.ki * PID1.ek + PID1.kd * (PID1.ek - 2*PID1.ek_next + PID1.ek_last)
               // PID1.voltage_current = incrementVoltage + PID1.voltage_current
                
                PID1.ek_last = PID1.ek_next
                PID1.ek_next = PID1.ek
            
            
            
            
      
            if PID1.speed_current > 0.6
            {
                NumberforVoltage = Int((PID1.voltage_current/0.05) - 28 + 1)
            }
            else{
                NumberforVoltage = 0
            }
             return(NumberforVoltage)
    
            }
   
}
