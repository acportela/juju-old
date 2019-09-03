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
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Juju"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.bold(ofSize: Styling.FontSize.thirtysix)
        return label
    }()
    
    let emailInput = JujuInputField(inputKind: .email)
    let passwordInput = JujuInputField(inputKind: .password)
    
    var inputs: [JujuInputField] = []
    
    let inputStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twentyfour
        return stack
    }()
    
    private let enterButton = JujuButton(title: "entrar")
    
    var scrollInputStack: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceVertical = false
        scroll.bounces = false
        scroll.isScrollEnabled = false
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.backgroundColor = .clear
        return scroll
    }()
    
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
    
    var onCreateTap: (() -> Void)?

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
        scrollInputStack.addSubview(logoLabel)
        inputStack.addArrangedSubview(emailInput)
        inputStack.addArrangedSubview(passwordInput)
        scrollInputStack.addSubview(inputStack)
        scrollInputStack.addSubview(enterButton)
        scrollInputStack.addSubview(createAccountButton)
        addSubview(scrollInputStack)
    }
    
    func setupConstraints() {
        
        scrollInputStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        inputStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(Styling.Spacing.twentyEight)
            make.right.equalToSuperview().inset(Styling.Spacing.twentyEight)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(inputStack.snp.top)
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
        self.scrollInputStack.backgroundColor = .clear
        self.logoLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        self.backgroundColor = Styling.Colors.softPink
        inputs = [emailInput, passwordInput]
        setupToolbar()
    }
}

extension SignInView {
    
    @objc
    private func createAccountWasPressed() {
        self.onCreateTap?()
    }
}

extension SignInView {
    
    struct Constants {
        
        static let enterButtonWidth = 141
        static let enterButtonHeight = 48
    }
}
