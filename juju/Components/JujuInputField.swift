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
        field.font = Resources.Fonts.Montserrat.regular(ofSize: 16)
        field.textColor = Resources.Colors.white
        field.textAlignment = .left
        return field
    }()
    
    private var title: UILabel = {
        let label = UILabel()
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
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    let inputKind: InputKind
    
    init(frame: CGRect = .zero, inputKind: InputKind) {
        self.inputKind = inputKind
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
    
}

extension JujuInputField: ViewCoding {
    
    func addSubViews() {
        containerStack.addArrangedSubview(title)
        containerStack.addArrangedSubview(input)
        containerStack.addArrangedSubview(selectedIndicator)
        addSubview(containerStack)
    }
    
    func setupConstraints() {
        
        containerStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        selectedIndicator.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalToSuperview()
        }
    }
    
    func configureViews() {
        self.title.text = self.inputKind.title
        self.input.text = self.inputKind.hint
        self.input.keyboardType = self.inputKind.keyboard
        self.input.returnKeyType = .done
    }
    
}

extension JujuInputField: ViewConfiguration {
    
    enum States {
        case focused
        case unfocused
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
        var title: String {
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
        
        var hint: String {
            switch self {
            case .name:
                return "Qual seu nome?"
            case .age:
                return "Quantos anos você tem?"
            case .email:
                return "Qual seu email?"
            case .password:
                return "Digite uma nova senha"
            }
        }
        
        var keyboard: UIKeyboardType {
            switch self {
            case .name:
                return .namePhonePad
            case .age:
                return .numberPad
            case .email:
                return .emailAddress
            case .password:
                return .default
            }
        }
    }
    
}
