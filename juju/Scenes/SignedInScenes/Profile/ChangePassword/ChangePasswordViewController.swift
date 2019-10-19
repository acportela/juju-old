//
//  ChangePasswordViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol ChangePasswordViewControllerDelegate: AnyObject {
    
    func changePasswordViewControllerDidChangePassword(_ controller: ChangePasswordViewController)
}

final class ChangePasswordViewController: UIViewController, Loadable {
    
    public static let title = "Alterar senha"
    
    let loadingController = LoadingViewController(animatable: JujuLoader())
    private let changePasswordView = ChangePasswordView()
    private let loggerUser: ClientUser
    private let userService: UserServiceProtocol
    
    weak var delegate: ChangePasswordViewControllerDelegate?
    
    init(loggerUser: ClientUser,
         userService: UserServiceProtocol) {
        
        self.loggerUser = loggerUser
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = self.changePasswordView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = ChangePasswordViewController.title
        
        self.changePasswordView.configure(with: .build)
        self.setupCallbacks()
    }
}

extension ChangePasswordViewController {
    
    func setupCallbacks() {
        
        changePasswordView.onDoneAction = { [weak self] in
            
            guard let sSelf = self else { return }
            guard sSelf.changePasswordView.fieldsAreValid,
            let fields = sSelf.passwordFields(),
            fields.first == fields.second else {
                
                sSelf.enableAlertState("As senhas não são iguais. Por favor, tente novamente")
                return
            }
            
            sSelf.updatePasswordWith(fields.first)
        }
    }

    private func passwordFields() -> (first: String, second: String)? {
        
        guard let password = changePasswordView.newPassword.currentValue,
        let confirmPassword = changePasswordView.newPasswordConfirmation.currentValue else {
            
            return nil
        }
        
        return (password, confirmPassword)
    }
    
    
    private func updatePasswordWith(_ newPassword: String) {
        
        self.startLoading()
        
        self.userService.userWantsToChangePassword(newPassword: newPassword) { [weak self] result in
            
            guard let sSelf = self else { return }
            sSelf.stopLoading()
            
            switch result {
            
            case .success:
                
                sSelf.delegate?.changePasswordViewControllerDidChangePassword(sSelf)
                
            case .error(let error):
                
                sSelf.enableAlertState(error.errorMessage)
            }
        }
        
    }
    
    private func enableAlertState(_ message: String) {
        
        Snackbar.showError(message: message, in: self.view)
    }
}
