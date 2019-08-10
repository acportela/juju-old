//
//  FirebasePersistable.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol FirebasePersistable {
    
    var pathToCollection: String { get }
    var uniqueField: String { get }
    var uniqueValue: String { get }
    
    func toDictionary() -> [String: Any]
    init?(fromData data: [String: Any])
}

extension FirebasePersistable {
    
    func toDictionary() -> [String: Any] {
        return ["": ""]
    }
    
    init?(fromData data: [String: Any]) {
        return nil
    }
}
