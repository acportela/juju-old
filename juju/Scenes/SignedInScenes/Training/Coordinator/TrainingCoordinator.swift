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
    
    var trainingViewController: TrainingViewController?
    
    init(rootNavigation: UINavigationController) {
        
        self.navigation = rootNavigation
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
    
    private func startTrainingWithMode(_ mode: TrainingMode) {
        
        let training = TrainingViewController(trainingMode: mode)
        training.delegate = self
        self.trainingViewController = training
        self.navigation.pushViewController(training, animated: true)
    }
    
    private func startTrainingLevel(withInitialLevel level: TrainingLevel) {
        
        let trainingLevel = TrainLevelViewController(currentLevel: level)
        trainingLevel.delegate = self
        self.navigation.present(trainingLevel, animated: true, completion: nil)
    }
}

extension TrainingCoordinator: TrainingModeViewControllerDelegate {
    
    func trainingModeViewController(_ controller: TrainingModeViewController,
                                    didChooseMode mode: TrainingMode) {
        
        self.startTrainingWithMode(mode)
    }
}

extension TrainingCoordinator: TrainingViewControllerDelegate {
    
    func trainingViewControllerDidTapLevelSettings(_ controller: TrainingViewController,
                                                   withCurrentLevel level: TrainingLevel) {
        
        self.startTrainingLevel(withInitialLevel: level)
    }
}

extension TrainingCoordinator: TrainLevelViewControllerDelegate {
    
    func trainLevelViewController(_ controller: TrainLevelViewController, didChooseLevel level: TrainingLevel) {
        
        self.trainingViewController?.updateCurrentLevelWith(level)
    }
}
