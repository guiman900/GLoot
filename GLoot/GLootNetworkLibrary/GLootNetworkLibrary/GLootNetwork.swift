//
//  GLootNetwork.swift
//  GLootNetworkLibrary
//
//  Created by Guillaume Manzano on 04/06/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation
import Alamofire

/**
 GLootNetwork is the network encapsulation for the GLoot Rest APIs.
 */
public class GLootNetwork {
    // - Mark: Properties
    
    /// delegate to retrieve the network responses.
    var delegate: GLootNetworkProtocol?
    
    // - Mark: Methods
    
    /**
     Constructor
     */
    public init() {}
    
    /**
     Get a list of players.
    */
    public func getPlayers()
    {
        guard let url = URL(string: Constants.playersBaseUrl) else {
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).validate()
            .responseJSON
            {
                response in
                
                guard let unWrappedDelegate = self.delegate else {
                    print("[getPlayers]: GLootNetworkProtocol Delegate is nil")
                    return
                }
                
                guard response.result.isSuccess else {
                    unWrappedDelegate.networkError(error: String(describing: response.error?.localizedDescription))
                    return
                }
                
                var players: [GLootPlayer] = []
                
                guard let json = response.result.value as? [[String: Any]] else
                {
                    unWrappedDelegate.networkError(error: "Unable to unserialize [getPlayers] response")
                    return
                }
                
                for case let result in json {
                    if let player = try? GLootPlayer(json: result) {
                        players.append(player)
                    }
                    else {
                        unWrappedDelegate.networkError(error: "Unable to convert [getPlayers] json response into a GLootPlayer")
                    }
                }
                
                unWrappedDelegate.playersReceived(players: players)
        }
    }
    
    /**
     Get a specific player.
     
     - Parameter playerId: id of the player to retrieve.
     */
    public func getPlayer(playerId: String)
    {
        guard let url = URL(string: "\(Constants.playerBaseUrl)/\(playerId)") else {
            print("bad url")
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).validate()
            .responseJSON
            {
                response in
                self.playerResponse(response: response, method: "[receivePlayer]")
        }
        
    }
    
    /**
     Create a player.
     
     - Parameter playerName: name of the new player.
     */
    public func createPlayer(playerName: String)
    {
        guard let url = URL(string: Constants.playerBaseUrl) else {
            return
        }
        
        
        Alamofire.request(url, method: .post, parameters: ["name": playerName], encoding: JSONEncoding.default).validate()
            .responseJSON
            {
                response in
                self.playerResponse(response: response, method: "[createPlayer]")
        }
        
    }
    
    /**
     Delete a player.
     
     - Parameter playerId: id of the player to delete.
     */
    public func deletePlayer(playerId: String)
    {     guard let url = URL(string: "\(Constants.playerBaseUrl)/\(playerId)") else {
        return
        }
        
        
        Alamofire.request(url, method: .delete, parameters: nil).validate()
            .responseJSON
            {
                response in
                self.playerResponse(response: response, method: "[deletePlayer]")
        }
    }
    
    /**
     Edit a player.
     
     - Parameter playerId: the player Id.
     - Parameter playerName: new player name.
     */
    public func editPlayer(playerId: String, playerName: String)
    {
        guard let url = URL(string: "\(Constants.playerBaseUrl)/\(playerId)") else {
            return
        }
        
        Alamofire.request(url, method: .put, parameters: ["name": playerName], encoding: JSONEncoding.default).validate()
            .responseJSON
            {
                response in
                
                self.playerResponse(response: response, method: "[editPlayer]")
        }
    }
    
    /**
     Generic method to unserialize a player and call the delegate method.
     
     - Parameter response: the server response.
     - Parameter method: the method that made the API call.
     */
    private func playerResponse(response: DataResponse<Any>, method: String) {
        guard let unWrappedDelegate = self.delegate else {
            print("\(method): GLootNetworkProtocol Delegate is nil")
            return
        }
        
        guard response.result.isSuccess else {
            unWrappedDelegate.networkError(error: String(describing: response.error?.localizedDescription))
            return
        }
        
        guard let json = response.result.value as? [String: Any] else
        {
            unWrappedDelegate.networkError(error: "Unable to unserialize \(method) response")
            return
        }
        
        if let player = try? GLootPlayer(json: json) {
            switch method {
            case "[receivePlayer]":
                unWrappedDelegate.playerReceived(player: player)
            case "[createPlayer]":
                unWrappedDelegate.playerCreated(player: player)
            case "[editPlayer]":
                unWrappedDelegate.playerEdited(player: player)
            case "[deletePlayer]":
                unWrappedDelegate.playerDeleted(player: player)
            default:
                unWrappedDelegate.networkError(error: "\(method): Unexpected Error")
            }
        }
        else {
            unWrappedDelegate.networkError(error: "Unable to convert \(method) json response into a GLootPlayer")
        }
        
    }
    
}
