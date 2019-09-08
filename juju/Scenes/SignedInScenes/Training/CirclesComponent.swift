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
    private var time: Int

    // MARK: Lifecycle
    
//    var scaleUpAnimation: UIViewPropertyAnimator?
//    var scaleDownAnimation: UIViewPropertyAnimator?
//    var currentAnimation: UIViewPropertyAnimator?
    
//    var scaleUp: UIViewPropertyAnimator {
//        let animator = UIViewPropertyAnimator(duration: Double(self.time), curve: .linear) {
//            self.transform = .identity
//        }
//        animator.addCompletion { state in
//            if state == .end {
//                self.scaleDown.startAnimation()
//            }
//        }
//        return animator
//    }
//
//    var scaleDown: UIViewPropertyAnimator {
//        let animator = UIViewPropertyAnimator(duration: Double(self.time), curve: .linear) {
//            self.transform = CGAffineTransform(scaleX: Constants.scaleFactor, y: Constants.scaleFactor)
//        }
//        animator.addCompletion { state in
//            if state == .end {
//                self.scaleUp.startAnimation()
//            }
//        }
//        return animator
//    }
    
    init(time: Int, frame: CGRect = .zero) {
        
        self.time = time
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
        }
    }
}

extension CirclesComponent {
    
//    enum ScaleType {
//    case upp
//    case down
//    }
//
//    private func buildAnimation(scale: ScaleType) -> UIViewPropertyAnimator {
//
//        let animator = UIViewPropertyAnimator(duration: Double(self.time), curve: .linear) {
//
//            self.transform = scale == .upp ? .identity
//                                            : CGAffineTransform(scaleX: Constants.scaleFactor,
//                                                                y: Constants.scaleFactor)
//        }
//
//        animator.addCompletion { state in
//
//            if state == .end {
//
//                let nextAnimation = scale == .upp  ? self.scaleDownAnimation
//                                                    : self.scaleUpAnimation
//                nextAnimation?.startAnimation()
//
//                self.currentAnimation = nextAnimation
//            }
//        }
//
//        return animator
//    }
    
    private func animate() {
        
//        if currentAnimation == nil {
//
//            self.scaleUpAnimation = self.buildAnimation(scale: .upp)
//            self.scaleDownAnimation = self.buildAnimation(scale: .down)
//            self.currentAnimation = self.scaleDownAnimation
//            self.currentAnimation?.startAnimation()
//
//        } else {
//
//            self.currentAnimation?.startAnimation()
//        }
        
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
        
        static let scaleFactor: CGFloat = 0.4
        static let resetDuration: Double = 0.5
    }
}
