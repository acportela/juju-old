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

final class SignUpViewController: SignedOutThemeViewController {
    
    private let signUpView = SignUpView()
    private let userService: UserService
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
        super.viewWillDisappear(animated)
        KeyboardListener.shared.remove(signUpView)
    }
    
    func setupCallbacks() {
        
        signUpView.onBackTap = { [weak self] in
            
            guard let sSelf = self else { return }
            sSelf.delegate?.signUpViewControllerDidTapBack(sSelf)
        }
        
        signUpView.onDoneAction = { [weak self] in
            
            guard let sSelf = self else { return }
            sSelf.fieldsAreValid() ? sSelf.proceedWithSignUp() : sSelf.enableErrorState()
        }
    }
    
    func fieldsAreValid() -> Bool {
        
        return true
    }
    
    func proceedWithSignUp() {
        
        let testUser = ClientUser(email: "testapp1@gmail.com", name: "TestUserApp", dob: Date())
        
        userService.userWantsToSignUp(clientUser: testUser, password: "123456") { result in
            switch result {
            case .success:
                self.delegate?.signUpViewController(self, didSignUpWithUser: testUser)
            case .error:
                //TODO Add treatment
                break
            }
        }
        
    }
    
    func enableErrorState() {
        
    }
}
