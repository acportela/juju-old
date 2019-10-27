//
//  ProfileFooterView.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol ProfileFooterViewDelegate: AnyObject {
    
    func profileFooterViewDidTapChangePassword(_ profileView: ProfileFooterView)
    func profileFooterViewDidTapLogout(_ profileView: ProfileFooterView)
}

final class ProfileFooterView: UIView {
    
    // MARK: Views
    private let configLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Configurações"
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let changePasswordButton = JujuUnderlinedButton()
    private let logoutButton = JujuUnderlinedButton()
    
    weak var delegate: ProfileFooterViewDelegate?
    
    private let lockImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.lockIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let exitImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.exitIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let changePasswordStack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = Styling.Spacing.twentyfour
        return stack
    }()
    
    // MARK: Properties
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension ProfileFooterView: ViewCoding {
    
    func addSubViews() {
        
        self.changePasswordStack.addArrangedSubview(self.lockImage)
        self.changePasswordStack.addArrangedSubview(self.changePasswordButton)
        
        self.addSubview(self.configLabel)
        self.addSubview(self.changePasswordStack)
        
        //self.addSubview(self.outterStack)
        self.addSubview(self.exitImage)
        self.addSubview(self.logoutButton)
    }
    
    func setupConstraints() {
        
        self.configLabel.snp.makeConstraints { make in
            
            make.left.equalTo(self.lockImage.snp.left)
            make.bottom.equalTo(self.lockImage.snp.top).offset(-Styling.Spacing.twentyfour)
        }
        
        self.changePasswordStack.snp.makeConstraints { make in
            
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Styling.Spacing.twentyfour)
        }

        self.logoutButton.snp.makeConstraints { make in
        
            make.left.equalTo(self.changePasswordButton.snp.left)
            make.top.equalTo(self.changePasswordButton.snp.bottom).offset(Styling.Spacing.twelve)
        }
        
        self.exitImage.snp.makeConstraints { make in
        
            make.bottom.equalTo(self.logoutButton.snp.bottom).offset(-Styling.Spacing.eight)
            make.left.equalTo(self.lockImage.snp.left)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.veryLightPink
        
        let changePasswordConfig = JujuUnderlinedButtonConfiguration(title: "Alterar senha",
                                                                     font: Resources.Fonts.Rubik.regular(ofSize: 14),
                                                                     color: Styling.Colors.duskyRose,
                                                                     lowercased: false)
        self.changePasswordButton.configure(with: .build(changePasswordConfig))
        self.changePasswordButton.onTapAction = { self.didTapChangePassword() }
        
        let logoutConfig = JujuUnderlinedButtonConfiguration(title: "Sair da conta",
                                                             font: Resources.Fonts.Rubik.regular(ofSize: 14),
                                                             color: Styling.Colors.duskyRose,
                                                             lowercased: false)
        
        self.logoutButton.configure(with: .build(logoutConfig))
        self.logoutButton.onTapAction = { self.didTapLogout() }
    }
}

extension ProfileFooterView {
    
    @objc
    private func didTapChangePassword() {
        
        self.delegate?.profileFooterViewDidTapChangePassword(self)
    }
    
    @objc
    private func didTapLogout() {
        
        self.delegate?.profileFooterViewDidTapLogout(self)
    }
}
