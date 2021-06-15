//
//  MSDOS.swift
//  GRACE
//
//  Created by JiaChen(: on 14/6/21.
//

import Foundation
import CoreBluetooth

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
        if scanType == .lobby {
            print(direction.rawValue)
            microbit?.write(direction.rawValue)
        } else {
            print("🛑 MS-DOS: Unable to perform `ScanType.lobby` functions on a `ScanType.lift`")
        }
    }
}

extension MSDOS: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        guard let name = peripheral.name else { return }
        print(name)
        let regex = try! NSRegularExpression(pattern: "BBC micro:bit \\[[z|v|g|p|t][u|o|i|e|a][z|v|g|p|t][u|o|i|e|a][z|v|g|p|t]\\]",
                                             options: [])
        
        guard regex.matches(in: name, options: [], range: NSRange(location: 0, length: name.count)).count == 1 else {
            return
        }
        
        if !microbits.contains(where: { $0.peripheral.identifier == peripheral.identifier }) {
            let microbit = Microbit(with: peripheral)
            
            microbits.append(microbit)
            
            centralManager.connect(microbit.peripheral, options: nil)
        }
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [],
                                              options: nil)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("\(peripheral.name ?? "Unanamed") \(RSSI)")
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("🎉 MS-DOS: Connected to", peripheral.name ?? "unnamed")
        peripheral.readRSSI()
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")])
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("👋 MS-DOS: Disconnected from", peripheral.name ?? "unnamed")
        
        delegate?.didDisconnect()
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("🛑 MS-DOS: A Bluetooth error occurred - ", error.localizedDescription)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first else { return }
        
        peripheral.discoverCharacteristics([readUUID, writeUUID], for: service)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        let microbitIndex = microbits.firstIndex(where: {
            $0.peripheral == peripheral
        })!
        let microbit = microbits[microbitIndex]
        
        for characteristic in characteristics {
            if characteristic.uuid == writeUUID {
                microbit.writeCharacteristic = characteristic
                
                if let microbitIndex = microbits.firstIndex(where: {
                    $0.peripheral.identifier == peripheral.identifier
                }) {
                    let internalMicrobit = microbits[microbitIndex]
                    internalMicrobit.write("metadata please")
                }
                
            } else if characteristic.uuid == readUUID {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Micro:bit wrote to us
        
        guard let value = characteristic.value,
              let stringValue = String(data: value,
                                       encoding: .utf8) else { return }
        
        switch scanType {
        case .lobby:
            if stringValue.first == "#" {
                // It is a lobby
                // We can continue as a lobby
                var content = stringValue
                content.removeFirst()
                
                let contents = content.split(separator: ",").map {
                    String($0)
                }
                
                delegate?.didFindLobby(Lobby(block: contents[0],
                                             lobby: contents[1],
                                             currentFloor: Double(contents[2])!,
                                             lowerboundFloor: Double(contents[3])!,
                                             upperboundFloor: Double(contents[4])!))
                
                let microbitIndex = microbits.firstIndex(where: {
                    $0.peripheral == peripheral
                })!
                
                microbit = microbits[microbitIndex]
            } else {
                centralManager.cancelPeripheralConnection(peripheral)
                
                if let index = microbits.firstIndex(where: {
                    $0.peripheral.identifier == peripheral.identifier
                }) {
                    microbits.remove(at: index)
                }
                
                if let microbit = microbits.first {
                    centralManager.connect(microbit.peripheral, options: nil)
                }
            }
            break
        case .lift:
            break
        case .none:
            break
        }
    }
}
