//
//  JujuLoader.swift
//  juju
//
//  Created by Antonio Portela on 15/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import Lottie

struct JujuLoader: Animatable {
    
    let animationView = AnimationView(name: "loading2x")
    
    func setup(hostView: UIView) {
        
        hostView.backgroundColor = Styling.Colors.white
        hostView.addSubview(self.animationView)
        
        self.animationView.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        self.animationView.animationSpeed = 2
        self.animationView.loopMode = .loop
    }
    
    func start() {
        
        self.animationView.play()
    }
    
    func stop() {
        
        self.animationView.stop()
    }
}
