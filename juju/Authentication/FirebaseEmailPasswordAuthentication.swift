//
//  FirebaseEmailPasswordAuthentication.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserAuthenticationProtocol {
    
    func authenticate(email: String, password: String, callback: @escaping (ContentResult<User, UserAuthenticationError>) -> Void)
    func create(email: String, password: String, callback: @escaping (ContentResult<User, UserAuthenticationError>) -> Void)
    func signOut(callback: @escaping (Result<UserAuthenticationError>) -> Void)
}

struct FirebaseEmailPasswordAuthentication: UserAuthenticationProtocol {
    
    func authenticate(email: String, password: String, callback: @escaping (ContentResult<User, UserAuthenticationError>) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error,
            let authCode = AuthErrorCode(rawValue: (error as NSError).code) {
                
                let userError = FirebaseAuthErrorAdapter.getErrorFrom(code: authCode)
                callback(.error(userError))
                return
            }
            
            guard let validUser = user?.user, validUser.email != nil else {
                
                callback(.error(.customError(StringErrorConstants.unknownErrorMessage)))
                return
            }

            callback(.success(validUser))
        }
    }
    
    func create(email: String, password: String, callback: @escaping (ContentResult<User, UserAuthenticationError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { ( user, error) in
            
            if let error = error,
            let authCode = AuthErrorCode(rawValue: (error as NSError).code) {
                
                let userError = FirebaseAuthErrorAdapter.getErrorFrom(code: authCode)
                callback(.error(userError))
                return
            }
            
            guard let validUser = user?.user, validUser.email != nil else {
                
                callback(.error(.customError(StringErrorConstants.unknownErrorMessage)))
                return
            }
            
            callback(.success(validUser))
        }
        
    }
    
    func signOut(callback: @escaping (Result<UserAuthenticationError>) -> Void) {
        
        do {
            
            try Auth.auth().signOut()
            callback(.success)
            
        } catch {
            
            callback(.error(.couldntLogout))
        }
    }
}
