//
//  Repository.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol Repository {
    
    associatedtype Entity
    
    func save(_ entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void)
    
    func get(unique: String, callback: @escaping (ContentResult<Entity, RepositoryError>) -> Void)
    
    func delete(_ entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void)
}
