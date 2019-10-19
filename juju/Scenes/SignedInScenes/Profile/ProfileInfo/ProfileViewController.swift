//
//  ProfileViewController.swift
//  juju
//
//  Created by Antonio Portela on 06/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    
    func profileViewControllerDidLogout(_ controller: ProfileViewController)
    func profileViewControllerWantsToChangePassword(_ controller: ProfileViewController)
}

final class ProfileViewController: UIViewController, Loadable {
    
    public static let title = "Perfil"
    
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
        self.profileView.configure(with: .build(name: self.loggerUser.name,
                                                email: self.loggerUser.email))
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = ProfileViewController.title
        self.profileView.delegate = self
    }
}

extension ProfileViewController {
    
    private func logout() {
        
        self.startLoading()
        
        self.userService.userWantsToSignOut { [weak self] result in
        
            guard let sSelf = self else { return }
            
            sSelf.stopLoading()

            switch result {
                
            case .success:
                
                sSelf.delegate?.profileViewControllerDidLogout(sSelf)
                sSelf.localStorage.remove(valuesForKeys: StorageKeys.allCases)
                
            case .error:

                Snackbar.showError(message: "Houve um problema ao sair. Por favor, tente novamente",
                                   in: sSelf.view)
            }
        }
    }
}

extension ProfileViewController: ProfileViewDelegate {
    
    func profileViewDidTapChangePassword(_ profileView: ProfileView) {
        
        self.delegate?.profileViewControllerWantsToChangePassword(self)
    }
    
    func profileViewDidTapLogout(_ profileView: ProfileView) {
        
        self.logout()
    }
}
