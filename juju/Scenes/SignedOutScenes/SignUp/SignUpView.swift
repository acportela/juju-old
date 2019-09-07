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
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Juju"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Gilroy.bold(ofSize: Styling.FontSize.thirtysix)
        return label
    }()
    
    let nameInput = JujuInputField(inputKind: .name)
    let dateOfBirth = JujuInputField(inputKind: .dateOfBirth)
    let emailInput = JujuInputField(inputKind: .newEmail)
    let passwordInput = JujuInputField(inputKind: .newPassword)
    
    var inputs: [JujuInputField] = []
    
    let inputStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twentyfour
        return stack
    }()
    
    private let bottomBG = UIImageView(image: Resources.Images.bottomBG)
    
    private let signUpButton = JujuButton(title: "entrar")
    private let backButton = JujuUnderlinedButton(title: "Voltar")
    
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
        scrollInputStack.addSubview(logoLabel)
        inputStack.addArrangedSubview(nameInput)
        inputStack.addArrangedSubview(dateOfBirth)
        inputStack.addArrangedSubview(emailInput)
        inputStack.addArrangedSubview(passwordInput)
        scrollInputStack.addSubview(inputStack)
        scrollInputStack.addSubview(signUpButton)
        scrollInputStack.addSubview(backButton)
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
            make.left.equalToSuperview().offset(Styling.Spacing.twentyeight)
            make.right.equalToSuperview().inset(Styling.Spacing.twentyeight)
        }
        
        logoLabel.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(inputStack.snp.top)
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
        
        self.logoLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        self.backgroundColor = Styling.Colors.softPink
        self.scrollInputStack.backgroundColor = .clear
        self.inputs = [nameInput, dateOfBirth, emailInput, passwordInput]
        setupToolbar()
    }
    
}

extension SignUpView {
    
    struct Constants {
        
        static let signUpButtonWidth = 141
        static let signUpButtonHeight = 48
    }
}
