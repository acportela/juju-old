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
    weak var delegate: SignedOutCoordinatorDelegate?

    init(rootNavigation: UINavigationController, userService: UserService) {
        
        self.navigation = rootNavigation
        self.userService = userService
    }
    
    func start() {
        
        self.startIntro()
    }
    
    private func startIntro() {
        
        let introViewController = IntroViewController()
        introViewController.delegate = self
        
        navigation.pushViewController(introViewController, animated: true)
    }
    
    private func startSignUp() {
        
        let signUpViewController = SignUpViewController(userService: self.userService)
        signUpViewController.delegate = self
        navigation.pushViewController(signUpViewController, animated: true)
    }
    
    private func startSignIn() {
        
        let signInViewController = SignInViewController(userService: self.userService)
        signInViewController.delegate = self
        navigation.pushViewController(signInViewController, animated: true)
    }
}

extension SignedOutCoordinator: IntroViewControllerDelegate {
    
    func introViewControllerDidTapSignIn(_ viewController: IntroViewController) {
        
        startSignIn()
    }
    
    func introViewControllerDidTapSignUp(_ viewController: IntroViewController) {
        
        startSignUp()
    }
}

extension SignedOutCoordinator: SignUpViewControllerDelegate {
    
    func signUpViewController(_ viewController: SignUpViewController,
                              didSignUpWithUser user: ClientUser) {
        self.delegate?.signedOutCoordinator(self, didSignInWithUser: user)
    }
    
    func signUpViewControllerDidTapBack(_ viewController: SignUpViewController) {
        navigation.popViewController(animated: true)
    }
    
}

extension SignedOutCoordinator: SignInViewControllerDelegate {
    
    func signInViewController(_ viewController: SignInViewController,
                              didSignInWithUser user: ClientUser) {
        self.delegate?.signedOutCoordinator(self, didSignInWithUser: user)
    }
    
    func signInViewControllerDidTapBack(_ viewController: SignInViewController) {
        navigation.popViewController(animated: true)
    }
    
}
