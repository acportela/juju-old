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
    
    private var currentLevel: TrainingLevel = .defaultLevel {
        didSet {
            self.dailyGoal = DailyGoal(level: self.currentLevel,
                                       mode: self.trainingMode)
            self.configureViewForInitialState()
        }
    }
    
    private var dailyGoal: DailyGoal = .defaultGoal
    
    private var currentTrainConfiguration: TrainingViewInitialConfiguration {

        return TrainingConfiguration(level: self.currentLevel, mode: self.trainingMode).viewConfiguration()
    }
    
    weak var delegate: TrainingViewControllerDelegate?
    
    //REMOVE
    
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
                                                                 withCurrentLevel: self.currentLevel)
    }
}

extension TrainingViewController {
    
    func updateCurrentLevelWith(_ newLevel: TrainingLevel) {
        
        self.currentLevel = newLevel
    }
    
    private func configureNavigation() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Exercícios"
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                        target: self,
                                        action: #selector(self.didTapLevelSettings))
        self.navigationItem.rightBarButtonItem = barButton
        
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    private func configureViewForInitialState() {
        
        self.trainingView.configure(with: .initialAndLevelChange(self.currentTrainConfiguration))
    }
    
    private func startTrain() {
        
        self.trainingView.configure(with: .start(self.dailyGoal))
    }
}

extension TrainingViewController: TrainingViewDelegate {

    func trainingViewWantsToStartTrain(_ trainingView: TrainingView) {
        
        self.startTrain()
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
