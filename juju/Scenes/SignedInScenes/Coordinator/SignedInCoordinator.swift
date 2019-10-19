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
        controller.tabBarItem = UITabBarItem(title: .empty,
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
        controller.tabBarItem = UITabBarItem(title: "Diário",
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
        return coordinator
    }()
    
    private let profileNavigation: UINavigationController = {
        
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: "Perfil",
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
        
        let video = UIViewController()
        video.tabBarItem = UITabBarItem(title: "Vídeos",
                                        image: Resources.Images.tabVideo,
                                        selectedImage: nil)
        
        return [calendarNavigation, trainingNavigation, video, profileNavigation]
    }
}

extension SignedInCoordinator: ProfileViewControllerDelegate {
    
    func profileViewControllerDidLogout(_ controller: ProfileViewController) {
        
        self.rootNavigation.popViewController(animated: false)
        self.delegate?.signedInCoordinatorDidLogout(self)
    }
    
    func profileViewControllerWantsToChangePassword(_ controller: ProfileViewController) {
        
    }
}
