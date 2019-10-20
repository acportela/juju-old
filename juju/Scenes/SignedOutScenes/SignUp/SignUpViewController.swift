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
    let loadingController = LoadingViewController(animatable: JujuLoader())
    
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
            
            //sSelf.proceedWithSignUp(formUser: user.formUser, password: user.pass)
        }
    }
    
    private func proceedWithSignUp(formUser: ClientUser, password: String) {
        
        self.startLoading()
        self.userService.userWantsToSignUp(clientUser: formUser, password: password) { [weak self] result in
            
            guard let sSelf = self else { return }
            sSelf.stopLoading()
            
            switch result {
                
            case .success(let newUser):
                sSelf.delegate?.signUpViewController(sSelf, didSignUpWithUser: newUser)
            case .error:
                sSelf.enableErrorState("Ocorreu um erro inesperado. Por favor, tente novamente")
            }
        }
    }
    
    private func userFromForm() -> (formUser: ClientUser, pass: String)? {
        
        guard let name = signUpView.nameInput.currentValue,
              let email = signUpView.emailInput.currentValue,
              let pass = signUpView.passwordInput.currentValue,
              let dateString = signUpView.dateOfBirth.currentValue,
            let date = DateUtils().dateFromString(dateString, withFormat: .iso8601UTCBar) else {
                
            return nil
        }
        
        let formUser = ClientUser(userId: .empty, email: email, name: name.capitalized, dob: date)
        return (formUser: formUser, pass: pass)
    }
    
    private func enableErrorState(_ message: String) {
        
        Snackbar.showError(message: message, in: self.view)
    }
}
