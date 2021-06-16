//
//  FloorSelectionButtons.swift
//  GRACE
//
//  Created by JiaChen(: on 15/6/21.
//

import Foundation
import UIKit

extension FloorSelectionViewController {
    func onMoreButtons() {
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let groundAction = UIAlertAction(title: "Ground Floor", style: .default) { [self] _ in
            targetFloor += "G"
        }
        
        groundAction.setValue(UIImage(systemName: "g.circle", withConfiguration: config)!, forKey: "image")
        
        let mezzanineAction = UIAlertAction(title: "Mezzanine Floor", style: .default) { [self] _ in
            targetFloor += "M"
        }
        
        mezzanineAction.setValue(UIImage(systemName: "m.circle", withConfiguration: config)!, forKey: "image")
        
        alert.addAction(groundAction)
        alert.addAction(mezzanineAction)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func onDelete() {
        targetFloor = String(targetFloor.dropLast())
    }
    
    func onConfirmation() {
        let userFloor = targetFloor
        
        if targetFloor.contains("B"){
            targetFloor = targetFloor.replacingOccurrences(of: "B", with: "")
            targetFloor = "-" + targetFloor
            
        } else if targetFloor.contains("M") {
            targetFloor = targetFloor.replacingOccurrences(of: "M", with: "")
            targetFloor += ".5"
            
        } else if targetFloor == "G" {
            targetFloor = "0"
            floorLabel.text = userFloor
            
        }
        
        let floor = Double(targetFloor)!
        
        if lobby.lowerboundFloor...lobby.upperboundFloor ~= floor {
            
            msdos.callLift(going: lobby.currentFloor > floor ? .down : .up)
            
            let storyboard = UIStoryboard(name: "WaitingLift", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! WaitingLiftViewController
            
            vc.msdos = msdos
            vc.lobby = lobby
            vc.userFloor = userFloor
            vc.targetFloor = floor
            
            vc.modalPresentationStyle = .fullScreen
            
            present(vc, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Invalid Floor!",
                                          message: "You entered \(targetFloor). Ensure the floor is within \(Int(lobby.lowerboundFloor)) and \(Int(lobby.upperboundFloor)).",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { [self] _ in
                targetFloor = ""
                floorLabel.text = self.targetFloor
            })
            
            present(alert, animated: true)
        }
    }
}
