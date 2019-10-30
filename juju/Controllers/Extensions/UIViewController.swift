//
//  UIViewController+Extension.swift
//  juju
//
//  Created by Antonio Portela on 02/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        view.addSubview(child.view)
        addChild(child)
        child.didMove(toParent: self)
        child.view.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    func remove() {
        
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
