//
//  LoadingViewController.swift
//  juju
//
//  Created by Antonio Portela on 02/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

class LoadingViewController: UIViewController {
    
    let animatable: Animatable
    
    init(animatable: Animatable) {
        
        self.animatable = animatable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.animatable.setup(hostView: self.view)
        self.animatable.start()
    }
}
