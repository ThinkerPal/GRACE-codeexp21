//
//  ViewController.swift
//  GRACE
//
//  Created by Rui Yang Tan on 14/6/21.
//

import UIKit

class ViewController: UIViewController, MSDOSDelegate {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infomationLabel: UILabel!
    
    @IBOutlet weak var searchingIndicator: UIImageView!
    
    let msdos = MSDOS()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        msdos.delegate = self
        startSearching()
    }
    
    func startSearching() {
        
        msdos.startScanning(for: .lobby)
        
        searchingIndicator.transform = .init(scaleX: 0.001, y: 0.001)
        searchingIndicator.alpha = 0.8
        
        UIView.animate(withDuration: 2, delay: 0, options: [ .curveEaseInOut, .repeat]) { [self] in
            searchingIndicator.transform = .init(scaleX: 1, y: 1)
            
            searchingIndicator.alpha = 0
        }
    }
    
    func didFindLobby(_ lobby: Lobby) {
        searchingIndicator.layer.removeAllAnimations()
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [self] in
            searchingIndicator.image = UIImage(systemName: "checkmark.circle.fill")
            searchingIndicator.transform = .init(scaleX: 0.3, y: 0.3)
            searchingIndicator.alpha = 1
            searchingIndicator.tintColor = .green
            
            statusLabel.alpha = 0
            infomationLabel.alpha = 0
        } completion: { _ in
            // Launch another controller
            print(lobby)
            #warning("pass lobby over")
        }

    }
}

