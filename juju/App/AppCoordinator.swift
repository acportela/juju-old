//
//  AppCoordinator.swift
//  juju
//
//  Created by Antonio Rodrigues on 09/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

    private let childCoordinators: [Coordinator] = []
    private let navigation: UINavigationController
    
    init(rootNavigation: UINavigationController) {
        
        self.navigation = rootNavigation
    }
    
    func start() {
        
    }
    
}
