//
//  FloorSelectionViewController.swift
//  GRACE
//
//  Created by Rui Yang Tan on 14/6/21.
//

import UIKit

class FloorSelectionViewController: UIViewController, MSDOSDelegate {
    // Setting up outlets
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var lobbyLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet var keypadButtons: [UIButton]!
    
    @IBOutlet weak var headerView: UIStackView!
    // Objects that are passed from intialising this VC
    var lobby: Lobby!
    var msdos: MSDOS!
    
    var targetFloor: String = "" {
        didSet {
            keypadButtons[12].isEnabled = !targetFloor.isEmpty
            keypadButtons[13].isEnabled = !targetFloor.isEmpty
            keypadButtons[10].isEnabled = targetFloor.isEmpty
            
            floorLabel.text = targetFloor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floorLabel.layer.cornerRadius = 20
        floorLabel.layer.masksToBounds = true
        
        for (n, keypadButton) in keypadButtons.enumerated() {
            keypadButton.tag = n
            
            switch n {
            case 0..<10:
                // Normal Keys
                keypadButton.accessibilityLabel = "\(n)"
                
            case 10:
                // Basement
                keypadButton.accessibilityLabel = "Basement"
            case 11:
                // More Button Button pressed
                //   this is a stupid name
                keypadButton.accessibilityLabel = "More Options"
                
            case 12:
                // Checkmark/Confirm Selection
                keypadButton.accessibilityLabel = "Confirm Selection"
            case 13:
                // Delete selected
                keypadButton.accessibilityLabel = "Delete"
                
            default: break
            }
        }
        
        floorLabel.text = targetFloor
        
        blockLabel.text = "Block \(lobby.block)"
        lobbyLabel.text = "Lobby \(lobby.lobby) • \(Int(lobby.lowerboundFloor)) to \(Int(lobby.upperboundFloor))"
        
        welcomeTitleLabel.accessibilityLabel = "Welcome to block \(lobby.block), Lobby \(lobby.lobby). Pick a floor from \(Int(lobby.lowerboundFloor)) to \(Int(lobby.upperboundFloor))"
        blockLabel.accessibilityLabel = ""
        lobbyLabel.accessibilityLabel = ""

        msdos.delegate = self
    }
    
    @IBAction func commenceRefindingPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Need to find another GRACE! ",
                                      message: "Whooooooo your device is so good it can detect multiple things",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { [self] _ in
            dismiss(animated: true)
        })
        
        self.present(alert, animated: true)
        #warning("need to implement bringing up the Multilobby storyboard")
    }
    
    @IBAction func keypadButtonPressed(_ sender: UIButton){
        switch sender.tag {
        case 0..<10:
            // Normal Keys
            targetFloor += String(sender.tag)
            
        case 10:
            // Basement
            targetFloor += "B"
            
        case 11:
            // More Button Button pressed
            //   this is a stupid name
            onMoreButtons()
            
        case 12:
            // Checkmark/Confirm Selection
            onConfirmation()
            
        case 13:
            // Delete selected
            onDelete()
            
        default: break
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func didDisconnect() {
        dismiss(animated: true)
    }
}
