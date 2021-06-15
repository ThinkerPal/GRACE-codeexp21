//
//  FloorSelectionViewController.swift
//  GRACE
//
//  Created by Rui Yang Tan on 14/6/21.
//

import UIKit

class FloorSelectionViewController: UIViewController {
    // Setting up outlets
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var lobbyLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet var keypadButtons: [UIButton]!
    
    // Objects that are passed from intialising this VC
//    var lobby = Lobby?
    #warning("Testing data here")
    var lobby = Lobby(block: "124A", lobby: "B", currentFloor: 1, lowerboundFloor: -2, upperboundFloor: 18)
    var targetFloor: String = ""
    
    
    override func viewDidLoad() {
        print("Floor Selector View Controller Loaded")
        super.viewDidLoad()
        floorLabel.layer.cornerRadius = 20
        floorLabel.layer.masksToBounds = true
        for (n, keypadButton) in keypadButtons.enumerated(){
            keypadButton.tag = n
            print(n)
        }
        floorLabel.text = targetFloor
//        blockLabel.text = "Block \(lobby?.block ?? "")"
//        lobbyLabel.text = "Lobby \(lobby?.lobby ?? "")"
        #warning("using local data version")
        blockLabel.text = "Block \(lobby.block)"
        lobbyLabel.text = "Lobby \(lobby.lobby)"
    }
    @IBAction func commenceRefindingPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Need to find another GRACE! ", message: "Whooooooo your device is so good it can detect multiple things", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            print("wowo")
            self.dismiss(animated: true)
        }))
        self.present(alert, animated:true)
        #warning("need to implement bringing up the Multilobby storyboard")
        
    }
    @IBAction func keypadButtonPressed(_ sender: UIButton){
        print(sender.tag)
        if sender.tag < 10 {
            targetFloor += String(sender.tag)
            floorLabel.text = targetFloor
        }else{
            switch sender.tag{
            case 10:
                targetFloor += "B"
                floorLabel.text = targetFloor
                break
            case 11:
                let alert = UIAlertController(title: "More Floor Options", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "G", style: .default, handler: { _ in
                    self.targetFloor += "G"
                    self.floorLabel.text = self.targetFloor
                }))
                alert.addAction(UIAlertAction(title: "M", style: .default, handler: { _ in
                    self.targetFloor += "M"
                    self.floorLabel.text = self.targetFloor
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated:true)
                #warning("Do we need a more?")
                break
            case 12:
//                if lobby!.lowerboundFloor...lobby!.upperboundFloor ~= Int(targetFloor)!{
                #warning("using local data version")
                let userFloor = self.targetFloor
                if targetFloor.contains("B"){
                    targetFloor = targetFloor.replacingOccurrences(of: "B", with: "")
                    targetFloor = "-" + targetFloor
                }else if targetFloor.contains("M"){
                    targetFloor = targetFloor.replacingOccurrences(of: "M", with: "")
                    targetFloor += ".5"
                }else if targetFloor == "G" {
                    self.targetFloor = "0"
                    self.floorLabel.text = userFloor
                }
                if lobby.lowerboundFloor...lobby.upperboundFloor ~= Double(targetFloor)!{
                    // All Values are valid
                    #warning("implement segue to next VC")
                }else{
                    let alert = UIAlertController(title: "Invalid Floor Selected", message: "You selected an invalid floor!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
                        self.targetFloor = ""
                        self.floorLabel.text = self.targetFloor
                    }))
                    self.present(alert, animated: true)
                    
                }
                break
            default:
                targetFloor = String(targetFloor.dropLast())
                floorLabel.text = targetFloor
                break
                
            }
            
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
    func levelSelected() {
        let storyboard = UIStoryboard(name: "WaitingForLift", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! ViewController
//        vc.lobbies = self.lobbies
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
