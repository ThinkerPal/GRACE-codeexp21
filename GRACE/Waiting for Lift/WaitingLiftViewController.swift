//
//  WaitingLiftViewController.swift
//  GRACE
//
//  Created by Sebastian Choo on 14/6/21.
//

import UIKit

class WaitingLiftViewController: UIViewController {
    
    var lobby: Lobby! = Lobby(block: "123", lobby: "A", currentFloor: 2.0, lowerboundFloor: 1.0, upperboundFloor: 12.0)
    var userFloor: String! = "8"
    var targetFloor: Double!
    
    #warning("Target Floor needs to be passed from Level Picker")
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var phoneIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        levelLabel.text = "Level \(userFloor!)"
        locationLabel.text = "Blk \(lobby.block) Lobby \(lobby.lobby)"
        cancelBtn.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        phoneAnimation()
        #warning("call function while looking for lift transponder")
    }
    
    func phoneAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.phoneIcon.transform = self.phoneIcon.transform.scaledBy(x: 0.8, y: 0.8).translatedBy(x: 0, y: -65)
            })
    }
    
    @IBAction func cancelAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Level Again", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    /*
    Old Animations
        UIView.animate(withDuration: 2.0, delay: 0.5, options: .curveEaseInOut, animations: {
             self.phoneIcon.transform = self.phoneIcon.transform.translatedBy(x: -50, y: 30)
         }) { (_) in
             UIView.animate(withDuration: 3.0, animations: {
                 self.phoneIcon.transform = self.phoneIcon.transform.translatedBy(x: 100, y: -30)
             }) { (_) in
                 UIView.animate(withDuration: 2.0, animations: {
                     self.phoneIcon.transform = self.phoneIcon.transform.translatedBy(x: -50, y: 20)
                 }) { (_) in
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
