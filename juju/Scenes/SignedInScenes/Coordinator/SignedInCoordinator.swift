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
    private let diaryService: TrainingDiaryServiceProtocol
    private let trainingService: TrainingServiceProtocol
    private let userService: UserServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let user: ClientUser
    
    weak var delegate: SignedInCoordinatorDelegate?
    
    // MARK: Main Tab Bar
    private lazy var tabBarController: JujuTabBarController  = {
        
        let controllers = self.setupTabControllers()
        return JujuTabBarController(viewControllers: controllers, initialIndex: 1)
    }()

    // MARK: Training
    private lazy var trainingCoordinator: Coordinator = {
        
        let coordinator = TrainingCoordinator(rootNavigation: self.trainingNavigation,
                                              diaryService: self.diaryService,
                                              trainingService: self.trainingService,
                                              localDefaults: self.localStorage,
                                              user: self.user)
        return coordinator
    }()
    
    private let trainingNavigation: UINavigationController = {
        
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: TrainingViewController.title,
                                             image: Resources.Images.tabExercise,
                                             selectedImage: nil)
        return controller
    }()

    // MARK: Calendar
    private lazy var calendarCoordinator: Coordinator = {
        
        let coordinator = CalendarCoordinator(rootNavigation: self.calendarNavigation,
                                              diaryService: self.diaryService,
                                              user: self.user)
        return coordinator
    }()
    
    private let calendarNavigation: UINavigationController = {
        
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: CalendarViewController.title,
                                             image: Resources.Images.tabCalendar,
                                             selectedImage: nil)
        return controller
    }()
    
    // MARK: Profile
    private lazy var profileCoordinator: Coordinator = {
        
        let coordinator = ProfileCoordinator(rootNavigation: self.profileNavigation,
                                             userService: self.userService,
                                             localStorage: self.localStorage,
                                             user: self.user)
        coordinator.delegate = self
        return coordinator
    }()
    
    private let profileNavigation: UINavigationController = {
        
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: ProfileViewController.title,
                                             image: Resources.Images.tabProfile,
                                             selectedImage: nil)
        return controller
    }()
    
    init(rootController: UINavigationController,
         userService: UserServiceProtocol,
         diaryService: TrainingDiaryServiceProtocol,
         trainingService: TrainingServiceProtocol,
         localStorage: LocalStorageProtocol,
         user: ClientUser) {
        
        self.user = user
        self.rootNavigation = rootController
        self.userService = userService
        self.diaryService = diaryService
        self.trainingService = trainingService
        self.localStorage = localStorage
    }
    
    func start() {
        
        self.setupNavigationBar()
        self.trainingCoordinator.start()
        self.calendarCoordinator.start()
        self.profileCoordinator.start()
        self.rootNavigation.pushViewController(self.tabBarController, animated: false)
    }
    
    private func setupNavigationBar() {
        
        self.rootNavigation.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTabControllers() -> [UIViewController] {
        
        return [calendarNavigation, trainingNavigation, profileNavigation]
    }
}

extension SignedInCoordinator: ProfileCoordinatorDelegate {
    
    func profileCoordinatorDidLogout(_ coordinator: ProfileCoordinator) {
        
        self.rootNavigation.popViewController(animated: false)
        self.delegate?.signedInCoordinatorDidLogout(self)
    }
}
