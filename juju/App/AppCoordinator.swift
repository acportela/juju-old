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
    
    private var signedInUser: ClientUser? {
        set { self.updateUserLocally(signedInUser) }
        get { return getUserLocally() }
    }
    
    init(rootNavigation: UINavigationController, userService: UserService) {
        
        self.navigation = rootNavigation
        self.userService = userService
    }
    
    func start() {
        
        guard let user = self.signedInUser else {
            self.startSignedOutFlow()
            return
        }
        
        self.startSignedInFlow(withUser: user)
    }
    
    private func updateUserLocally(_ user: ClientUser?) {
        
    }
    
    private func getUserLocally() -> ClientUser? {
        
        //TODO: Remove. Test puposes
        return ClientUser(email: "acarlosportela@gmail.com", name: "Antonio Rodrigues", dob: Date())
    }
    private func startSignedInFlow(withUser user: ClientUser) {
        
        let signedInCoordinator = SignedInCoordinator(rootController: self.navigation, user: user)
        signedInCoordinator.delegate = self
        
        self.childCoordinators.append(signedInCoordinator)
        signedInCoordinator.start()
        
    }
    
    private func startSignedOutFlow() {
        let signedOutCoordinator = SignedOutCoordinator(rootNavigation: navigation, userService: self.userService)
        signedOutCoordinator.delegate = self
        
        childCoordinators.append(signedOutCoordinator)
        signedOutCoordinator.start()
    }
}

extension AppCoordinator: SignedOutCoordinatorDelegate {
    
    func signedOutCoordinator(_ coordinator: SignedOutCoordinator, didSignInWithUser user: ClientUser) {
        
        _ = self.childCoordinators.popLast()
        self.signedInUser = user
        
        //TODO: Change this to self.start() once user is stored locally!!!
        //so that there's only one source of truth
        self.startSignedInFlow(withUser: user)
    }
}

extension AppCoordinator: SignedInCoordinatorDelegate {
    
    func signedInCoordinatorDidLogout(_ coordinator: SignedInCoordinator) {
        
        _ = self.childCoordinators.popLast()
        self.signedInUser = nil
        self.start()
    }
}
