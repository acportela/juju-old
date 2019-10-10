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
    
    private let trainingView = TrainingView(defaultSerie: .fallbackSeries)
    private var dataSource: TrainingDataSource

    let loadingController = LoadingViewController(animatable: JujuLoader())
    weak var delegate: TrainingViewControllerDelegate?
    
    var currentProgress: DiaryProgress?
    
    init(mode: TrainingMode,
         localDefaults: LocalStorageProtocol,
         diaryService: TrainingDiaryServiceProtocol,
         user: ClientUser) {
        
        self.dataSource = TrainingDataSource(mode: mode,
                                             localStorage: localDefaults,
                                             diaryService: diaryService,
                                             user: user)
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
        self.dataSource.delegate = self
        self.addBackgroundObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.initialDiarySetup()
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
    
    private func initialDiarySetup() {
        
        guard let diary = self.dataSource.localDiary else {
            
            self.startLoading()
            self.dataSource.fetchRemoteDiary()
            return
        }
        
        self.setupTrainingViewWithDiary(diary)
    }

    private func setupTrainingViewWithDiary(_ diary: DiaryProgress) {
        
        guard let serie = self.dataSource.getSerieFromDiary(diary) else {
            self.initWithDefaultTraining()
            return
        }
        
        self.trainingView.configure(with: .initial(serie))
    }
    
    func updatePreferredDifficulty(_ newDifficulty: TrainingDifficulty) {
        
        self.dataSource.updatePreferredDifficulty(newDifficulty)
    }
    
    private func startTrain() {
        
        self.trainingView.configure(with: .start)
    }
    
    private func stopTrain() {
        
        self.trainingView.configure(with: .stop)
    }
    
    private func initWithDefaultTraining() {
        
        self.trainingView.configure(with: .initial(Series.fallbackSeries))
    }
    
    private func showDefaultTrainingAlert() {
        
        let alert = UIAlertController(title: "Juju",
                                      message: "Ocorreu um erro ao buscar seu treino. Usaremos o treino padrão",
                                      primaryActionTitle: "OK")
        self.present(alert, animated: true)
    }
    
    private func handleRemoteFetchError(_ error: RepositoryError) {
        
        self.initWithDefaultTraining()
        
        if error != .noResults {
            
            self.showDefaultTrainingAlert()
        }
    }
    
    @objc
    private func didTapLevelSettings() {

        let currentDifficulty = self.dataSource.difficulty ?? .defaultLevel
        
        self.delegate?.trainingViewControllerDidTapLevelSettings(self,
                                                                 withCurrentDifficulty: currentDifficulty)
    }
}

// MARK: TrainingViewDelegate
extension TrainingViewController: TrainingViewDelegate {

    func trainingViewWantsToStartTrain(_ trainingView: TrainingView) {
        
        self.startTrain()
    }
    
    func trainingViewWantsToStopTrain(_ trainingView: TrainingView) {
        
        self.stopTrain()
    }
    
    func trainingViewFinishedSerie(_ trainingView: TrainingView) {
        //Update local diary
        //Update remote diary
    }
}

// MARK: Datasource Delegate
extension TrainingViewController: TrainingDataSourceDelegate {
    
    func trainingDataSourceDidFetchDiary(_ dataSource: TrainingDataSource, diary: DiaryProgress) {
        
        self.stopLoading()
        self.setupTrainingViewWithDiary(diary)
    }
    
    func trainingDataSourceFailedFetchingDiary(withError error: RepositoryError) {
        
        self.stopLoading()
        self.handleRemoteFetchError(error)
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
        
        self.stopTrain()
    }
}
