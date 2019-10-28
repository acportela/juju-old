//
//  FirebaseRepository.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import FirebaseFirestore

protocol FirebaseListenable: Repository {
    
    func listenTo(query: QueryType,
                  callback: @escaping (ContentResult<[EntityType], RepositoryError>) -> Void) -> ListenerRegistration
}

struct FirebaseRepository<T: FirebasePersistable, V: FirebaseQuery>: FirebaseListenable {
    
    func save(entity: T,
              callback: @escaping (ContentResult<T, RepositoryError>) -> Void) {
        
        let firestore = Firestore.firestore()
        
        var document = firestore.collection(entity.path).document()
        
        if let presetId = entity.unique {
            
            document = firestore.collection(entity.path).document(presetId)
        }
        
        document.setData(entity.toDictionary()) { error in
            
            error == nil ? callback(.success(entity)) : callback(.error(.unknown))
        }
    }
    
    func delete(query: V,
                callback: @escaping (Result<RepositoryError>) -> Void) {
        
        query.firebaseQuery.getDocuments { (maybeSnapshot, maybeError) in
            
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
    
    func get(query: V,
             callback: @escaping (ContentResult<[T], RepositoryError>) -> Void) {
        
        query.firebaseQuery.getDocuments { (maybeSnapshot, maybeError) in

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
    
    func listenTo(query: V,
                  callback: @escaping (ContentResult<[T], RepositoryError>) -> Void) -> ListenerRegistration {
        
        return query.firebaseQuery.addSnapshotListener { maybeSnapshot, maybeError in
                           
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
    
    func update(entity: T,
                id: String,
                callback: @escaping (Result<RepositoryError>) -> Void) {
        
        let firestore = Firestore.firestore()
        firestore.collection(entity.path).document(id).setData(entity.toDictionary())
    }
}
