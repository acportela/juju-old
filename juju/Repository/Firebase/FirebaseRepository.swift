//
//  FirebaseRepository.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import FirebaseFirestore

//TODO Improve error handling (there's currently only 1 error type)
struct FirebaseRepository<T: FirebasePersistable, V: FirebaseQuery>: Repository {
    
    typealias Entity = T
    typealias Query = V
    
    let firestore = Firestore.firestore()
    
    func get(query: Query, callback: @escaping (ContentResult<Entity, RepositoryError>) -> Void) {
        
        let fireQuery = self.firestore
                            .collection(query.path)
                            .whereField(query.uniqueField,
                                        isEqualTo: query.uniqueValue)
                            .limit(to: 1)
        
        fireQuery.getDocuments(source: .cache) { (maybeSnapshot, maybeError) in
            
            if maybeError != nil {
                callback(.error(.generalError))
                return
            }
            
            //TODO add no data error
            guard let snapshot = maybeSnapshot,
            let data = snapshot.documents.first?.data() else {
                callback(.error(.generalError))
                return
            }
            
            guard let content = Entity(fromData: data) else {
                callback(.error(.generalError))
                return
            }
            
            callback(.success(content))
        }
    }

    func save(entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void) {
        
        self.firestore
            .collection(entity.path)
            .addDocument(data: entity.toDictionary()) { error in
            
            error == nil ? callback(.success) : callback(.error(.generalError))
        }
    }

    func delete(query: Query, callback: @escaping (Result<RepositoryError>) -> Void) {

        let returnQuery = self.firestore
                                .collection(query.path)
                                .whereField(query.uniqueField, isEqualTo: query.uniqueValue)
        
        returnQuery.getDocuments { (query, error) in
            
            if error != nil {
                callback(.error(.generalError))
                return
            }
            
            guard let results = query else {
                callback(.error(.generalError))
                return
            }
            
            results.documents.forEach { $0.reference.delete { error in
                    if error != nil {
                        callback(.error(.generalError))
                        return
                    }
                }
            }
        }
        callback(.success)
    }
}
