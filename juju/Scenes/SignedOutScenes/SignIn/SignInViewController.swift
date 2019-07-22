//
//  SignInViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate: AnyObject {
    
    func signInViewController(_ viewController: SignInViewController, didSignInWithUser user: ClientUser)
    func signInViewControllerDidTapBack(_ viewController: SignInViewController)
}

final class SignInViewController: SignedOutThemeViewController {
    
    private let signInView = SignInView()
    weak var delegate: SignInViewControllerDelegate?
    
    override func loadView() {
        
        self.view = signInView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardListener.shared.register(signInView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardListener.shared.remove(signInView)
    }
    
    func setupCallbacks() {
        
        signInView.onBackTap = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.delegate?.signInViewControllerDidTapBack(sSelf)
        }
        
        signInView.onDoneAction = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.fieldsAreValid() ? sSelf.proceedWithSignIn() : sSelf.enableErrorState()
        }
    }
    
    func fieldsAreValid() -> Bool {
        return false
    }
    
    func proceedWithSignIn() {
        
    }
    
    func enableErrorState() {
        
    }
}
