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
    var lobby: Lobby?
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
    }
    @IBAction func commenceRefindingPressed(_ sender: Any) {
    }
    @IBAction func keypadButtonPressed(_ sender: UIButton){
        print(sender.tag)
        targetFloor += String(sender.tag)
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
