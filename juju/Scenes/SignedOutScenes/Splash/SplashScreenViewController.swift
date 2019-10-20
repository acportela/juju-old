//
//  SplashScreenViewController.swift
//  juju
//
//  Created by Antonio Portela on 06/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SplashScreenViewControllerDelegate: AnyObject {
    
    func splashScreenViewControllerFailedFetchingUser(_ controller: SplashScreenViewController)
    func splashScreenViewController(_ controller: SplashScreenViewController,
                                    didFetchLocalUser user: ClientUser)
}

final class SplashScreenViewController: UIViewController, Loadable {
    
    let loadingController = LoadingViewController(animatable: JujuLoader())
    private let localStorage: LocalStorageProtocol
    
    weak var delegate: SplashScreenViewControllerDelegate?
    
    init(localStorage: LocalStorageProtocol) {
        
        self.localStorage = localStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = Styling.Colors.white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.startLoading()
    }

    func setupInitialUser() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.stopLoading()
            
            guard let validUser = self.localStorage.get(from: .loggedUser) as ClientUser? else {
                
                self.delegate?.splashScreenViewControllerFailedFetchingUser(self)
                return
            }
            self.delegate?.splashScreenViewController(self, didFetchLocalUser: validUser)
        }
    }
}
