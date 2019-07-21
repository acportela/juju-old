//
//  SignInView.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class SignInView: UIView, JujuFormProtocol {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Juju"
        label.textColor = Resources.Colors.pink
        label.font = Resources.Fonts.Gilroy.bold(ofSize: 48)
        return label
    }()
    
    private let emailInput = JujuInputField(inputKind: .email)
    private let passwordInput = JujuInputField(inputKind: .password)
    
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
    private let backButton = JujuUnderlinedButton(title: "voltar")
    
    var onDoneAction: (() -> Void)? {
        didSet {
            enterButton.onTapAction = onDoneAction
        }
    }
    
    var onBackTap: (() -> Void)? {
        didSet {
            backButton.onTapAction = onBackTap
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
        addSubview(backButton)
    }
    
    func setupConstraints() {
        
        inputStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputStack.snp.top).offset(-56)
        }
        
        enterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputStack.snp.bottom).offset(56)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerX.equalTo(enterButton.snp.centerX)
            make.top.equalTo(enterButton.snp.bottom).offset(24)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Resources.Colors.lightPink
        inputs = [emailInput, passwordInput]
        setupToolbar()
    }
}
