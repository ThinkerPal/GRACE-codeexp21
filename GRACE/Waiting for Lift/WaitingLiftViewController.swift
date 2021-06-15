//
//  WaitingLiftViewController.swift
//  GRACE
//
//  Created by Sebastian Choo on 14/6/21.
//

import UIKit

class WaitingLiftViewController: UIViewController {
    
    var lobby: Lobby!
    var userFloor: String!
    var targetFloor: Double!
    
    var msdos: MSDOS!
    
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
        #warning("call function while looking for lift transponder")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScanning()
    }
    
    func startScanning() {
        msdos.startScanning(for: .lobby)
        
        phoneAnimation()
    }
    
    func phoneAnimation() {
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       options: [.curveEaseInOut, .repeat, .autoreverse],
                       animations: {
                        self.phoneIcon.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).translatedBy(x: 0, y: -65)
            })
    }
    
    @IBAction func cancelAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel Lift Request?",
                                      message: "Are you sure you want to cancel?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .destructive) { [self] _ in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! ViewController
            vc.msdos = msdos
            
            self.present(vc, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "No",
                                      style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
