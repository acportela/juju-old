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
    private let trainingService: TrainingServiceProtocol
    var trainingViewController: TrainingViewController?
    
    let loadingViewController: LoadingViewController = {
        
        let loading = LoadingViewController(animatable: JujuLoader())
        loading.modalPresentationStyle = .fullScreen
        return loading
    }()
    
    var trainingModels: [TrainingModel]?
    
    //TODO: Save last set difficulty (use get and set instead)
    //Remove default value. Get from and save to local storage
    var preferredDifficulty: TrainingDifficulty = .easy {
        didSet {
            self.trainingViewController?.updateCurrentLevelWith(self.preferredDifficulty)
        }
    }
    
    init(rootNavigation: UINavigationController,
         trainingService: TrainingServiceProtocol) {
        
        self.trainingService = trainingService
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
    
    private func startTrainingWith(mode: TrainingMode,
                                   andDifficulty difficulty: TrainingDifficulty) {
        
//        guard let modelSet = self.trainingModels else {
//
//            self.fetchTrainingModels(applyingMode: mode)
//            return
//        }
        
        let modelSet = TrainingConstants.defaultTrainingModels
        
        let model = modelSet.first { $0.mode == mode && $0.difficulty == difficulty }
                    ?? TrainingModel.fallbackTrainingModel
        
        let training = TrainingViewController(trainingModel: model)
        training.delegate = self
        
        self.trainingViewController = training
        self.navigation.pushViewController(training, animated: true)
    }
    
    private func startTrainingLevel(withCurrentLevel level: TrainingDifficulty) {
        
        let trainingLevel = TrainLevelViewController(currentLevel: level)
        trainingLevel.delegate = self
        self.navigation.present(trainingLevel, animated: true, completion: nil)
    }
    
    private func startLoadingViewController() {
        
        let loading = LoadingViewController(animatable: JujuLoader())
        self.navigation.present(loading, animated: false, completion: nil)
    }
}

extension TrainingCoordinator {
    
    private func fetchTrainingModels(applyingMode mode: TrainingMode) {
        
        self.navigation.present(self.loadingViewController, animated: true, completion: nil)
        self.trainingService.trainingWantsToFetchModels { [weak self] contentResult in
            
            guard let sSelf = self else { return }
            
            switch contentResult {
                
            case .success(let models):
                
                sSelf.trainingModels = models
                sSelf.loadingViewController.dismiss(animated: false)
                sSelf.startTrainingWith(mode: mode, andDifficulty: sSelf.preferredDifficulty)
                
            case .error(let error):
                
                sSelf.loadingViewController.dismiss(animated: true)
                print(error)
            }
        }
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
                                  didChooseLevel level: TrainingDifficulty) {
        
        self.trainingViewController?.updateCurrentLevelWith(level)
    }
}
