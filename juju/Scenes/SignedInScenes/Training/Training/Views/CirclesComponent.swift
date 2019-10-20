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
    private var inTime: Double = 0
    private var outTime: Double = 0
    
    private var isAnimating = false {
        didSet {
            self.isAnimating ? self.transformIn(self.inTime) : self.reset()
        }
    }

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

// MARK: States
extension CirclesComponent: ViewConfiguration {
    
    enum States {
        
        case setTime(inTime: Int, outTime: Int)
        case startAnimation
        case stopAnimation
    }
    
    func configure(with state: CirclesComponent.States) {
        
        switch state {
            
        case .setTime(let inTime, let outTime):
            
            self.inTime = Double(inTime)
            self.outTime = Double(outTime)
            
        case .startAnimation:
            
            self.isAnimating = true
            
        case .stopAnimation:
            
            self.isAnimating = false
        }
    }
}

// MARK: Animation functions
extension CirclesComponent {
    
    private func transformIn(_ time: Double) {
        
        UIView.animate(withDuration: time,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {

            self.transform = CGAffineTransform(scaleX: Constants.scaleFactor, y: Constants.scaleFactor)

        }, completion: { _ in
            
            if self.isAnimating { self.transformOut(self.outTime) }
        })
        
    }
    
    private func transformOut(_ time: Double) {
        
        UIView.animate(withDuration: time,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {

                        self.transform = .identity

        }, completion: { _ in
            
            if self.isAnimating { self.transformIn(self.inTime) }
        })
    }
    
    private func reset() {
        
        self.layer.removeAllAnimations()
        
        UIView.animate(withDuration: Constants.resetDuration) {
            
            self.transform = .identity
        }
    }
    
    // Kept as precaution, shouldn't be needed anymore
    private func animate(inOutEqualTime time: Double) {
        
        UIView.animate(withDuration: Double(time),
                       delay: 0,
                       options: [.curveLinear,
                                 .repeat,
                                 .autoreverse],
                       animations: {

            self.transform = CGAffineTransform(scaleX: Constants.scaleFactor,
                                               y: Constants.scaleFactor)

        }, completion: { _ in })
    }
}

// MARK: Constants
extension CirclesComponent {
    
    struct Constants {
        
        static let scaleFactor: CGFloat = 0.36
        static let resetDuration: Double = 0.1
    }
}
