//
//  SpinnerLoader.swift
//  juju
//
//  Created by Antonio Portela on 15/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

struct SpinnerLoader: Animatable {
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    func setup(hostView: UIView) {
        
        hostView.backgroundColor = Styling.Colors.charcoalGrey.withAlphaComponent(0.7)
        hostView.addSubview(self.spinner)
        
        self.spinner.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
    }
    
    func start() {
        
        self.spinner.startAnimating()
    }
    
    func stop() {
        
        self.spinner.stopAnimating()
    }
}
