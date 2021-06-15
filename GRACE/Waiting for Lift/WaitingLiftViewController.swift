//
//  WaitingLiftViewController.swift
//  GRACE
//
//  Created by Sebastian Choo on 14/6/21.
//

import UIKit

class WaitingLiftViewController: UIViewController {
    
    var destinationFloor: Int = 8
    #warning("Destination Floor needs to be passed from Level Picker")
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var animationCircle: UIView!
    @IBOutlet weak var phoneIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        levelLabel.text = "Level \(destinationFloor)"
        
//        animationCircle.layer.cornerRadius = 70
//        animationCircle.layer.borderWidth = 5
        // Do any additional setup after loading the view.
        phoneAnimation()
        #warning("call function while looking for lift transponder")
    }
    
    func phoneAnimation() {
        UIView.animate(withDuration: 1.5, delay: 1, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.phoneIcon.transform = self.phoneIcon.transform.scaledBy(x: 0.8, y: 0.8).translatedBy(x: 0, y: -40)
        })}

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
