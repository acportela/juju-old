//
//  AppDelegate.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootController = UINavigationController()
        self.window?.rootViewController = rootController
        self.window?.makeKeyAndVisible()
    
        FirebaseApp.configure()
        self.configureKeyboardManager()
        self.setupDependencies(withRootController: rootController)
        
        self.appCoordinator?.start()
        
        return true
    }

    private func setupDependencies(withRootController root: UINavigationController) {
        
        let userRepo = FirebaseRepository<FirebaseUser, FirebaseUserQuery>()
        let userService = UserService(userAuth: FirebaseEmailPasswordAuthentication(), userRepo: userRepo)
        let diaryRepo = FirebaseRepository<FirebaseTrainingDiary, FirebaseDiaryQuery>()
        let diaryService = TrainingDiaryService(diaryRepo: diaryRepo)
        let defaults = UserDefaultsStorage()

        self.appCoordinator = AppCoordinator(rootNavigation: root,
                                             userService: userService,
                                             diaryService: diaryService,
                                             localStorage: defaults)
    }
    
    private func configureKeyboardManager() {
        
        IQKeyboardManager.shared.enable = true
        
    }
}
