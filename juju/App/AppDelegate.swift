//
//  AppDelegate.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

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
        Fabric.with([Crashlytics.self])

        let userService = UserService(userAuth: FirebaseEmailPasswordAuthentication(),
                                      userRepo: FirebaseRepository<FirebaseFirestoreUser, FirebaseUserQuery>())
        self.appCoordinator = AppCoordinator(rootNavigation: rootController, userService: userService)
        
        self.appCoordinator?.start()
        return true
    }
}
