//
//  TrainingModeViewController.swift
//  juju
//
//  Created by Antonio Portela on 14/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainingModeViewControllerDelegate: AnyObject {
    
    func trainingModeViewController(_ controller: TrainingModeViewController, didChooseMode mode: TrainingMode)
}

final class TrainingModeViewController: UIViewController {
    
    private let trainingModeView = TrainingModeView()
    
    weak var delegate: TrainingModeViewControllerDelegate?
    
    override func loadView() {
        
        self.view = trainingModeView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.trainingModeView.delegate = self
        self.configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    private func configureNavigation() {
        
        self.title = "Exercícios"
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
}

extension TrainingModeViewController: TrainingModeViewDelegate {
    
    func trainingModeViewDidTapSlowTrain(_ view: TrainingModeView) {
        
        self.delegate?.trainingModeViewController(self, didChooseMode: .slow)
    }
    
    func trainingModeViewDidTapFastTrain(_ view: TrainingModeView) {
        
        //self.delegate?.trainingModeViewController(self, didChooseMode: .fast)
    }
}
