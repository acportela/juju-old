//
//  FirebaseRepository.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import FirebaseFirestore

struct FirebaseRepository<T: FirebasePersistable, V: FirebaseQuery>: Repository {
    
    func save(entity: T, callback: @escaping (Result<RepositoryError>) -> Void) {
        
        let firestore = Firestore.firestore()
        firestore.collection(entity.path)
        .addDocument(data: entity.toDictionary()) { error in
            
            //TODO firebase error code handling
            error == nil ? callback(.success) : callback(.error(.unknown))
        }
    }
    
    func delete(query: V, callback: @escaping (Result<RepositoryError>) -> Void) {
        
        query.firebaseQuery.getDocuments { (maybeSnapshot, maybeError) in
            
            //TODO firebase error code handling
            if maybeError != nil {
                callback(.error(.unknown))
                return
            }
            
            guard let snapshot = maybeSnapshot,
            snapshot.documents.isEmpty == false else {
                callback(.error(.noResults))
                return
            }
            
            snapshot.documents.forEach { $0.reference.delete { error in
                    if error != nil {
                        callback(.error(.unknown))
                        return
                    }
                }
            }
            
        }
        
        callback(.success)
    }
    
    func get(query: V, callback: @escaping (ContentResult<[T], RepositoryError>) -> Void) {
        
        query.firebaseQuery.getDocuments { (maybeSnapshot, maybeError) in
        
            //TODO firebase error code handling
            if maybeError != nil {
                callback(.error(.unknown))
                return
            }
            
            guard let snapshot = maybeSnapshot,
            snapshot.documents.isEmpty == false else {
                callback(.error(.noResults))
                return
            }
                
            let entities = snapshot.documents.compactMap { EntityType(fromData: $0.data()) }
            guard entities.isEmpty == false else { return callback(.error(.corruptedData)) }
            
            callback(.success(entities))
        }
    }
    
}
