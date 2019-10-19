//
//  SignInView.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class SignInView: UIView, JujuFormProtocol {
    
    private let logo: UIImageView = {
        
        let imageView = UIImageView(image: Resources.Images.signInLogo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emailInput = JujuInputField(inputKind: .email, background: .dark)
    let passwordInput = JujuInputField(inputKind: .password, background: .dark)
    
    var inputs: [JujuInputField] = []
    
    let inputStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twentyeight
        return stack
    }()
    
    private let enterButton = JujuButton(title: "entrar", background: .dark)
    
    private let bottomBG = UIImageView(image: Resources.Images.bottomBG)
    
    private let createAccountButton: UIButton = {
        
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: Styling.Spacing.twelve,
                                                left: 0,
                                                bottom: Styling.Spacing.twelve,
                                                right: 0)
        button.addTarget(self, action: #selector(createAccountWasPressed), for: .touchUpInside)
        button.setPartuallyUnderlined(title: "Ainda não possui uma conta? Criar agora",
                                      term: "Criar agora",
                                      color: Styling.Colors.veryLightPink,
                                      regularFont: Resources.Fonts.Gilroy.regular(ofSize: Styling.FontSize.sixteen),
                                      underlinedFont: Resources.Fonts.Gilroy
                                                                     .extraBold(ofSize: Styling.FontSize.sixteen))
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.8
        return button
    }()
    
    var onDoneAction: (() -> Void)? {
        didSet {
            enterButton.onTapAction = onDoneAction
        }
    }
    
    var onCreateAccountTap: (() -> Void)?

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
        
        addSubview(bottomBG)
        addSubview(self.logo)
        inputStack.addArrangedSubview(emailInput)
        inputStack.addArrangedSubview(passwordInput)
        addSubview(inputStack)
        addSubview(enterButton)
        addSubview(createAccountButton)
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
        
        enterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.enterButtonWidth)
            make.height.equalTo(Constants.enterButtonHeight)
            make.top.lessThanOrEqualTo(inputStack.snp.bottom).offset(Styling.Spacing.fourtyeight)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.right.equalToSuperview().inset(Styling.Spacing.sixteen)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(Styling.Spacing.twentyfour)
        }
        
        bottomBG.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func configureViews() {

        self.backgroundColor = Styling.Colors.softPink
        inputs = [emailInput, passwordInput]
        setupToolbar(nextText: "Próximo", doneText: "Entrar")
    }
}

extension SignInView {
    
    @objc
    private func createAccountWasPressed() {
        self.onCreateAccountTap?()
    }
}

extension SignInView {
    
    struct Constants {
        
        static let enterButtonWidth = 141
        static let enterButtonHeight = 48
        static let logoWidth = 83
        static let logoHeight = 71
    }
}
