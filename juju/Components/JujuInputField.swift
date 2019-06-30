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
        field.textColor = Resources.Colors.white
        field.textAlignment = .left
        return field
    }()
    
    private lazy var hint: UILabel = {
        let label = UILabel()
        label.text = self.inputKind.hint
        label.font = Resources.Fonts.Montserrat.regular(ofSize: 14)
        label.textAlignment = .left
        label.textColor = Resources.Colors.white
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
    
    let inputKind: InputKind
    
    init(frame: CGRect = .zero, inputKind: InputKind, initialState: States) {
        self.inputKind = inputKind
        super.init(frame: frame)
        configure(with: initialState)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
    
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
        
        var stateColor: UIColor {
            switch self {
            case .focused:
                return Resources.Colors.white
            case .unfocused:
                return Resources.Colors.pink
            }
        }
        
    }
    
    func configure(with state: JujuInputField.States) {
        switch state {
        case .focused:
            self.selectedIndicator.backgroundColor = Resources.Colors.white
        case .unfocused:
            self.selectedIndicator.backgroundColor = Resources.Colors.pink
        }
    }

}

extension JujuInputField {
    
    enum InputKind {
        
        case name
        case age
        case email
        case password
        
        //TODO: Localization
        var hint: String {
            switch self {
            case .name:
                return "Nome"
            case .age:
                return "Idade"
            case .email:
                return "Email"
            case .password:
                return "Senha"
            }
        }
    }
    
}
