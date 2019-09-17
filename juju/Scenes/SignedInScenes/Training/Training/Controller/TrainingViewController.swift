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
                                                   withCurrentLevel level: TrainingLevel)
}

final class TrainingViewController: UIViewController {
    
    private let trainingView = TrainingView()
    private let trainingMode: TrainingMode
    private let defaultLevel: TrainingLevel = .easy
    private var currentLevel: TrainingLevel?
    
    weak var delegate: TrainingViewControllerDelegate?
    
    //REMOVE
    let dailyGoal = DailyGoal(goalSteps: 4)!
    
    init(trainingMode: TrainingMode) {
        
        self.trainingMode = trainingMode
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        //Improve resume decision (initial vs resume)
        self.trainingView.configure(with: .initialAndLevelUp(self.currentTrainConfiguration()))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.trainingView.configure(with: .stop)
        super.viewWillDisappear(animated)
    }
    
    private func configureNavigation() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Exercícios"
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .organize,
                                        target: self,
                                        action: #selector(self.didTapLevelSettings))
        self.navigationItem.rightBarButtonItem = barButton
        
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
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
        
        let level = self.currentLevel ?? self.defaultLevel
        self.delegate?.trainingViewControllerDidTapLevelSettings(self,
                                                                 withCurrentLevel: level)
    }
    
    private func currentTrainConfiguration() -> TrainingConfiguration {
        
        let adapter = TrainingConfigurationAdapter(level: self.currentLevel ?? self.defaultLevel,
                                                   mode: self.trainingMode)
        return adapter.configuration()
    }
}

extension TrainingViewController: TrainingViewDelegate {

    func trainingViewWantsToStartTrain(_ trainingView: TrainingView) {
        
        self.trainingView.configure(with: .start(self.dailyGoal))
    }
    
    func trainingViewWantsToResumeTrain(_ trainingView: TrainingView) {
        
        self.trainingView.configure(with: .resume)
    }
    
    func trainingViewWantsToStopTrain(_ trainingView: TrainingView) {
        
        self.trainingView.configure(with: .stop)
    }
    
    func trainingViewWantsToRestartTrain(_ trainingView: TrainingView) {
        
        self.trainingView.configure(with: .restart)
    }
    
    func trainingViewFinishedDailyGoal(_ trainingView: TrainingView) {
        
    }
}
