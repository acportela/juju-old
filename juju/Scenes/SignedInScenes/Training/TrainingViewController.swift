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
    
    override func loadView() {
        
        self.view = trainingView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureNavigation()
        self.configureView()
    }
    
    private func configureNavigation() {

        self.title = "Exercício"
    }
    
    private func configureView() {
        
        let temporaryConfig = TrainingConfiguration(level: "fácil", convergingDuration: 5)
        self.trainingView.configure(with: .initial(temporaryConfig))
    }
}
