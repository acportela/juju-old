//
//  IntroView.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class IntroView: UIView {
    
    private let logoLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Juju"
        label.textColor = Styling.Colors.rosyPink
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.thirtysix)
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = Constants.numberOfLines
        label.text = "Bem-vinda a Juju!\n\nSou um aplicativo que vai ajudar você a realizar exercícios pélvicos."
        label.textColor = Styling.Colors.veryLightPink
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.eighteen)
        return label
    }()
    
    private let buttonStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = Styling.Spacing.eight
        return stack
    }()
    
    private let signIn = JujuButton(title: "entrar", backgroundContext: .dark)
    private let signUp = JujuButton(title: "cadastrar", backgroundContext: .light)
    
    let background: UIImageView = {
        let image = UIImageView(image: Resources.Images.bottomBG)
        image.contentMode = .scaleAspectFill
        return image
    }()
    
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
        
        addSubview(background)
        addSubview(logoLabel)
        addSubview(welcomeLabel)
        buttonStack.addArrangedSubview(signIn)
        buttonStack.addArrangedSubview(signUp)
        addSubview(buttonStack)
    }
    
    func setupConstraints() {
        
        buttonStack.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.stackHeight)
            make.width.equalTo(Constants.stackWidth)
            make.top.equalTo(self.welcomeLabel.snp.centerY).multipliedBy(1.3)
        }
        
        logoLabel.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.welcomeLabel.snp.top)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(Styling.Spacing.twentyeight)
            make.right.equalToSuperview().inset(Styling.Spacing.twentyeight)
        }
        
        signIn.snp.makeConstraints { make in
            
            make.width.equalTo(signUp.snp.width)
        }
        
        background.snp.makeConstraints { make in
            
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.softPink
        self.signIn.onTapAction = { self.onSignInTap?() }
        self.signUp.onTapAction = { self.onSignUpTap?() }
    }
    
}

extension IntroView {
    
    struct Constants {
        
        static let numberOfLines = 0
        static let stackHeight = 104
        static let stackWidth = 145
    }
}
