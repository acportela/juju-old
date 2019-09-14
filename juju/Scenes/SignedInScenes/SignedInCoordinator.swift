//
//  SignedInCoordinator.swift
//  juju
//
//  Created by Antonio Portela on 04/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SignedInCoordinatorDelegate: AnyObject {
    
    func signedInCoordinatorDidLogout(_ coordinator: SignedInCoordinator)
}

class SignedInCoordinator: NSObject, Coordinator {
    
    private var rootNavigation: UINavigationController
    private let user: ClientUser
    weak var delegate: SignedInCoordinatorDelegate?
    
    private lazy var trainingCoordinator = TrainingCoordinator(rootNavigation: self.trainingNavigation)
    
    private lazy var tabBarController: JujuTabBarController  = {
        let controllers = self.setupTabControllers()
        return JujuTabBarController(viewControllers: controllers, initialIndex: 1)
    }()
    private let trainingNavigation: UINavigationController = {
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: .empty,
                                             image: Resources.Images.tabExercise,
                                             selectedImage: nil)
        return controller
    }()

    init(rootController: UINavigationController, user: ClientUser) {
        self.user = user
        self.rootNavigation = rootController
    }
    
    func start() {
        self.setupNavigationBar()
        self.trainingCoordinator.start()
        self.rootNavigation.pushViewController(self.tabBarController, animated: true)
    }
    
    private func setupNavigationBar() {
        self.rootNavigation.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTabControllers() -> [UIViewController] {
        
        let video = UIViewController()
        video.tabBarItem = UITabBarItem(title: "Vídeos",
                                        image: Resources.Images.tabVideo,
                                        selectedImage: nil)
        
        let profile = UIViewController()
        profile.tabBarItem = UITabBarItem(title: "Perfil",
                                          image: Resources.Images.tabProfile,
                                          selectedImage: nil)
        
        let calendar = UIViewController()
        calendar.tabBarItem = UITabBarItem(title: "Calendário",
                                           image: Resources.Images.tabCalendar,
                                           selectedImage: nil)
        
        return [calendar, trainingNavigation, video, profile]
    }
}
