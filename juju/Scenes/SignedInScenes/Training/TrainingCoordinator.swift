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
        self.navigation.pushViewController(training, animated: true)
    }
}

extension TrainingCoordinator: TrainingModeViewControllerDelegate {
    
    func trainingModeViewController(_ controller: TrainingModeViewController,
                                    didChooseMode mode: TrainingMode) {
        
        self.startTrainingWithMode(mode)
    }
}
