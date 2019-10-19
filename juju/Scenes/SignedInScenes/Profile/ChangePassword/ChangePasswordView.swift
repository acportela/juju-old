//
//  ChangePasswordView.swift
//  juju
//
//  Created by Antonio Rodrigues on 18/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class ChangePasswordView: UIView, JujuFormProtocol {
    
    // MARK: Views
    
    private let headerView = FormHeaderView()
    
    private let changeButton = JujuButton(title: "Atualizar", background: .light)
    
    let newPassword = JujuInputField(inputKind: .newPassword,
                                     background: .light)
    let newPasswordConfirmation = JujuInputField(inputKind: .newPassword,
                                                 background: .light)
    
    let inputStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twentyfour
        return stack
    }()
    
    // MARK: Properties

    var inputs: [JujuInputField] = []
    
    var onDoneAction: (() -> Void)? {
        didSet {
            changeButton.onTapAction = onDoneAction
        }
    }
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension ChangePasswordView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(self.headerView)
        inputStack.addArrangedSubview(self.newPassword)
        inputStack.addArrangedSubview(self.newPasswordConfirmation)
        addSubview(self.inputStack)
        addSubview(self.changeButton)
    }
    
    func setupConstraints() {
        
        self.headerView.snp.makeConstraints { make in
            
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.thirtytwo)
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left).offset(Styling.Spacing.twentyeight)
        }

        self.inputStack.snp.makeConstraints { make in
            
            make.top.equalTo(self.headerView.snp.bottom).offset(Styling.Spacing.thirtytwo)
            make.left.equalToSuperview().offset(Styling.Spacing.twentyeight)
            make.right.equalToSuperview().inset(Styling.Spacing.twentyeight)
        }
        
        self.changeButton.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
            make.top.lessThanOrEqualTo(inputStack.snp.bottom).offset(Styling.Spacing.fourtyeight)
        }
    }
    
    func configureViews() {

        self.backgroundColor = Styling.Colors.white
        inputs = [self.newPassword, self.newPasswordConfirmation]
        setupToolbar(nextText: "Próximo", doneText: "Confirmar")
    }
}

extension ChangePasswordView: ViewConfiguration {
    
    enum States {
        
        case build
    }
    
    func configure(with state: ChangePasswordView.States) {
    
        switch state {
            
        case .build:
            
            let headerTitle = "Definir nova senha"
            let headerSubtitle = "Sua senha deve conter no mínimo 6 caracteres"
            let headerConfig = FormHeaderViewConfiguration(title: headerTitle,
                                                           subtitle: headerSubtitle,
                                                           background: .light)
            self.headerView.configure(with: .build(headerConfig))
            
        }
    }
}

extension ChangePasswordView {
    
    struct Constants {
        
        static let buttonWidth = 176
        static let buttonHeight = 48
    }
}
