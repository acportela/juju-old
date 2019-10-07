//
//  SignedOutCoordinator.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SignedOutCoordinatorDelegate: AnyObject {
    
    func signedOutCoordinator(_ coordinator: SignedOutCoordinator, didSignInWithUser user: ClientUser)
}

class SignedOutCoordinator: Coordinator {
    
    private let userService: UserService
    private let navigation: UINavigationController
    private let localStorage: LocalStorageProtocol
    
    weak var delegate: SignedOutCoordinatorDelegate?

    init(rootNavigation: UINavigationController,
         userService: UserService,
         localStorage: LocalStorageProtocol) {
        
        self.navigation = rootNavigation
        self.userService = userService
        self.localStorage = localStorage
    }
    
    func start() {
        
        self.navigation.setNavigationBarHidden(true, animated: false)
        self.startSignIn()
    }
    
    private func startSignUp() {
        
        let signUpViewController = SignUpViewController(userService: self.userService)
        signUpViewController.delegate = self
        navigation.pushViewController(signUpViewController, animated: true)
    }
    
    private func startSignIn() {
        
        let signInViewController = SignInViewController(userService: self.userService)
        signInViewController.delegate = self
        navigation.pushViewController(signInViewController, animated: false)
    }
    
    private func saveUserLocally(_ user: ClientUser) {
        
        self.localStorage.set(user, for: .loggedUser)
    }
}

extension SignedOutCoordinator: SignUpViewControllerDelegate {
    
    func signUpViewController(_ viewController: SignUpViewController,
                              didSignUpWithUser user: ClientUser) {
        
        self.saveUserLocally(user)
        self.navigation.popViewController(animated: false)
        self.delegate?.signedOutCoordinator(self, didSignInWithUser: user)
    }
    
    func signUpViewControllerDidTapBack(_ viewController: SignUpViewController) {
        self.navigation.popViewController(animated: true)
    }
    
}

extension SignedOutCoordinator: SignInViewControllerDelegate {

    func signInViewController(_ viewController: SignInViewController,
                              didSignInWithUser user: ClientUser) {
        
        self.saveUserLocally(user)
        self.navigation.popViewController(animated: false)
        self.delegate?.signedOutCoordinator(self, didSignInWithUser: user)
    }
    
    func signInViewControllerWantsToCreateAccount(_ viewController: SignInViewController) {
        
        self.startSignUp()
    }
}
