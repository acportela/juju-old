//
//  RepositoryProtocol.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    
    associatedtype Entity
    
    func save(entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void)
    
    func update(entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void)
    
    func deleteWhere(term: String, callback: @escaping (Result<RepositoryError>) -> Void)
    
    func fetchWith(term: String, callback: @escaping (ContentResult<Entity, RepositoryError>) -> Void)
}
