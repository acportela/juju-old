//
//  NumberedCircle.swift
//  juju
//
//  Created by Antonio Portela on 08/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class NumberedCircle: UIView {
    
    // MARK: Views
    private let number: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.extraBold(ofSize: Styling.FontSize.sixty)
        return label
    }()
    
    // MARK: Properties
    private var circleShape: CAShapeLayer?
    
    private let radius: Float
    
    // MARK: Lifecycle
    init(radius: Float) {
        
        self.radius = radius
        super.init(frame: .zero)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension NumberedCircle: ViewCoding {
    
    func addSubViews() {
        self.addSubview(number)
    }
    
    func setupConstraints() {
        
        self.number.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = .clear
    }
}

extension NumberedCircle {
    
    private func configureShapeWith(color: UIColor) {
        
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let shape = CAShapeLayer(center: center,
                                 radius: self.radius,
                                 fillColor: color)

        self.circleShape = shape
        self.layer.addSublayer(shape)
    }
}

extension NumberedCircle: ViewConfiguration {
    
    enum States {
        case build(number: Int?, color: UIColor)
        case updateNumber(Int)
    }
    
    func configure(with state: NumberedCircle.States) {
        
        switch state {
        case .build(let number, let color):
            
            if self.circleShape == nil {
                
                self.configureShapeWith(color: color)
            }
        
            if let number = number {
                
                self.number.text = String(number)
            } else {
                
                self.number.text = ""
            }
            
        case .updateNumber(let number):
            
            self.number.text = String(number)
        }
    }
}
