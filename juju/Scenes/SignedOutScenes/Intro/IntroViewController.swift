//
//  IntroViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol IntroViewControllerDelegate: AnyObject {
    
    func introViewControllerDidTapSignIn(_ viewController: IntroViewController)
    func introViewControllerDidTapSignUp(_ viewController: IntroViewController)
}

final class IntroViewController: UIViewController {
    
    private let introView = IntroView()
    
    weak var delegate: IntroViewControllerDelegate?
    
    override func loadView() {
        
        self.view = introView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupActions()
    }
    
    private func setupActions() {
        
        self.introView.onSignInTap = { self.delegate?.introViewControllerDidTapSignIn(self) }
        self.introView.onSignUpTap = { self.delegate?.introViewControllerDidTapSignUp(self) }
    }
}
