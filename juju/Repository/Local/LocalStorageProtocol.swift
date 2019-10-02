//
//  LocalStorageProtocol.swift
//  juju
//
//  Created by Antonio Portela on 01/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol LocalStorageProtocol {
    
    func get<T>(from key: LocalStorageKeys) -> T?
    func set(value: Any?, for key: LocalStorageKeys)
    func remove(from keys: [LocalStorageKeys])
    func clear()
    
}

enum LocalStorageKeys: String {
    
    case trainingDifficulty
}
