//
//  JujuInputField.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class JujuInputField: UIView {
    
    private let input: UITextField = {
        let field = UITextField()
        field.text = ""
        field.font = Resources.Fonts.Montserrat.regular(ofSize: 16)
        return field
    }()
    
    private let hint: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let selectedIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.pink
        return view
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
}

extension JujuInputField: ViewCoding {
    
    func addSubViews() {
        containerStack.addArrangedSubview(hint)
        containerStack.addArrangedSubview(input)
        containerStack.addArrangedSubview(selectedIndicator)
        addSubview(containerStack)
    }
    
    func setupConstraints() {
        
        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectedIndicator.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }
    
    func configureViews() {
        
    }
    
}

extension JujuInputField: ViewConfiguration {
    
    enum States {
        case focused
        case unfocused
    }
    
    func configure(with: JujuInputField.States) {
        
    }

}

extension JujuInputField {
    
    enum FocusState {
        
    }
}
