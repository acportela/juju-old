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
    
    private let navigation: UINavigationController
    weak var delegate: SignedOutCoordinatorDelegate?
    
    //TODO: Testing. Remove after signup coordinator is ready
    let userAuth: UserAuthenticationProtocol
    let persistence = FirebaseRepository<FirebaseFirestoreUser>()
    
    init(rootNavigation: UINavigationController) {
        
        self.navigation = rootNavigation
        let testUser = ClientUser(email: "testapp@gmail.com", name: "TestUserApp", dob: Date())
        self.userAuth = FirebaseEmailPasswordAuthentication(contextUser: testUser, password: "123456")
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
        
        let signUpViewController = SignUpViewController()
        signUpViewController.delegate = self
        navigation.pushViewController(signUpViewController, animated: true)
    }
    
    private func startSignIn() {
        
        let signInViewController = SignInViewController()
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
                              didSignInWithUser user: ClientUser) {
        
    }
    
    func signUpViewControllerDidTapBack(_ viewController: SignUpViewController) {
        navigation.popViewController(animated: true)
    }
    
}

extension SignedOutCoordinator: SignInViewControllerDelegate {
    
    func signInViewController(_ viewController: SignInViewController,
                              didSignInWithUser user: ClientUser) {
        
    }
    
    func signInViewControllerDidTapBack(_ viewController: SignInViewController) {
        navigation.popViewController(animated: true)
    }
    
}
