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
    func signInViewControllerWantsToCreateAccount(_ viewController: SignInViewController)
}

final class SignInViewController: UIViewController, Loadable {
    
    private let signInView = SignInView()
    private let userService: UserService
    let loadingController = LoadingViewController(animatable: JujuLoader())
    weak var delegate: SignInViewControllerDelegate?
    
    init(userService: UserService) {
        
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = signInView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupCallbacks()
    }
    
    func setupCallbacks() {
        
        signInView.onDoneAction = { [weak self] in
            
            guard let sSelf = self else { return }
            guard sSelf.signInView.fieldsAreValid, let credentials = sSelf.credentials() else {
                
                sSelf.enableAlertState("Verifique os campos e tente novamente")
                return
            }
            
            sSelf.proceedWithSignIn(email: credentials.email, pass: credentials.pass)
        }
        
        signInView.onCreateAccountTap = { [weak self] in
            
            guard let sSelf = self else { return }
            sSelf.delegate?.signInViewControllerWantsToCreateAccount(sSelf)
        }
    }

    private func credentials() -> (email: String, pass: String)? {
        
        guard let email = signInView.emailInput.currentValue,
              let pass = signInView.passwordInput.currentValue else { return nil }
        
        return (email: email, pass: pass)
    }
    
    func proceedWithSignIn(email: String, pass: String) {
        
        self.startLoading()
        self.userService.userWantsToSignIn(email: email, password: pass) { [weak self] result in
            
            guard let sSelf = self else { return }
            sSelf.stopLoading()
            
            switch result {
            
            case .success(let user):
                
                sSelf.delegate?.signInViewController(sSelf, didSignInWithUser: user)
                sSelf.signInView.clearAllInputs()
                
            case .error(let error):
                
                sSelf.enableAlertState(error.errorMessage)
            }
        }
    }

    private func enableAlertState(_ message: String) {

        Snackbar.showError(message: message, in: self.view)
    }
}
