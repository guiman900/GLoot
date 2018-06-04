//
//  GLootNetworkProtocol.swift
//  GLootNetworkLibrary
//
//  Created by Guillaume Manzano on 04/06/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 GLootNetworkProtocol is used to retrieve the network results.
 */
public protocol GLootNetworkProtocol {
    // - MARK: Methods
    
    /**
    getPlayers response
     
     - Parameter players: player list.
    */
    func playersReceived(players: [GLootPlayer])
    
    /**
     getPlayer response
     
     - Parameter player: the player.
     */
    func playerReceived(player: GLootPlayer)
    
    /**
     createPlayer response
     
     - Parameter player: the player created.
     */
    func playerCreated(player: GLootPlayer)
    
    /**
     editPlayer response
     
     - Parameter player: the player edited.
     */
    func playerEdited(player: GLootPlayer)
    
    /**
     deletePlayer response
     
     - Parameter player: the player deleted.
     */
    func playerDeleted(player: GLootPlayer)
    
    /**
     Method triggered if an error happend during one of the network operation
     
     - Parameter error: error description.
     */
    func networkError(error: String)
}
