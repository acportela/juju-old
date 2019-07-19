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
    
    //TODO: Testing. Remove after signup coordinator is ready
    let userAuth: UserAuthenticationProtocol
    let persistence = FirebaseRepository<FirebaseFirestoreUser>()
    
    init(rootNavigation: UINavigationController) {
        
        self.navigation = rootNavigation
        let testUser = ClientUser(email: "testapp@gmail.com", name: "TestUserApp", dob: Date())
        self.userAuth = FirebaseEmailPasswordAuthentication(contextUser: testUser, password: "123456")
    }
    
    func start() {
        
        navigation.pushViewController(SignUpViewController(), animated: true)
//        userAuth.create { resutn in
//            switch resutn {
//            case .success(let client):
//                print(client.email)
//            case .error(let error):
//                print(error.errorMessage)
//            }
//        }
        let newUser = FirebaseFirestoreUser(name: "Antonio", email: "acportela@gmail.com", dateOfBirth: Date())
        //persistence.save(entity: newUser) { result in print(result) }
    }
    
}
