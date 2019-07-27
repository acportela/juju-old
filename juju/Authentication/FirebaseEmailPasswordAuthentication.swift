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
    
    func authenticate(email: String, password: String, callback: @escaping (Result<UserAuthenticationError>) -> Void)
    func create(email: String, password: String, callback: @escaping (Result<UserAuthenticationError>) -> Void)
}

struct FirebaseEmailPasswordAuthentication: UserAuthenticationProtocol {
    
    func authenticate(email: String, password: String, callback: @escaping (Result<UserAuthenticationError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error, let authCode = AuthErrorCode(rawValue: (error as NSError).code) {
                
                let userError = FirebaseAuthErrorAdapter.getErrorFrom(code: authCode)
                callback(.error(userError))
                return
            }
            
            guard user?.user.email != nil else {
                
                callback(.error(.customError(StringErrorConstants.unknownErrorMessage)))
                return
            }
            
            callback(.success)
        }
    }
    
    func create(email: String, password: String, callback: @escaping (Result<UserAuthenticationError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { ( user, error) in
            
            if let error = error, let authCode = AuthErrorCode(rawValue: (error as NSError).code) {
                
                let userError = FirebaseAuthErrorAdapter.getErrorFrom(code: authCode)
                callback(.error(userError))
                return
            }
            
            guard user?.user.email != nil else {
                
                callback(.error(.customError(StringErrorConstants.unknownErrorMessage)))
                return
            }
            
            callback(.success)
        }
        
    }
    
}