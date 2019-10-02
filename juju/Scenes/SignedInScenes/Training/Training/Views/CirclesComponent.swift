//
//  CirclesComponent.swift
//  juju
//
//  Created by Antonio Portela on 10/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class CirclesComponent: UIView {
    
    private let circlesImage = UIImageView(image: Resources.Images.circles)
    
    // MARK: Properties
    private var time: Int = 0

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension CirclesComponent: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(circlesImage)
    }
    
    func setupConstraints() {
        
        self.circlesImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.circlesImage.contentMode = .scaleAspectFit
        self.backgroundColor = .clear
    }
}

extension CirclesComponent: ViewConfiguration {
    
    enum States {
        case updateTime(time: Int)
        case startAnimation
        case stopAnimation
        case restart
    }
    
    func configure(with state: CirclesComponent.States) {
        
        switch state {
            
        case .updateTime(let time):
            
            self.time = time
            
        case .startAnimation:
            
            self.animate()
            
        case .stopAnimation:
            
            self.layer.removeAllAnimations()
            self.reset()
            
        case .restart:
            
            self.layer.removeAllAnimations()
            self.reset()
            self.animate()
        }
    }
}

extension CirclesComponent {
    
    private func animate() {
        
        UIView.animate(withDuration: Double(self.time),
                       delay: 0,
                       options: [.curveLinear,
                                 .repeat,
                                 .autoreverse],
                       animations: {

            self.transform = CGAffineTransform(scaleX: Constants.scaleFactor, y: Constants.scaleFactor)

        }, completion: { _ in })
    }
    
    private func reset() {
        
        UIView.animate(withDuration: Constants.resetDuration) {
            
            self.transform = .identity
        }
    }
}

extension CirclesComponent {
    
    struct Constants {
        
        static let scaleFactor: CGFloat = 0.36
        static let resetDuration: Double = 0.1
    }
}
