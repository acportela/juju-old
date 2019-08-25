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
    
    let background: UIImageView = {
        let image = UIImageView(image: Resources.Images.signedOutBG)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
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
        
        addSubview(background)
        scrollInputStack.addSubview(logoLabel)
        inputStack.addArrangedSubview(emailInput)
        inputStack.addArrangedSubview(passwordInput)
        scrollInputStack.addSubview(inputStack)
        scrollInputStack.addSubview(enterButton)
        scrollInputStack.addSubview(backButton)
        addSubview(scrollInputStack)
    }
    
    func setupConstraints() {
        
        scrollInputStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        backButton.snp.makeConstraints { make in
            make.centerX.equalTo(enterButton.snp.centerX)
            make.top.equalTo(enterButton.snp.bottom).offset(Styling.Spacing.eight)
        }
        
        background.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
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
    
    struct Constants {
        
        static let enterButtonWidth = 141
        static let enterButtonHeight = 48
    }
}
