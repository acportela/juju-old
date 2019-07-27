//
//  FirebaseRepository.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import FirebaseFirestore

struct FirebaseRepository<T: FirebasePersistable>: Repository {
    
    typealias Entity = T
    
    let firestore = Firestore.firestore()

    func get(unique: String, callback: @escaping (ContentResult<T, RepositoryError>) -> Void) {
        
    }

    func save(_ entity: Entity, callback: @escaping (Result<RepositoryError>) -> Void) {
        
        self.firestore.collection(entity.pathToCollection).addDocument(data: entity.toDictionary()) { error in
            
            error == nil ? callback(.success) : callback(.error(.generalError))
        }
    }

    func delete(_ entity: T, callback: @escaping (Result<RepositoryError>) -> Void) {

        let query = self.firestore.collection(entity.pathToCollection).whereField(entity.uniqueField,
                                                                                  isEqualTo: entity.uniqueValue)
        query.getDocuments { (query, error) in
            
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
