//
//  TrainingViewController.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainingViewControllerDelegate: AnyObject {
    
    func trainingViewControllerDidTapLevelSettings(_ controller: TrainingViewController,
                                                   withCurrentLevel level: TrainingDifficulty)
}

final class TrainingViewController: UIViewController {
    
    private let trainingView = TrainingView()
    
    private var trainingModel: TrainingModel = .fallbackTrainingModel {
        didSet {
            self.configureViewForInitialState()
        }
    }

    weak var delegate: TrainingViewControllerDelegate?
    
    //REMOVE
    
    init(mode: TrainingMode, difficulty: TrainingDifficulty) {
        
        super.init(nibName: nil, bundle: nil)
        self.trainingModel = modelFromModeAndDifficulty(mode: mode, difficulty: difficulty)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = trainingView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.trainingView.delegate = self
        self.addBackgroundObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.configureViewForInitialState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.trainingView.configure(with: .stop)
        super.viewWillDisappear(animated)
    }
}

extension TrainingViewController {
    
    private func addBackgroundObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationWillEnterBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    @objc
    private func applicationWillEnterBackground() {
        
        self.trainingView.configure(with: .stop)
    }
    
    @objc
    private func didTapLevelSettings() {

        self.delegate?.trainingViewControllerDidTapLevelSettings(self,
                                                                 withCurrentLevel: self.trainingModel.difficulty)
    }
}

extension TrainingViewController {
    
    func updateCurrentDifficultyWith(_ newDifficulty: TrainingDifficulty) {
        
        let newModel = self.modelFromModeAndDifficulty(mode: self.trainingModel.mode, difficulty: newDifficulty)
        self.trainingModel = newModel
    }

    private func modelFromModeAndDifficulty(mode: TrainingMode,
                                            difficulty: TrainingDifficulty) -> TrainingModel {
        
        let modelSet = TrainingConstants.defaultTrainingModels
        
        return modelSet.first { $0.mode == mode && $0.difficulty == difficulty }
                        ?? TrainingModel.fallbackTrainingModel
    }
        
    private func configureNavigation() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Exercícios"
        
        let barButton = UIBarButtonItem(image: Resources.Images.levelsIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(self.didTapLevelSettings))
        self.navigationItem.rightBarButtonItem = barButton
        
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    private func configureViewForInitialState() {
        
        self.trainingView.configure(with: .initial(self.trainingModel))
    }
    
    private func startTrain() {
        
        self.trainingView.configure(with: .start)
    }
}

extension TrainingViewController: TrainingViewDelegate {

    func trainingViewWantsToStartTrain(_ trainingView: TrainingView) {
        
        self.startTrain()
    }
    
    func trainingViewWantsToStopTrain(_ trainingView: TrainingView) {
        
        self.trainingView.configure(with: .stop)
    }
    
    func trainingViewFinishedSerie(_ trainingView: TrainingView) {
        
    }
}
