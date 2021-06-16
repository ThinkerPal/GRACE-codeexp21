//
//  MSDOSDelegate.swift
//  GRACE
//
//  Created by JiaChen(: on 15/6/21.
//

import Foundation

protocol MSDOSDelegate {
    func didFindLobby(_ lobby: Lobby)
    func didDisconnect()
    
    func didFindLift(microbit: Microbit)
    
    func didFinishLift()
}

extension MSDOSDelegate {
    func didFindLobby(_ lobby: Lobby) {}
    func didDisconnect() {}
    
    func didFindLift(microbit: Microbit) {}
    
    func didFinishLift() {}
}
