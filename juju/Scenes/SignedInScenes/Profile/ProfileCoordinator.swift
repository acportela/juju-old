//
//  ProfileCoordinator.swift
//  juju
//
//  Created by Antonio Rodrigues on 19/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {
    
    private let navigation: UINavigationController
    private let userService: UserServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let user: ClientUser
    
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
        
        // TODO: Finish
    }
}

extension ProfileCoordinator: ProfileViewControllerDelegate {
    
    func profileViewControllerDidLogout(_ controller: ProfileViewController) {
        
        // TODO: Finish
    }
    
    func profileViewControllerWantsToChangePassword(_ controller: ProfileViewController) {
        
        self.startChangePassword()
    }
}
