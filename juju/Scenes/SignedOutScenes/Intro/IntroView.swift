//
//  IntroView.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

import UIKit

final class IntroView: UIView {
    
    private let logoLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Juju"
        label.textColor = Resources.Colors.pink
        label.font = Resources.Fonts.Gilroy.bold(ofSize: 44)
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Bem-vinda a Juju. Escolher um texto bonitinho pra colocar aqui"
        label.textColor = Resources.Colors.white
        label.font = Resources.Fonts.Gilroy.medium(ofSize: 18)
        return label
    }()
    
    private let buttonStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 24
        return stack
    }()
    
    private let signIn = JujuButton(title: "entrar")
    private let signUp = JujuButton(title: "cadastrar", theme: .secondary)
    
    var onSignUpTap: (() -> Void)?
    var onSignInTap: (() -> Void)?
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
    
}

extension IntroView: ViewCoding {
    
    func addSubViews() {
        
        addSubview(logoLabel)
        addSubview(welcomeLabel)
        buttonStack.addArrangedSubview(signIn)
        buttonStack.addArrangedSubview(signUp)
        addSubview(buttonStack)
    }
    
    func setupConstraints() {
        
        buttonStack.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().inset(32)
        }
        
        logoLabel.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).multipliedBy(0.5)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().inset(48)
        }
        
        signIn.snp.makeConstraints { make in
            
            make.width.equalTo(signUp.snp.width)
        }
        
    }
    
    func configureViews() {
        
        self.backgroundColor = Resources.Colors.lightPink
        self.signIn.onTapAction = { self.onSignInTap?() }
        self.signUp.onTapAction = { self.onSignUpTap?() }
    }
    
}
