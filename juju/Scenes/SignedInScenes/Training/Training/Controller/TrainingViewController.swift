//
//  TrainingViewController.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class TrainingViewController: UIViewController {
    
    private let trainingView = TrainingView()
    private let trainingMode: TrainingMode
    
    //REMOVE
    let trainingConfig = TrainingConfiguration(level: "fácil", convergingDuration: 5)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Improve resume decision (initial vs resume)
        self.trainingView.configure(with: .initialAndLevelUp(trainingConfig))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.trainingView.configure(with: .stop)
        super.viewWillDisappear(animated)
    }
    
    private func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Exercícios"
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
