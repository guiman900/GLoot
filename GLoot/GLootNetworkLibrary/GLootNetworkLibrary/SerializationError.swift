//
//  SerializationError.swift
//  GLootNetworkLibrary
//
//  Created by Guillaume Manzano on 04/06/2018.
//  Copyright © 2018 Guillaume Manzano. All rights reserved.
//

import Foundation

/**
 enum used for the serialization errors.
 */
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
