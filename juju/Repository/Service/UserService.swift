//
//  UserService.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    
    func userWantsToSignIn(email: String,
                           password: String,
                           callback: @escaping (ContentResult<ClientUser, UserAuthenticationError>) -> Void)
    
    func userWantsToSignUp(clientUser: ClientUser,
                           password: String,
                           callback: @escaping (Result<UserAuthenticationError>) -> Void)
    
    func userWantsToSignOut(callback: @escaping (Result<UserAuthenticationError>) -> Void)
}

struct UserService: UserServiceProtocol {
    
    let userAuth: UserAuthenticationProtocol
    let userRepo: FirebaseRepository<FirebaseUser, FirebaseUserQuery>
    
    init(userAuth: UserAuthenticationProtocol, userRepo: FirebaseRepository<FirebaseUser, FirebaseUserQuery>) {
        self.userAuth = userAuth
        self.userRepo = userRepo
    }
    
    func userWantsToSignIn(email: String,
                           password: String,
                           callback: @escaping (ContentResult<ClientUser, UserAuthenticationError>) -> Void) {
        
        self.userAuth.authenticate(email: email, password: password) { result in
            
            switch result {
                
            case .success:
                
                let fetchObject = FirebaseUserQuery(email: email)
                
                self.userRepo.get(query: fetchObject) { result in
                    
                    switch result {
                        
                    case .success(let results):
                        guard let fireUser = results.first else {
                            callback(.error(.unknown))
                            return
                        }
                        let user = ClientUser(email: fireUser.email, name: fireUser.name, dob: fireUser.dateOfBirth)
                        callback(.success(user))
                    case .error:
                        
                        callback(.error(.unknown))
                    }
                }
                
            case .error:
                
                callback(.error(.unknown))
            }
        }
    }
    
    func userWantsToSignUp(clientUser: ClientUser,
                           password: String,
                           callback: @escaping (Result<UserAuthenticationError>) -> Void) {
        
        self.userAuth.create(email: clientUser.email, password: password) { result in

            switch result {

            case .success:

                let firebaseUser = FirebaseUser(name: clientUser.name,
                                                         email: clientUser.email,
                                                         dateOfBirth: clientUser.dob)

                self.userRepo.save(entity: firebaseUser) { result in

                    switch result {

                    case .success:
                        callback(.success)
                    case .error:
                        callback(.error(.unknown))
                        let query = FirebaseUserQuery(email: clientUser.email)
                        self.userRepo.delete(query: query, callback: {_ in })
                    }
                }
            case .error:

                callback(.error(.unknown))
            }
        }
    }
    
    func userWantsToSignOut(callback: @escaping (Result<UserAuthenticationError>) -> Void) {
        
        self.userAuth.signOut { result in
            
            switch result {
                
            case .success:
                
                callback(.success)
                
            case .error(let error):
                
                callback(.error(error))
            }
        }
    }
}
