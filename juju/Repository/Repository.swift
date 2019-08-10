//
//  Repository.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol Repository {
    
    associatedtype Content
    associatedtype FetchObject
    
    func save(_ entity: Content, callback: @escaping (Result<RepositoryError>) -> Void)
    
    func get(_ fetchObject: FetchObject, callback: @escaping (ContentResult<Content, RepositoryError>) -> Void)
    
    func delete(_ entity: Content, callback: @escaping (Result<RepositoryError>) -> Void)
}
