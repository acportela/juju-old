//
//  Loadable.swift
//  juju
//
//  Created by Antonio Portela on 02/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol Loadable where Self: UIViewController {
    
    var loadingController: LoadingViewController { get }
    
    func startLoading()
    func stopLoading()
}

extension Loadable {
    
    func startLoading() {
        
        add(loadingController)
        view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        
        loadingController.remove()
        view.isUserInteractionEnabled = true
    }
}
