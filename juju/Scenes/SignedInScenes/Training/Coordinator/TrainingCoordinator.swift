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
    
    var preferredDifficulty: TrainingDifficulty {
        
        get {
            guard let difficulty = self.localDefaults.get(from: .trainingDifficulty)
            as TrainingDifficulty? else {
                
                return .defaultLevel
            }
            return difficulty
        }
        
        set {
            self.localDefaults.set(value: newValue, for: .trainingDifficulty)
            self.trainingViewController?.chosenDifficulty = newValue
        }
    }
    
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
        self.navigation.pushViewController(trainingMode, animated: true)
    }
    
    private func startTrainingWith(mode: TrainingMode,
                                   andDifficulty difficulty: TrainingDifficulty) {
        
        let training = TrainingViewController(mode: mode,
                                              difficulty: difficulty,
                                              diaryService: self.diaryService,
                                              user: self.user)
        training.delegate = self
        
        self.trainingViewController = training
        self.navigation.pushViewController(training, animated: true)
    }
    
    private func startTrainingLevel(withCurrentLevel level: TrainingDifficulty) {
        
        let trainingLevel = TrainLevelViewController(currentLevel: level)
        trainingLevel.delegate = self
        self.navigation.present(trainingLevel, animated: true, completion: nil)
    }
}

extension TrainingCoordinator: TrainingModeViewControllerDelegate {
    
    func trainingModeViewController(_ controller: TrainingModeViewController,
                                    didChooseMode mode: TrainingMode) {

        self.startTrainingWith(mode: mode,
                               andDifficulty: self.preferredDifficulty)
    }
}

extension TrainingCoordinator: TrainingViewControllerDelegate {
    
    func trainingViewControllerDidTapLevelSettings(_ controller: TrainingViewController,
                                                   withCurrentLevel level: TrainingDifficulty) {
        
        self.startTrainingLevel(withCurrentLevel: level)
    }
}

extension TrainingCoordinator: TrainLevelViewControllerDelegate {
    
    func trainLevelViewController(_ controller: TrainLevelViewController,
                                  didChooseDifficulty difficulty: TrainingDifficulty) {
        
        self.preferredDifficulty = difficulty
    }
}
