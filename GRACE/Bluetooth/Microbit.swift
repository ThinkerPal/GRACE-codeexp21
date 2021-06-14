//
//  Microbit.swift
//  
//
//  Created by JiaChen(: on 27/4/21.
//

import Foundation
import CoreBluetooth

/// A Micro:bit object to interface with the BBC Micro:bit
public class Microbit {
    
    public var writeCharacteristic: CBCharacteristic?
    
    public var peripheral: CBPeripheral!
    
    init(with peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    /// Writing data directly to the micro:bit
    /// - Parameter values: String values to send to micro:bit
    public func write(_ value: String) {
        guard let writeCharacteristic = writeCharacteristic else { return }
        
        let data = Data("\(value)\n".utf8)
        peripheral.writeValue(data, for: writeCharacteristic, type: .withResponse)
    }
}
