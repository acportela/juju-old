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
    
    private var isUserSignedIn: Bool {
        //TODO Implement check
        return false
    }
    
    init(rootNavigation: UINavigationController, userService: UserService) {
        
        self.navigation = rootNavigation
        self.userService = userService
    }
    
    func start() {
        
        self.isUserSignedIn ? startSignedInFlow() : startSignedOutFlow()
    }
    
    //TODO Add ClientUser argument
    private func startSignedInFlow() {
        
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
        
    }
}
