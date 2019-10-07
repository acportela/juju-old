//
//  ProfileViewController.swift
//  juju
//
//  Created by Antonio Portela on 06/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    
    func profileViewControllerDidLogout(_ controller: ProfileViewController, success: Bool)
}

final class ProfileViewController: UIViewController, Loadable {
    
    let loadingController = LoadingViewController(animatable: JujuLoader())
    private let profileView = ProfileView()
    private let loggerUser: ClientUser
    private let userService: UserServiceProtocol
    private let localStorage: LocalStorageProtocol
    weak var delegate: ProfileViewControllerDelegate?
    
    init(loggerUser: ClientUser,
         userService: UserServiceProtocol,
         localStorage: LocalStorageProtocol) {
        
        self.loggerUser = loggerUser
        self.userService = userService
        self.localStorage = localStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = self.profileView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureLogoutAction()
    }
    
    private func configureLogoutAction() {
        
        self.profileView.logout.onTapAction = { [weak self] in
            
            self?.logout()
        }
    }
}

extension ProfileViewController {
    
    private func logout() {
        
        self.startLoading()
        
        self.userService.userWantsToSignOut { [weak self] result in
            
            self?.stopLoading()
            
            guard let sSelf = self else { return }
            
            switch result {
                
            case .success:
                
                sSelf.delegate?.profileViewControllerDidLogout(sSelf, success: true)
                sSelf.localStorage.remove(valuesForKeys: StorageKeys.allCases)
                
            case .error:
                // TODO: Test for only one possible error: connection
                sSelf.delegate?.profileViewControllerDidLogout(sSelf, success: false)
            }
        }
    }
}
