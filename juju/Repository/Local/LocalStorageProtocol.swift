//
//  LocalStorageProtocol.swift
//  juju
//
//  Created by Antonio Portela on 01/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum StorageKeys: String, CaseIterable {
    
    case loggedUser
    case trainingDifficulty
    case todaySlowEasySeries
    case todaySlowMediumSeries
    case todaySlowHardSeries
    case todayFastEasySeries
    case todayFastMediumSeries
    case todayFastHardSeries
}

protocol LocalStorageProtocol {

    func get<T: Codable>(from key: StorageKeys) -> T?
    func set<T: Codable>(_ value: T, for key: StorageKeys)
    func remove(valuesForKeys keys: [StorageKeys])
}
