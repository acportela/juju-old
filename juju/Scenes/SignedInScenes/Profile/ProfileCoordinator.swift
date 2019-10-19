//
//  ProfileCoordinator.swift
//  juju
//
//  Created by Antonio Rodrigues on 19/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    
    func profileCoordinatorDidLogout(_ coordinator: ProfileCoordinator)
}

class ProfileCoordinator: Coordinator {
    
    private let navigation: UINavigationController
    private let userService: UserServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let user: ClientUser
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    init(rootNavigation: UINavigationController,
         userService: UserServiceProtocol,
         localStorage: LocalStorageProtocol,
         user: ClientUser) {
        
        self.userService = userService
        self.navigation = rootNavigation
        self.localStorage = localStorage
        self.user = user
    }
    
    func start() {
        
        self.configureNavigation()
        self.startProfile()
    }
    
    private func configureNavigation() {
        
        self.navigation.configureOpaqueStyle()
    }
    
    private func startProfile() {
        
        let profile = ProfileViewController(loggerUser: self.user,
                                            userService: self.userService,
                                            localStorage: self.localStorage)
        profile.delegate = self
        self.navigation.pushViewController(profile, animated: false)
    }
    
    private func startChangePassword() {

        let changePassword = ChangePasswordViewController(loggerUser: self.user,
                                                          userService: self.userService)
        changePassword.delegate = self
        self.navigation.pushViewController(changePassword, animated: true)
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    
    func profileViewControllerDidLogout(_ controller: ProfileViewController) {
        
        self.delegate?.profileCoordinatorDidLogout(self)
    }
    
    func profileViewControllerWantsToChangePassword(_ controller: ProfileViewController) {
        
        self.startChangePassword()
    }
}

extension ProfileCoordinator: ChangePasswordViewControllerDelegate {
    
    func changePasswordViewControllerDidChangePassword(_ controller: ChangePasswordViewController) {
        
        self.navigation.popViewController(animated: false)
        Snackbar.showSuccess(message: "Sua senha foi alterada com sucesso", in: navigation.view)
    }
}
