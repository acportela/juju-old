//
//  Repository.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol Repository {
    
    associatedtype EntityType
    associatedtype QueryType
    
    func save(entity: EntityType, callback: @escaping (ContentResult<EntityType, RepositoryError>) -> Void)
    
    func get(query: QueryType, callback: @escaping (ContentResult<[EntityType], RepositoryError>) -> Void)
    
    func delete(query: QueryType, callback: @escaping (Result<RepositoryError>) -> Void)
}
