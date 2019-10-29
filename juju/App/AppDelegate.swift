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
import UserNotifications

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
    
        self.setupFirebase()
        self.configureKeyboardManager()
        self.registerForRemoteNotification()
        self.requestNotificationAuthorization()
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
    
    private func setupFirebase() {
        
        FirebaseApp.configure()
        let settings = Firestore.firestore().settings
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
    }

    private func configureKeyboardManager() {
        
        IQKeyboardManager.shared.enable = true
    }
}

// MARK: Notification Handling
extension AppDelegate {

    // MARK: Permission
    private func requestNotificationAuthorization() {

        UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    private func checkUserNotificationAuthorization() {

        UNUserNotificationCenter.current().getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else { return }
      }
    }

    // MARK: Registering
    private func registerForRemoteNotification() {

        UIApplication.shared.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
}
