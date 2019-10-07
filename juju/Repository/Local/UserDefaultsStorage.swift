//
//  Storage.swift
//  juju
//
//  Created by Antonio Portela on 01/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct UserDefaultsStorage: LocalStorageProtocol {
    
    let storage = UserDefaults.standard
    
    func get<T: Codable>(from key: StorageKeys) -> T? {
        
        guard let object = storage.object(forKey: key.rawValue),
            let data = object as? Data else {
                return nil
        }
        
        do {
            
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            return unarchiver.decodeDecodable(T.self, forKey: key.rawValue)
            
        } catch {
            
            return nil
        }
    }
    
    func set<T: Codable>(_ value: T, for key: StorageKeys) {
        
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        try? archiver.encodeEncodable(value, forKey: key.rawValue)
        storage.set(archiver.encodedData, forKey: key.rawValue)
        
    }
    
    func remove(valuesForKeys keys: [StorageKeys]) {
        
        keys.forEach { self.storage.removeObject(forKey: $0.rawValue) }
    }
}
