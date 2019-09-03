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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.startAnimating()
        
        view.addSubview(spinner)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
