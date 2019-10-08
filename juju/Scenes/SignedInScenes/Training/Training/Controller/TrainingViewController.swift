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
                                                   withCurrentDifficulty level: TrainingDifficulty)
}

final class TrainingViewController: UIViewController, Loadable {
    
    private let trainingView = TrainingView()
    private let localDefaults: LocalStorageProtocol
    private let diaryService: TrainingDiaryServiceProtocol
    private let chosenMode: TrainingMode
    private let user: ClientUser
    let loadingController = LoadingViewController(animatable: JujuLoader())
    weak var delegate: TrainingViewControllerDelegate?
    
    private var preferredDifficulty: TrainingDifficulty {
        get {
            guard let difficulty = self.localDefaults.get(from: .trainingDifficulty)
            as TrainingDifficulty? else { return .defaultLevel }
            return difficulty
        }
        set {
            self.localDefaults.set(newValue, for: .trainingDifficulty)
            self.getCurrentTrainingModel()
        }
    }
    
    private var availableTrainings: [TrainingModel] {
        
        return TrainingConstants.defaultTrainingModels
    }
    
    private var currentTrainining: TrainingModel = .fallbackTrainingModel {
        didSet {
            self.fetchDiaryProgress()
        }
    }
    
    private var diary: DiaryProgress? {
        didSet {
            self.configureViewForInitialState()
        }
    }
    
    //REMOVE
    
    init(mode: TrainingMode,
         localDefaults: LocalStorageProtocol,
         diaryService: TrainingDiaryServiceProtocol,
         user: ClientUser) {
        
        self.chosenMode = mode
        self.localDefaults = localDefaults
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
        self.getCurrentTrainingModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.getCurrentTrainingModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.trainingView.configure(with: .stop)
        super.viewWillDisappear(animated)
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
}

extension TrainingViewController {

    func updatePreferredDifficulty(_ newDifficulty: TrainingDifficulty) {
        
        self.preferredDifficulty = newDifficulty
    }
    
    private func getCurrentTrainingModel() {
        
        let difficulty = self.preferredDifficulty
        
        let newTraining = self.availableTrainings.first { $0.mode == self.chosenMode
                                                        && $0.difficulty == difficulty }
                        ?? TrainingModel.fallbackTrainingModel
        self.currentTrainining = newTraining
    }
    
    private func configureViewForInitialState() {
        
        //TODO: Change to serie (that maybe nil)
        self.trainingView.configure(with: .initial(self.currentTrainining))
    }
    
    private func startTrain() {
        
        self.trainingView.configure(with: .start)
    }
}

// MARK: TrainingViewDelegate
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
                                                                 withCurrentDifficulty: self.preferredDifficulty)
    }
}

// MARK: Diary Progress Logic
extension TrainingViewController {

    private func fetchDiaryProgress() {
        
        // TODO: Implement logic to try fecth locally first
        guard let localDiary = self.fetchDiaryLocally() else {
            self.fetchDiaryRemotely()
            return
        }
        self.diary = localDiary
    }
    
    private func fetchDiaryLocally() -> DiaryProgress? {
        return nil
    }
    
    private func fetchDiaryRemotely() {
        
        self.startLoading()
        
        self.diaryService.trainingWantsToFetchDiary(forUser: self.user,
                                                    withDate: Date()) { [weak self] result in
            
            self?.stopLoading()
            
            switch result {
                
            case .success(let diary):
                
                self?.diary = diary
                self?.saveDiaryLocally(diary)
                
            case .error:
                
                //TODO: Display warning to user
                self?.diary = nil
            }
        }
    }
    
    private func saveDiaryLocally(_ diary: DiaryProgress) {
        
    }
    
    private func updateRemoteDiary(_ diary: DiaryProgress) {
        
    }
}
