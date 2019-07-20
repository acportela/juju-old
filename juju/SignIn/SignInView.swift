//
//  SignInView.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class SignInView: UIView {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Juju"
        label.textColor = Resources.Colors.pink
        label.font = Resources.Fonts.Gilroy.bold(ofSize: 44)
        return label
    }()
    
    private let emailInput: JujuInputField = {
        let nameInput = JujuInputField(inputKind: .email)
        return nameInput
    }()
    
    private let passwordInput: JujuInputField = {
        let nameInput = JujuInputField(inputKind: .password)
        return nameInput
    }()
    
    var inputs: [JujuInputField] = []
    
    private let inputStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 32
        return stack
    }()
    
    private let enterButton = JujuButton(title: "entrar")
    
    var onSignInTap: (() -> Void)? {
        didSet {
            enterButton.onTapAction = onSignInTap
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
    
}

extension SignInView: ViewCoding {
    
    func addSubViews() {
        addSubview(logoLabel)
        inputStack.addArrangedSubview(emailInput)
        inputStack.addArrangedSubview(passwordInput)
        addSubview(inputStack)
        addSubview(enterButton)
    }
    
    func setupConstraints() {
        
        inputStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputStack.snp.top).offset(-48)
        }
        
        enterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputStack.snp.bottom).offset(48)
        }
        
    }
    
    func configureViews() {
        
        self.backgroundColor = Resources.Colors.lightPink
        inputs = [emailInput, passwordInput]
    }
    
}
