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
    func signInViewControllerDidCreateAccount(_ viewController: SignInViewController)
}

final class SignInViewController: UIViewController {
    
    private let signInView = SignInView()
    private let userService: UserService
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardListener.shared.register(signInView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        KeyboardListener.shared.remove(signInView)
        super.viewWillDisappear(animated)
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
        
        signInView.onCreateTap = { [weak self] in
            
            guard let sSelf = self else { return }
            sSelf.delegate?.signInViewControllerDidCreateAccount(sSelf)
        }
    }

    private func credentials() -> (email: String, pass: String)? {
        
        guard let email = signInView.emailInput.currentValue,
              let pass = signInView.passwordInput.currentValue else { return nil }
        
        return (email: email, pass: pass)
    }
    
    func proceedWithSignIn(email: String, pass: String) {
        
        self.userService.userWantsToSignIn(email: email, password: pass) { [weak self] result in
            guard let sSelf = self else { return }
            switch result {
            case .success(let user):
                sSelf.delegate?.signInViewController(sSelf, didSignInWithUser: user)
                //TODO Remove later
                sSelf.enableAlertState("Usuário logado!")
            case .error:
                sSelf.enableAlertState("Ocorreu um erro inesperado. Por favor, tente novamente")
            }
        }
    }
    
    //TODO Remove once error interface is refined
    private func enableAlertState(_ message: String) {
        
        let alert = UIAlertController(title: "Juju", message: message, primaryActionTitle: "OK")
        self.present(alert, animated: true)
    }
}
