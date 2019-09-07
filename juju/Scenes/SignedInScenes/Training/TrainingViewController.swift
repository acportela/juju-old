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
    }
    
    private func configureNavigation() {

        self.title = "Exercício"
    }
}
