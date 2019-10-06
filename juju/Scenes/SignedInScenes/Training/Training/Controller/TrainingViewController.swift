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
    
    private let chosenMode: TrainingMode
    
    var chosenDifficulty: TrainingDifficulty {
        didSet {
            self.updateCurrentTraining()
        }
    }
    
    private var availableTrainings: [TrainingModel] {
        
        return TrainingConstants.defaultTrainingModels
    }
    
    private var currentTrainining: TrainingModel = .fallbackTrainingModel {
        didSet {
            self.configureViewForInitialState()
        }
    }

    private let user: ClientUser
    private let diaryService: TrainingDiaryServiceProtocol
    weak var delegate: TrainingViewControllerDelegate?
    
    //REMOVE
    
    init(mode: TrainingMode,
         difficulty: TrainingDifficulty,
         diaryService: TrainingDiaryServiceProtocol,
         user: ClientUser) {
        
        self.chosenMode = mode
        self.chosenDifficulty = difficulty
        self.diaryService = diaryService
        self.user = user
        super.init(nibName: nil, bundle: nil)
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
        self.fetchTodayConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.updateCurrentTraining()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.trainingView.configure(with: .stop)
        super.viewWillDisappear(animated)
    }
    
    private func fetchTodayConfiguration() {
        
        // TODO: Implement logic to try fecth locally first
        // TODO: Include loading
        
        self.diaryService.trainingWantsToFetchDiary(forUser: self.user, withDate: Date()) { result in
            
            switch result {
                
            case .success(let diary):
                print(diary)
            case .error:
                break
            }
        }
    }
}

extension TrainingViewController {

    private func updateCurrentTraining() {
        
        let newTraining = self.availableTrainings.first { $0.mode == self.chosenMode
                                                        && $0.difficulty == self.chosenDifficulty }
                        ?? TrainingModel.fallbackTrainingModel
        self.currentTrainining = newTraining
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
        
        self.trainingView.configure(with: .initial(self.currentTrainining))
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
                                                                 withCurrentLevel: self.currentTrainining.difficulty)
    }
}
