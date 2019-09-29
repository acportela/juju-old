//
//  TrainLevelViewController.swift
//  juju
//
//  Created by Antonio Portela on 17/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainLevelViewControllerDelegate: AnyObject {
    
    func trainLevelViewController(_ controller: TrainLevelViewController, didChooseLevel level: TrainingDifficulty)
}

final class TrainLevelViewController: UIViewController {
    
    private let trainLevelView = TrainingLevelView()
    
    private var currentLevel: TrainingDifficulty
    
    weak var delegate: TrainLevelViewControllerDelegate?
    
    init(currentLevel: TrainingDifficulty) {
        
        self.currentLevel = currentLevel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = self.trainLevelView
        self.trainLevelView.delegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureNavigation()
        self.trainLevelView.configure(with: .selectLevel(self.currentLevel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureNavigation() {
        
        self.title = "Nível do exercício"
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
}

extension TrainLevelViewController: TrainingLevelViewDelegate {
    
    func trainingLevelView(_ view: TrainingLevelView, didSelectLevel level: TrainingDifficulty) {
        
        self.currentLevel = level
        self.delegate?.trainLevelViewController(self, didChooseLevel: level)
    }
}
