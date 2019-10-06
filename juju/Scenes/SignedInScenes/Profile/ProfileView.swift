//
//  ProfileView.swift
//  juju
//
//  Created by Antonio Portela on 06/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileView: UIView {
    
    // MARK: Views
    let logout = JujuButton(title: "Sair", theme: .secondary)

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
        self.addSubview(self.logout)
    }
    
    func setupConstraints() {
        
        self.logout.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.veryLightPink
    }
}

extension ProfileView: ViewConfiguration {
    
    enum States {
        case build
    }
    
    func configure(with state: ProfileView.States) {
    
        switch state {
        case .build:
            break
        }
    }
}

extension ProfileView {
    
    struct Constants {
        
        static let buttonWidth = 173
        static let buttonHeight = 48
    }
}

