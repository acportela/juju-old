//
//  FirebaseRepository.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import FirebaseFirestore

struct FirebaseRepository<T: FirebasePersistable>: RepositoryProtocol {
    
    typealias Entity = T
    
    let firestore = Firestore.firestore()

    func save(entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void) {
        firestore.collection(entity.pathToCollection).addDocument(data: entity.toDictionary()) { error in
            error == nil ? callback(.success) : callback(.error(.generalError))
        }
    }
    
    func update(entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void) {
        
    }
    
    func deleteWhere(term: String, callback: @escaping (Result<RepositoryError>) -> Void) {
        
    }
    
    func fetchWith(term: String, callback: @escaping (ContentResult<T, RepositoryError>) -> Void) {
        
    }
}
