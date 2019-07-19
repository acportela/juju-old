//
//  FirebaseEmailPasswordAuthentication.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation
import FirebaseAuth

struct FirebaseEmailPasswordAuthentication: UserAuthenticationProtocol {
    
    let contextUser: ClientUser
    let password: String //TODO: Find better approach to get to pass password
    
    func authenticate(callback: @escaping (ContentResult<ClientUser, UserAuthenticationError>) -> Void) {
        
    }
    
    func create(callback: @escaping (ContentResult<ClientUser, UserAuthenticationError>) -> Void) {
        
        Auth.auth().createUser(withEmail: contextUser.email, password: password) { ( user, error) in
            
            if let error = error, let authCode = AuthErrorCode(rawValue: (error as NSError).code) {
                
                let userError = FirebaseAuthErrorAdapter.getErrorFrom(code: authCode)
                callback(.error(userError))
            }
            
            guard user?.user.uid != nil else {
                
                callback(.error(.unknown))
                return
            }

            callback(.success(self.contextUser))
        }
        
    }
}
