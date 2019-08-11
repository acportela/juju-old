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
    associatedtype Query
    
    func save(entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void)
    
    func get(query: Query, callback: @escaping (ContentResult<Entity, RepositoryError>) -> Void)
    
    func delete(query: Query, callback: @escaping (Result<RepositoryError>) -> Void)
}
