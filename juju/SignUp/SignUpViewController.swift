//
//  SignUpViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 09/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    
    func signUpViewController(_ viewController: IntroViewController, didSignInWithUser user: ClientUser)
}

final class SignUpViewController: SignedOutThemeViewController {
    
    private let signUpView = SignUpView()
    weak var delegate: SignUpViewControllerDelegate?
    
    override func loadView() {
        
        self.view = signUpView
    }
}
