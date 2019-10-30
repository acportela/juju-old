//
//  LogoutManager.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

protocol LogoutManagerDelegate: AnyObject {

    func userWasLoggedOut(_ manager: LogoutManagerProtocol)
}

protocol LogoutManagerProtocol: AnyObject {

    var localStorage: LocalStorageProtocol { get }
    var delegates: [LogoutManagerDelegate] { get }
    var userService: UserServiceProtocol { get }
    func logout()
    func register(_ delegate: LogoutManagerDelegate)
    func unregister(_ delegate: LogoutManagerDelegate)
    func shouldLogout(error: RepositoryError) -> Bool
}

class LogoutManager: LogoutManagerProtocol {

    public static let shared = LogoutManager()

    var localStorage: LocalStorageProtocol
    var userService: UserServiceProtocol

    var delegates: [LogoutManagerDelegate] = []

    func register(_ delegate: LogoutManagerDelegate) {

        self.delegates.append(delegate)
    }

    func unregister(_ delegate: LogoutManagerDelegate) {

        if let i = delegates.firstIndex(where: { $0 === delegate }) {
            delegates.remove(at: i)
        }
    }

    private init() {

        self.localStorage = UserDefaultsStorage()
        let userRepo = FirebaseRepository<FirebaseUser, FirebaseUserQuery>()
        self.userService = UserService(userAuth: FirebaseEmailPasswordAuthentication(), userRepo: userRepo)
    }

    func logout() {

        self.userService.userWantsToSignOut { [weak self] result in

            guard let sSelf = self else { return }

            switch result {

            case .success:

                sSelf.localStorage.remove(valuesForKeys: StorageKeys.allCases)

                sSelf.delegates.forEach { $0.userWasLoggedOut(sSelf) }

            case .error:

                break
            }
        }
    }

    func shouldLogout(error: RepositoryError) -> Bool {

        switch error {

        case .unauthorized: return true

        default: return false
            
        }
    }
}
