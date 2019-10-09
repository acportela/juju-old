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
    private var dataSource: TrainingDataSource

    let loadingController = LoadingViewController(animatable: JujuLoader())
    weak var delegate: TrainingViewControllerDelegate?
    
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
        self.updateInitialState()
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
    
    private func updateInitialState() {
        
        //Resolve local vs remote infinite loop
        guard let diary = self.dataSource.localDiary else {
            self.dataSource.fetchRemoteDiary()
            return
        }
        let serie = self.dataSource.getSerieFromDiary(diary)
        self.trainingView.configure(with: .initial(serie))
    }
}

extension TrainingViewController {

    func updatePreferredDifficulty(_ newDifficulty: TrainingDifficulty) {
        
        self.dataSource.updatePreferredDifficulty(newDifficulty)
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

extension TrainingViewController: TrainingDataSourceDelegate {
    
    func trainingDataSourceStartedFetch(_ dataSource: TrainingDataSource) {
        
        self.startLoading()
    }
    
    func trainingDataSourceDidFetchDiary(_ dataSource: TrainingDataSource) {
        
        self.stopLoading()
        self.updateInitialState()
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
                                                                 withCurrentDifficulty: self.dataSource.difficulty)
    }
}
