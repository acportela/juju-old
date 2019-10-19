//
//  FormHeaderView.swift
//  juju
//
//  Created by Antonio Rodrigues on 19/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

struct FormHeaderViewConfiguration {
    
    let title: String
    let subtitle: String
    let background: FormHeaderView.Background
}

final class FormHeaderView: UIView {
    
    // MARK: Views
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.twenty)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Styling.Colors.charcoalGrey
        label.numberOfLines = 0
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.twelve)
        return label
    }()
    
    private let containerStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.ten
        return stack
    }()
    
    
    // MARK: Properties
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension FormHeaderView: ViewCoding {
    
    func addSubViews() {
        
        self.containerStack.addArrangedSubview(self.titleLabel)
        self.containerStack.addArrangedSubview(self.subtitleLabel)
        self.addSubview(self.containerStack)
    }
    
    func setupConstraints() {
        
        self.containerStack.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
    }
    
    func configureViews() {

        self.backgroundColor = .clear
    }
}

extension FormHeaderView: ViewConfiguration {
    
    enum States {
        
        case build(FormHeaderViewConfiguration)
    }
    
    func configure(with state: FormHeaderView.States) {
    
        switch state {
            
        case .build(let config):
            
            self.titleLabel.text = config.title
            self.titleLabel.textColor = config.background.textColor
            
            self.subtitleLabel.text = config.subtitle
            self.subtitleLabel.textColor = config.background.textColor
        }
    }
}

extension FormHeaderView {
    
    enum Background {
        
        case light
        case dark
        
        var textColor: UIColor {
            
            switch self {
                
            case .light:
                
                return Styling.Colors.charcoalGrey
                
            case .dark:
                
                return Styling.Colors.veryLightPink
            }
        }
    }
    
    struct Constants {
        
    }
}
