//
//  SignUpViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 09/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()
    
    override func loadView() {
        
        self.view = signUpView
    }
}
