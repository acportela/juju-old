//
//  SignUpView.swift
//  juju
//
//  Created by Antonio Rodrigues on 03/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class SignUpView: UIView {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "JUJU"
        label.textColor = Resources.Colors.pink
        label.font = Resources.Fonts.Montserrat.bold(ofSize: 24)
        return label
    }()
    
    private let nameInput: JujuInputField = {
        let nameInput = JujuInputField(inputKind: .name)
        nameInput.configure(with: .focused)
        return nameInput
    }()
    
    private let ageInput: JujuInputField = {
        let nameInput = JujuInputField(inputKind: .name)
        return nameInput
    }()
    
    private let emailInput: JujuInputField = {
        let nameInput = JujuInputField(inputKind: .name)
        nameInput.configure(with: .focused)
        return nameInput
    }()
    
    private let passwordInput: JujuInputField = {
        let nameInput = JujuInputField(inputKind: .name)
        nameInput.configure(with: .focused)
        return nameInput
    }()
    
    private let inputStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let enterButton = JujuButton(title: "entrar")
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
    
}

extension SignUpView: ViewCoding {
    
    func addSubViews() {
        addSubview(logoLabel)
        inputStack.addArrangedSubview(nameInput)
        inputStack.addArrangedSubview(ageInput)
        inputStack.addArrangedSubview(emailInput)
        inputStack.addArrangedSubview(passwordInput)
        addSubview(inputStack)
        addSubview(enterButton)
    }
    
    func setupConstraints() {
        
        inputStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputStack.snp.top).inset(48)
        }
        
        enterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputStack.snp.bottom).offset(48)
        }
        
    }
    
    func configureViews() {
        self.backgroundColor = Resources.Colors.lightPink
    }
    
}
