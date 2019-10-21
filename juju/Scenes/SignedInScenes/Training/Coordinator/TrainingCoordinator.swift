//
//  TrainingCoordinator.swift
//  juju
//
//  Created by Antonio Portela on 14/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

class TrainingCoordinator: Coordinator {
    
    private let navigation: UINavigationController
    private let diaryService: TrainingDiaryServiceProtocol
    private let localDefaults: LocalStorageProtocol
    private let user: ClientUser
    
    var trainingViewController: TrainingViewController?
    
    init(rootNavigation: UINavigationController,
         diaryService: TrainingDiaryServiceProtocol,
         localDefaults: LocalStorageProtocol,
         user: ClientUser) {
        
        self.diaryService = diaryService
        self.navigation = rootNavigation
        self.localDefaults = localDefaults
        self.user = user
    }
    
    func start() {
        
        self.configureNavigation()
        self.startTrainingMode()
    }
    
    private func configureNavigation() {
        
        self.navigation.configureOpaqueStyle()
    }
    
    private func startTrainingMode() {
        
        let trainingMode = TrainingModeViewController()
        trainingMode.delegate = self
        self.navigation.pushViewController(trainingMode, animated: false)
    }
    
    private func startTrainingWith(mode: TrainingMode) {
        
        let training = TrainingViewController(mode: mode,
                                              localDefaults: localDefaults,
                                              diaryService: self.diaryService,
                                              user: self.user)
        training.delegate = self
        
        self.trainingViewController = training
        self.navigation.pushViewController(training, animated: true)
    }
    
    private func startTrainingLevel(withCurrentLevel level: TrainingLevel) {
        
        let trainingLevel = TrainLevelViewController(currentLevel: level)
        trainingLevel.delegate = self
        self.navigation.present(trainingLevel, animated: true, completion: nil)
    }
    
    private func udpatePrefferedLevel(_ level: TrainingLevel) {
        
        self.trainingViewController?.updatePreferredLevel(level)
    }
}

extension TrainingCoordinator: TrainingModeViewControllerDelegate {
    
    func trainingModeViewController(_ controller: TrainingModeViewController,
                                    didChooseMode mode: TrainingMode) {

        self.startTrainingWith(mode: mode)
    }
}

extension TrainingCoordinator: TrainingViewControllerDelegate {
    
    func trainingViewControllerDidTapLevelSettings(_ controller: TrainingViewController,
                                                   withCurrentLevel level: TrainingLevel) {
        
        self.startTrainingLevel(withCurrentLevel: level)
    }
}

extension TrainingCoordinator: TrainLevelViewControllerDelegate {
    
    func trainLevelViewController(_ controller: TrainLevelViewController,
                                  didChooseLevel level: TrainingLevel) {
        
        self.udpatePrefferedLevel(level)
    }
}
