//
//  ViewController.swift
//  GRACE
//
//  Created by Rui Yang Tan on 14/6/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infomationLabel: UILabel!
    
    @IBOutlet weak var searchingIndicator: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startSearching()
    }
    
    func startSearching() {
        
        searchingIndicator.transform = .init(scaleX: 0.001, y: 0.001)
        searchingIndicator.alpha = 0.8
        
        UIView.animate(withDuration: 2, delay: 0, options: [ .curveEaseInOut, .repeat]) { [self] in
            searchingIndicator.transform = .init(scaleX: 1, y: 1)
            
            searchingIndicator.alpha = 0
        }
    }
}

