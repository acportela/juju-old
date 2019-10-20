//
//  SignUpView.swift
//  juju
//
//  Created by Antonio Rodrigues on 03/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class SignUpView: UIView, JujuFormProtocol {
    
    private let logo: UIImageView = {
        
        let imageView = UIImageView(image: Resources.Images.signInLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameInput = JujuInputField(inputKind: .name, background: .dark)
    let dateOfBirth = JujuInputField(inputKind: .dateOfBirth, background: .dark)
    let emailInput = JujuInputField(inputKind: .newEmail, background: .dark)
    let passwordInput = JujuInputField(inputKind: .newPassword, background: .dark)
    
    var inputs: [JujuInputField] = []
    
    let inputStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twentyeight
        return stack
    }()
    
    private let bottomBG = UIImageView(image: Resources.Images.bottomBG)
    
    private let signUpButton = JujuButton(title: "entrar", backgroundContext: .dark)
    private let backButton = JujuUnderlinedButton()
    
    var onDoneAction: (() -> Void)? {
        didSet {
            signUpButton.onTapAction = onDoneAction
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

extension SignUpView: ViewCoding {
    
    func addSubViews() {
        
        addSubview(bottomBG)
        addSubview(self.logo)
        inputStack.addArrangedSubview(nameInput)
        inputStack.addArrangedSubview(dateOfBirth)
        inputStack.addArrangedSubview(emailInput)
        inputStack.addArrangedSubview(passwordInput)
        addSubview(inputStack)
        addSubview(signUpButton)
        addSubview(backButton)
    }
    
    func setupConstraints() {
        
        inputStack.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(Styling.Spacing.twentyeight)
            make.right.equalToSuperview().inset(Styling.Spacing.twentyeight)
        }
        
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(inputStack.snp.top)
            make.width.equalTo(Constants.logoWidth)
        }
        
        signUpButton.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.signUpButtonWidth)
            make.height.equalTo(Constants.signUpButtonHeight)
            make.top.lessThanOrEqualTo(inputStack.snp.bottom).offset(Styling.Spacing.thirtytwo)
        }
        
        backButton.snp.makeConstraints { make in
            
            make.centerX.equalTo(signUpButton.snp.centerX)
            make.top.equalTo(signUpButton.snp.bottom).offset(Styling.Spacing.eight)
        }
        
        bottomBG.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.softPink
        self.inputs = [nameInput, dateOfBirth, emailInput, passwordInput]
        setupToolbar()
        
        let font = Resources.Fonts.Gilroy.extraBold(ofSize: Styling.FontSize.twenty)
        let color = Styling.Colors.veryLightPink
        let jujuUnderlinedConfig = JujuUnderlinedButtonConfiguration(title: "Voltar",
                                                                     font: font,
                                                                     color: color,
                                                                     lowercased: true)
        self.backButton.configure(with: .build(jujuUnderlinedConfig))
    }
    
}

extension SignUpView {
    
    struct Constants {
        
        static let signUpButtonWidth = 141
        static let signUpButtonHeight = 48
        static let logoWidth = 83
        static let logoHeight = 71
    }
}
