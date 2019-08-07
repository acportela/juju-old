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
}

struct UserService: UserServiceProtocol {
    
    let userAuth: UserAuthenticationProtocol
    let userRepo: FirebaseRepository<FirebaseFirestoreUser>
    
    init(userAuth: UserAuthenticationProtocol, userRepo: FirebaseRepository<FirebaseFirestoreUser>) {
        self.userAuth = userAuth
        self.userRepo = userRepo
    }
    
    func userWantsToSignIn(email: String,
                           password: String,
                           callback: @escaping (ContentResult<ClientUser, UserAuthenticationError>) -> Void) {
        
    }
    
    func userWantsToSignUp(clientUser: ClientUser,
                           password: String,
                           callback: @escaping (Result<UserAuthenticationError>) -> Void) {
        
        self.userAuth.create(email: clientUser.email, password: password) { result in

            switch result {

            case .success:

                let firebaseUser = FirebaseFirestoreUser(name: clientUser.name,
                                                         email: clientUser.email,
                                                         dateOfBirth: clientUser.dob)

                self.userRepo.save(firebaseUser) { result in

                    switch result {

                    case .success:
                        callback(.success)
                    case .error:
                        callback(.error(.unknown))
                       self.userRepo.delete(firebaseUser, callback: {_ in })
                    }
                }
            case .error:

                callback(.error(.unknown))
            }
        }
    }
}
