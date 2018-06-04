//
//  GLootNetworkLibraryTests.swift
//  GLootNetworkLibraryTests
//
//  Created by Guillaume Manzano on 04/06/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import XCTest
@testable import GLootNetworkLibrary

class GLootNetworkLibraryTests: XCTestCase, GLootNetworkProtocol {
    
    var expression: XCTestExpectation?
    var player: GLootPlayer?
    let network = GLootNetwork()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        expression = expectation(description: "network test finished")

        network.delegate = self
        
        network.createPlayer(playerName: "Mark Johnson")
        
        waitForExpectations(timeout: 50, handler: nil)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func playersReceived(players: [GLootPlayer])
    {
        print("[Players Received] : \(players)");
        print("")
        
        network.editPlayer(playerId: self.player!.id, playerName: "Name modifed")
    }
    
    func playerReceived(player: GLootPlayer)
    {
        print("[Player Received] : \(player)");
        print("")
        self.player = player
        
        network.deletePlayer(playerId: player.id)
    }
    
    func playerCreated(player: GLootPlayer)
    {
        print("[Player Created] : \(player)");
        print("")
        self.player = player
        
        network.getPlayers()
    }
    
    func playerEdited(player: GLootPlayer)
    {
        print("[Player Edited] : \(player)");
        print("")
        
        network.getPlayer(playerId: player.id)
    }
    
    func playerDeleted(player: GLootPlayer)
    {
        print("[Player Deleted] : \(player)");
        print("")

        expression?.fulfill()
    }
    
    func networkError(error: String)
    {
        print(error)
        expression?.fulfill()
    }

}
