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
        self.title = "Alterar senha"
        self.changePasswordView.configure(with: .build)
    }
}

extension ProfileViewController {
    
    private func proceedWithPasswordChange() {
        
        self.startLoading()
        
        
    }
}
