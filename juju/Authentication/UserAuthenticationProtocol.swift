//
//  UserAuthenticationProtocol.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol UserAuthenticationProtocol {
    
    var contextUser: ClientUser {get}
    
    func authenticate(callback: @escaping (ContentResult<ClientUser, UserAuthenticationError>) -> Void)
    func create(callback: @escaping (ContentResult<ClientUser, UserAuthenticationError>) -> Void)
}
