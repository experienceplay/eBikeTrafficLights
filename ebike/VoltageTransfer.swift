//
//  VoltageTransfer.swift
//  Serial
//
//  Created by tianshu on 2018/1/15.
//  Copyright © 2018年 Balancing Rock. All rights reserved.
//

import Foundation
import simd

class VoltageTransfer : NSObject{
    
    struct VoltageNumber {
        let Number : Int
        let Voltage: Double
    }
    var Voltage_reference : Double = 0
        
    
    let VoltageNumbers =
        [
            VoltageNumber(Number: 0, Voltage: 0),
            VoltageNumber(Number: 1, Voltage: 1.4),
            VoltageNumber(Number: 1188, Voltage: 1.45),
            VoltageNumber(Number: 1229, Voltage: 1.5),
            VoltageNumber(Number: 1270, Voltage: 1.55),
            VoltageNumber(Number: 1311, Voltage: 1.6),
            VoltageNumber(Number: 1352, Voltage: 1.65),
            VoltageNumber(Number: 1393, Voltage: 1.7),
            VoltageNumber(Number: 1434, Voltage: 1.75),
            VoltageNumber(Number: 1475, Voltage: 1.8),
            VoltageNumber(Number: 1516, Voltage: 1.85),
            VoltageNumber(Number: 1556, Voltage: 1.9),
            VoltageNumber(Number: 1597, Voltage: 1.95),
            VoltageNumber(Number: 1638, Voltage: 2.0),
            VoltageNumber(Number: 1679, Voltage: 2.05),
            VoltageNumber(Number: 1761, Voltage: 2.15),
            VoltageNumber(Number: 1802, Voltage: 2.2),
            VoltageNumber(Number: 1843, Voltage: 2.25),
            VoltageNumber(Number: 1884, Voltage: 2.3),
            VoltageNumber(Number: 1925, Voltage: 2.35),
            VoltageNumber(Number: 1966, Voltage: 2.4),
            VoltageNumber(Number: 2007, Voltage: 2.45),
            VoltageNumber(Number: 2048, Voltage: 2.5),
            VoltageNumber(Number: 2089, Voltage: 2.55),
            VoltageNumber(Number: 2130, Voltage: 2.6),
            VoltageNumber(Number: 2171, Voltage: 2.65),
            VoltageNumber(Number: 2212, Voltage: 2.7),
            VoltageNumber(Number: 2253, Voltage: 2.75),
            VoltageNumber(Number: 2294, Voltage: 2.8),
            VoltageNumber(Number: 2335, Voltage: 2.85),
            VoltageNumber(Number: 2376, Voltage: 2.9),
            VoltageNumber(Number: 2417, Voltage: 2.95),
            VoltageNumber(Number: 2458, Voltage: 3.0),
            VoltageNumber(Number: 2499, Voltage: 3.05),
            VoltageNumber(Number: 2540, Voltage: 3.1),
            VoltageNumber(Number: 2580, Voltage: 3.15),
            VoltageNumber(Number: 2621, Voltage: 3.2),
            VoltageNumber(Number: 2662, Voltage: 3.3),
            VoltageNumber(Number: 2744, Voltage: 3.35),
            VoltageNumber(Number: 147, Voltage: 3.4),
            VoltageNumber(Number: 147, Voltage: 3.45),
            VoltageNumber(Number: 147, Voltage: 3.5),
        ]
  /*---//
    func transfer(Voltage_reference : Double){
        var MostcClosedVoltage : Double = 0
        var Error = 10
        for i in 0..< VoltageNumbers.count{
            if abs(Voltage_reference - VoltageNumbers[i]){
                
            }
        }
    }
  //---*/
 
}
