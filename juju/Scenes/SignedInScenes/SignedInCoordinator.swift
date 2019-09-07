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

class SignedInCoordinator: Coordinator {
    
    private let tabBarController =  UITabBarController()
    private var rootController: UINavigationController
    private let user: ClientUser
    weak var delegate: SignedInCoordinatorDelegate?
    
    let exercise = UIViewController()
    
    init(rootController: UINavigationController, user: ClientUser) {
        
        self.user = user
        self.rootController = rootController
    }
    
    func start() {
        
        self.setupTabBar()
    }
    
    private func setupTabBar() {
    
        self.tabBarController.tabBar.backgroundColor = Styling.Colors.white
        self.tabBarController.tabBar.tintColor = Styling.Colors.rosyPink
        self.tabBarController.tabBar.unselectedItemTintColor = Styling.Colors.rosyPink.withAlphaComponent(0.32)
        
        self.exercise.tabBarItem = UITabBarItem(title: .empty,
                                                image: Resources.Images.tabExercise, selectedImage: nil)
        
        let video = UIViewController()
        video.tabBarItem = UITabBarItem(title: .empty,
                                        image: Resources.Images.tabVideo, selectedImage: nil)
        
        let profile = UIViewController()
        profile.tabBarItem = UITabBarItem(title: .empty,
                                          image: Resources.Images.tabProfile, selectedImage: nil)
        
        let calendar = UIViewController()
        calendar.tabBarItem = UITabBarItem(title: .empty,
                                           image: Resources.Images.tabCalendar, selectedImage: nil)
        
        tabBarController.viewControllers = [calendar, exercise, video, profile]
        
        self.rootController.viewControllers = [tabBarController]
    }
}
