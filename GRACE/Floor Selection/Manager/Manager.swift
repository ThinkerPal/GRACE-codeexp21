//
//  Manager.swift
//  GRACE
//
//  Created by JiaChen(: on 16/6/21.
//

import Foundation
import SafariServices

struct Manager {
    
    static let url = "iseven.xyz"
    
    var delegate: ManagerDelegate
    
    func handleException(completion: (() -> Void)? = nil) {
        // Creating a GRACE request URL
        let urlString = "http://g.\(generateURL())/"
        
        // Converting GRACE URL to URL type
        let graceURL = URL(string: urlString)!
        
        // Presenting GRACE result to user
        let vc = SFSafariViewController(url: graceURL)
        
        // Pushing to delegate
        delegate.present(vc,
                         animated: true,
                         completion: completion)
    }
    
    func generateURL() -> String {
        // Converting URL
        var url = Manager.url.dropFirst(2)
        
        // Updating URL to later version
        url = "isst" + url
        
        return String(url)
    }
}

protocol ManagerDelegate: UIViewController {}
