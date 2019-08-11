//
//  FirebaseRepository.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import FirebaseFirestore

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
            
            //TODO firebase error code handling
            if maybeError != nil {
                callback(.error(.unknown))
                return
            }
            
            guard let snapshot = maybeSnapshot,
            let data = snapshot.documents.first?.data() else {
                callback(.error(.noResults))
                return
            }
            
            guard let content = Entity(fromData: data) else {
                callback(.error(.corruptedData))
                return
            }
            
            callback(.success(content))
        }
    }

    func save(entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void) {
        
        self.firestore
            .collection(entity.path)
            .addDocument(data: entity.toDictionary()) { error in
            
            //TODO firebase error code handling
            error == nil ? callback(.success) : callback(.error(.unknown))
        }
    }

    func delete(query: Query, callback: @escaping (Result<RepositoryError>) -> Void) {

        let returnQuery = self.firestore
                                .collection(query.path)
                                .whereField(query.uniqueField, isEqualTo: query.uniqueValue)
        
        returnQuery.getDocuments { (maybeSnapshot, maybeError) in
            
            //TODO firebase error code handling
            if maybeError != nil {
                callback(.error(.unknown))
                return
            }
            
            guard let snapshot = maybeSnapshot else {
                callback(.error(.corruptedData))
                return
            }
            
            if snapshot.documents.count == 0 {
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
}
