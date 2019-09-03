//
//  SignUpViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 09/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    
    func signUpViewController(_ viewController: SignUpViewController, didSignUpWithUser user: ClientUser)
    func signUpViewControllerDidTapBack(_ viewController: SignUpViewController)
}

final class SignUpViewController: UIViewController, Loadable {
    
    private let signUpView = SignUpView()
    private let userService: UserService
    let loadingController = LoadingViewController()
    
    weak var delegate: SignUpViewControllerDelegate?
    
    init(userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = signUpView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardListener.shared.register(signUpView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        KeyboardListener.shared.remove(signUpView)
        super.viewWillDisappear(animated)
    }
    
    private func setupCallbacks() {
        
        signUpView.onBackTap = { [weak self] in
            
            guard let sSelf = self else { return }
            sSelf.delegate?.signUpViewControllerDidTapBack(sSelf)
        }
        
        signUpView.onDoneAction = { [weak self] in
            
            guard let sSelf = self else { return }
            guard sSelf.signUpView.fieldsAreValid, let user = sSelf.userFromForm() else {
                sSelf.enableErrorState("Verifique os campos e tente novamente")
                return
            }
            
            sSelf.proceedWithSignUp(user: user.user, password: user.pass)
        }
    }
    
    private func proceedWithSignUp(user: ClientUser, password: String) {
        
        self.startLoading()
        self.userService.userWantsToSignUp(clientUser: user, password: password) { [weak self] result in
            
            guard let sSelf = self else { return }
            sSelf.stopLoading()
            
            switch result {
                
            case .success:
                sSelf.delegate?.signUpViewController(sSelf, didSignUpWithUser: user)
            case .error:
                sSelf.enableErrorState("Ocorreu um erro inesperado. Por favor, tente novamente")
            }
        }
    }
    
    private func userFromForm() -> (user: ClientUser, pass: String)? {
        
        guard let name = signUpView.nameInput.currentValue,
              let email = signUpView.emailInput.currentValue,
              let pass = signUpView.passwordInput.currentValue,
              let dateString = signUpView.dateOfBirth.currentValue,
              let date = DateUtils().dateFromString(dateString) else {
                
            return nil
        }
        
        let user = ClientUser(email: email, name: name.uppercased(), dob: date)
        return (user: user, pass: pass)
    }
    
    private func enableErrorState(_ message: String) {
        let alert = UIAlertController(title: "Juju", message: message, primaryActionTitle: "OK")
        self.present(alert, animated: true)
    }
}
