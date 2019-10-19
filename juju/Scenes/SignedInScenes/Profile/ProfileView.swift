//
//  ProfileView.swift
//  juju
//
//  Created by Antonio Portela on 06/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    
    func profileViewDidTapChangePassword(_ profileView: ProfileView)
    func profileViewDidTapLogout(_ profileView: ProfileView)
}

final class ProfileView: UIView {
    
    // MARK: Views

    private let profileImage: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = Resources.Images.profileFullIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Gilroy.medium(ofSize: Styling.FontSize.twenty)
        return label
    }()
    
    private let emailLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Gilroy.regular(ofSize: Styling.FontSize.sixteen)
        return label
    }()
    
    private let footerView = ProfileFooterView()
    
    weak var delegate: ProfileViewDelegate?
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
}

extension ProfileView: ViewCoding {
    
    func addSubViews() {

        self.addSubview(self.footerView)
        self.addSubview(self.profileImage)
        self.addSubview(self.nameLabel)
        self.addSubview(self.emailLabel)
    }
    
    func setupConstraints() {
        
        self.profileImage.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.profileViewSides)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(Styling.Spacing.fourtyeight)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(self.profileImage.snp.bottom).offset(Styling.Spacing.twentyfour)
        }
        
        self.emailLabel.snp.makeConstraints { make in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Styling.Spacing.sixteen)
        }
        
        self.footerView.snp.makeConstraints { make in
            
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(Constants.footerHeight)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.white
        self.footerView.delegate = self
    }
}

extension ProfileView: ViewConfiguration {
    
    enum States {
        
        case build(name: String, email: String)
    }
    
    func configure(with state: ProfileView.States) {
    
        switch state {
            
        case .build(let name, let email):
            
            self.nameLabel.text = name.capitalized
            self.emailLabel.text = email
        }
    }
}

extension ProfileView {
    
    struct Constants {
        
        static let profileViewSides = 120
        static let footerHeight = 170
    }
}

extension ProfileView: ProfileFooterViewDelegate {
    
    func profileFooterViewDidTapChangePassword(_ profileView: ProfileFooterView) {
        
        self.delegate?.profileViewDidTapChangePassword(self)
    }
    
    func profileFooterViewDidTapLogout(_ profileView: ProfileFooterView) {
        
        self.delegate?.profileViewDidTapLogout(self)
    }
}
