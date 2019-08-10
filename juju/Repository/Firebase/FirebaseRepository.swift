//
//  FirebaseRepository.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import FirebaseFirestore

//TODO Improve error handling (there's currently only 1 error type)
struct FirebaseRepository<T: FirebasePersistable, V: FirebasePersistable>: Repository {
    
    typealias Content = T
    typealias FetchObject = V
    
    let firestore = Firestore.firestore()

    func get(_ fetchObject: FetchObject, callback: @escaping (ContentResult<Content, RepositoryError>) -> Void) {
        
        let query = self.firestore
                        .collection(fetchObject.pathToCollection)
                        .whereField(fetchObject.uniqueField,
                                    isEqualTo: fetchObject.uniqueValue)
                        .limit(to: 1)
        
        query.getDocuments(source: .cache) { (maybeSnapshot, maybeError) in
            
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
            
            guard let content = Content(fromData: data) else {
                callback(.error(.generalError))
                return
            }
            
            callback(.success(content))
        }
    }

    func save(_ entity: Content, callback: @escaping (Result<RepositoryError>) -> Void) {
        
        self.firestore
            .collection(entity.pathToCollection)
            .addDocument(data: entity.toDictionary()) { error in
            
            error == nil ? callback(.success) : callback(.error(.generalError))
        }
    }

    func delete(_ entity: Content, callback: @escaping (Result<RepositoryError>) -> Void) {

        let query = self.firestore
                        .collection(entity.pathToCollection)
                        .whereField(entity.uniqueField, isEqualTo: entity.uniqueValue)
        
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
