//
//  Storage.swift
//  juju
//
//  Created by Antonio Portela on 01/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

class UserDefaultsStorage: LocalStorageProtocol {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func get<T>(from key: LocalStorageKeys) -> T? {
        return userDefaults.object(forKey: key.rawValue) as? T
    }
    
    func set(value: Any?, for key: LocalStorageKeys) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func remove(from keys: [LocalStorageKeys]) {
        keys.forEach { userDefaults.removeObject(forKey: $0.rawValue) }
    }
    
    func clear() {
        
        guard let domain = Bundle.main.bundleIdentifier else {
            fatalError("Was not possible get bundleIdentifier from Bundle")
        }
        
        userDefaults.removePersistentDomain(forName: domain)
    }
    
}
