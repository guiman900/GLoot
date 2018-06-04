//
//  GLootPlayer.swift
//  GLootNetworkLibrary
//
//  Created by Guillaume Manzano on 04/06/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 Player model
 */
struct GLootPlayer {
    // - MARK: properties
    
    /// player Id.
    var id: String
    
    /// player name.
    var name: String
}

extension GLootPlayer {
    // - MARK: Methods

    /**
     Constructor
     
     - Parameter json: json to unserialize and used to set the GLootPlayer model.
    */
    init(json: [String: Any]?) throws {
        guard let json = json else {
            throw SerializationError.missing("json")
        }

        guard let id = json["id"] as? String else {
            throw SerializationError.missing("id")
        }
        
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        self.id = id
        self.name = name
    }
}
