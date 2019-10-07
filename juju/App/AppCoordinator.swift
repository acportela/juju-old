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
    
    private lazy var splashScreen: SplashScreenViewController = {
        
        let splash = SplashScreenViewController(localStorage: self.localStorage)
        splash.delegate = self
        return splash
    }()

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
        
        self.navigation.pushViewController(splashScreen, animated: false)
        self.setupInitialUser()
    }
    
    private func startSignedInFlow(withUser user: ClientUser) {
        
        let signedInCoordinator = SignedInCoordinator(rootController: self.navigation,
                                                      userService: self.userService,
                                                      diaryService: self.diaryService,
                                                      localStorage: self.localStorage,
                                                      user: user)
        signedInCoordinator.delegate = self
        
        self.childCoordinators.append(signedInCoordinator)
        signedInCoordinator.start()
        
    }
    
    private func startSignedOutFlow() {
        
        let signedOutCoordinator = SignedOutCoordinator(rootNavigation: navigation,
                                                        userService: self.userService,
                                                        localStorage: self.localStorage)
        signedOutCoordinator.delegate = self
        
        childCoordinators.append(signedOutCoordinator)
        signedOutCoordinator.start()
    }
    
    private func setupInitialUser() {
        
        self.splashScreen.setupInitialUser()
    }
}

extension AppCoordinator: SignedOutCoordinatorDelegate {
    
    func signedOutCoordinator(_ coordinator: SignedOutCoordinator,
                              didSignInWithUser user: ClientUser) {
        
        _ = self.childCoordinators.popLast()
        self.startSignedInFlow(withUser: user)
    }
}

extension AppCoordinator: SignedInCoordinatorDelegate {
    
    func signedInCoordinatorDidLogout(_ coordinator: SignedInCoordinator) {
        
        _ = self.childCoordinators.popLast()
        self.setupInitialUser()
    }
}

extension AppCoordinator: SplashScreenViewControllerDelegate {
    
    func splashScreenViewControllerFailedFetchingUser(_ controller: SplashScreenViewController) {
        
        self.startSignedOutFlow()
    }

    func splashScreenViewController(_ controller: SplashScreenViewController,
                                    didFetchLocalUser user: ClientUser) {
        
        self.startSignedInFlow(withUser: user)
    }
}
