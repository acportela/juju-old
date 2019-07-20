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
    
    private var isUserSignedIn: Bool {
        //TODO Implement check
        return false
    }
    
    init(rootNavigation: UINavigationController) {
        
        self.navigation = rootNavigation
    }
    
    func start() {
        
        self.isUserSignedIn ? startSignedInFlow() : startSignedOutFlow()
    }
    
    //TODO Add ClientUser argument
    private func startSignedInFlow() {
        
    }
    
    private func startSignedOutFlow() {
        
        let signedOutCoordinator = SignedOutCoordinator(rootNavigation: navigation)
        signedOutCoordinator.delegate = self
        
        childCoordinators.append(signedOutCoordinator)
        signedOutCoordinator.start()
    }
}

extension AppCoordinator: SignedOutCoordinatorDelegate {
    
    func signedOutCoordinator(_ coordinator: SignedOutCoordinator, didSignInWithUser user: ClientUser) {
        
    }
}
