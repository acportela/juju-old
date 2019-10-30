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

    let firestoreErrorAtapter = FirestoreErrorAdapter()
    
    func save(entity: T,
              callback: @escaping (ContentResult<T, RepositoryError>) -> Void) {
        
        let firestore = Firestore.firestore()
        
        var document = firestore.collection(entity.path).document()
        
        if let presetId = entity.unique {
            
            document = firestore.collection(entity.path).document(presetId)
        }
        
        document.setData(entity.toDictionary()) { error in

            if let existingError = self.handleError(error) {

                callback(.error(existingError))
                return
            }

            callback(.success(entity))
        }
    }
    
    func delete(query: V,
                callback: @escaping (Result<RepositoryError>) -> Void) {
        
        query.firebaseQuery.getDocuments { (maybeSnapshot, maybeError) in
            
            if let existingError = self.handleError(maybeError) {

                callback(.error(existingError))
                return
            }
            
            guard let snapshot = maybeSnapshot,
            snapshot.documents.isEmpty == false else {

                callback(.error(.noResults))
                return
            }

            snapshot.documents.forEach { $0.reference.delete { error in

                    if error != nil {

                        callback(.error(.corruptedData))
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
            
            if let existingError = self.handleError(maybeError) {

                callback(.error(existingError))
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
                           
            if let existingError = self.handleError(maybeError) {

                callback(.error(existingError))
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

extension FirebaseRepository {

    private func handleError(_ error: Error?) -> RepositoryError? {

        guard let existingError = error else { return nil }

        let repoError = self.getResultingErrorFrom(existingError)

        if LogoutManager.shared.shouldLogout(error: repoError) {

            LogoutManager.shared.logout()
        }

        return repoError
    }

    private func getResultingErrorFrom(_ error: Error) -> RepositoryError {

        guard let fireError = FirestoreErrorCode(rawValue: (error as NSError).code) else {
            return .unknown
        }
        return self.firestoreErrorAtapter.getErrorFromCode(fireError)
    }
}
