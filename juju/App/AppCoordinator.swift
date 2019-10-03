//
//  AppCoordinator.swift
//  juju
//
//  Created by Antonio Rodrigues on 09/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

    private var childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    private let userService: UserService
    private let diaryService: TrainingDiaryServiceProtocol
    private let localStorage: LocalStorageProtocol
    
    private var loggedUser: ClientUser? {
        
        set {
            if newValue == nil {
                self.localStorage.remove(from: [.loggedUser])
            } else {
                self.localStorage.set(value: newValue, for: .loggedUser)
            }
        }
        
        get {
            guard let validUser = self.localStorage.get(from: .loggedUser) as ClientUser? else {
                return nil
            }
            return validUser
        }
    }
    
    init(rootNavigation: UINavigationController,
         userService: UserService,
         diaryService: TrainingDiaryServiceProtocol,
         localStorage: LocalStorageProtocol) {
        
        self.navigation = rootNavigation
        self.userService = userService
        self.localStorage = localStorage
        self.diaryService = diaryService
    }
    
    func start() {
        
        guard let user = self.loggedUser else {
            
            self.startSignedOutFlow()
            return
        }
        
        self.startSignedInFlow(withUser: user)
    }
    
//    private func updateUserLocally(_ user: ClientUser?) {
//
//    }
//
//    private func getUserLocally() -> ClientUser? {
//
//        return  ClientUser(email: "acarlosportela@gmail.com", name: "Antonio Rodrigues", dob: Date())
//    }
    
    private func startSignedInFlow(withUser user: ClientUser) {
        
        let signedInCoordinator = SignedInCoordinator(rootController: self.navigation,
                                                      diaryService: self.diaryService,
                                                      localStorage: self.localStorage,
                                                      user: user)
        signedInCoordinator.delegate = self
        
        self.childCoordinators.append(signedInCoordinator)
        signedInCoordinator.start()
        
    }
    
    private func startSignedOutFlow() {
        let signedOutCoordinator = SignedOutCoordinator(rootNavigation: navigation,
                                                        userService: self.userService)
        signedOutCoordinator.delegate = self
        
        childCoordinators.append(signedOutCoordinator)
        signedOutCoordinator.start()
    }
}

extension AppCoordinator: SignedOutCoordinatorDelegate {
    
    func signedOutCoordinator(_ coordinator: SignedOutCoordinator,
                              didSignInWithUser user: ClientUser) {
        
        _ = self.childCoordinators.popLast()
   //     self.signedInUser = user
        self.loggedUser = user
        self.start()
    }
}

extension AppCoordinator: SignedInCoordinatorDelegate {
    
    func signedInCoordinatorDidLogout(_ coordinator: SignedInCoordinator) {
        
        _ = self.childCoordinators.popLast()
        self.loggedUser = nil
        self.start()
    }
}
