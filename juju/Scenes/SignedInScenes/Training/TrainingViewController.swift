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
    
    //REMOVE
    let trainingConfig = TrainingConfiguration(level: "fácil", convergingDuration: 5)
    let dailyGoal = DailyGoal(goalSteps: 4)!
    
    override func loadView() {
        
        self.view = trainingView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.trainingView.delegate = self
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Improve resume decision (initial vs resume)
        self.trainingView.configure(with: .initialAndLevelUp(trainingConfig))
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.trainingView.configure(with: .stop)
        self.viewDidAppear(animated)
    }
    
    private func configureNavigation() {

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
