//
//  WaitingLiftViewController.swift
//  GRACE
//
//  Created by Sebastian Choo on 14/6/21.
//

import UIKit

class WaitingLiftViewController: UIViewController, MSDOSDelegate {
    
    var lobby: Lobby! = Lobby(block: "123A", lobby: "A", currentFloor: 2, lowerboundFloor: 1, upperboundFloor: 5)
    var userFloor: String! = "3"
    var targetFloor: Double! = 3
    
    var msdos: MSDOS! = MSDOS()
        
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var antennaIcon: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var headerView: UIStackView!
    
    var isOnTheWay = false {
        didSet {
            if isOnTheWay {
                titleLabel.accessibilityLabel =  "You're on the way to Level \(userFloor ?? ""). You're all set!"
            } else {
                titleLabel.accessibilityLabel =  "You chose Level \(userFloor ?? "") at block \(lobby.block). Enter the lift and your device will connect to it."
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        levelLabel.text = "Level \(userFloor!)"
        locationLabel.text = "Blk \(lobby.block) Lobby \(lobby.lobby)"
        cancelButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        
        msdos.delegate = self
        
        cancelButton.backgroundColor = .red.withAlphaComponent(0.1)
        
        phoneIcon.accessibilityLabel = ""
        antennaIcon.accessibilityLabel = ""
        
        levelLabel.accessibilityLabel = ""
        locationLabel.accessibilityLabel = ""
        descriptionLabel.accessibilityLabel = ""
        
        isOnTheWay = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScanning()
    }
    
    func startScanning() {
        msdos.startScanning(for: .lift)
        
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
        if isOnTheWay {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! ViewController
            vc.msdos = msdos
            vc.modalPresentationStyle = .fullScreen
            
            present(vc, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Cancel Lift Request?",
                                          message: "Are you sure you want to cancel?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes",
                                          style: .destructive) { [self] _ in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as! ViewController
                vc.msdos = msdos
                vc.modalPresentationStyle = .fullScreen
                
                present(vc, animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "No",
                                          style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    func didFindLift(microbit: Microbit) {
        guard let targetFloor = targetFloor else { return }
        microbit.write("go to \(targetFloor)")
    }
    
    func didFinishLift() {
        // KILL ME
        cancelButton.setTitle("Done", for: .normal)
        isOnTheWay = true
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [self] in
            
            phoneIcon.alpha = 0
            phoneIcon.isHidden = true
            
            antennaIcon.image = UIImage(systemName: "checkmark.circle")
            
            cancelButton.setTitleColor(.darkPurple, for: .normal)
            cancelButton.backgroundColor = .darkPurple.withAlphaComponent(0.1)
            
        } completion: { [self] _ in
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            titleLabel.text = "You're on your way to"
            descriptionLabel.text = "You're all set!"
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

}
