//
//  MSDOS.swift
//  GRACE
//
//  Created by JiaChen(: on 14/6/21.
//

import CoreBluetooth
import Foundation

public class MSDOS: NSObject {
    
    public enum ScanType {
        
        /// Lobby
        ///
        /// `#block,currentFloor,lowerboundFloor,upperboundFloor`
        case lobby
        
        /// Lift
        ///
        /// `!Hi im a lift`
        case lift
    }
    
    var microbit: Microbit?
    var centralManager: CBCentralManager!
    
    let readUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    let writeUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    
    var microbits: [Microbit] = []
    
    var lobbyDevice: Microbit?
    
    var scanType: ScanType!
    
    var delegate: MSDOSDelegate?
    
    public override init() {
        super.init()
        
    }
    
    func startScanning(for scanType: ScanType = .lobby) {
        self.scanType = scanType
        centralManager = CBCentralManager(delegate: self, queue: .main)
        
        microbit = nil
        microbits = []
    }
    
    enum LiftDirection: String {
        case up = "#A!1"
        case down = "#A!0"
    }
    
    func callLift(going direction: LiftDirection) {
        
        guard let microbit = microbit else {
            print("🛑 MS-DOS: Not connected to any micro:bits")
            return
        }
        
        if scanType == .lobby {
            print(direction.rawValue)
            microbit.write(direction.rawValue)
            
            // Disconnect from Lobby after we are done
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] _ in
                centralManager.cancelPeripheralConnection(microbit.peripheral)
            }
        } else {
            print("🛑 MS-DOS: Unable to perform `ScanType.lobby` functions on a `ScanType.lift`")
        }
    }
}
