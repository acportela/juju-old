//
//  JujuButton.swift
//  juju
//
//  Created by Antonio Rodrigues on 01/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class JujuButton: UIView {
    
    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Resources.Fonts.Gilroy.bold(ofSize: 16)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    var onTapAction: (() -> Void)?
    
    var theme: Theme
    
    init(title: String, theme: Theme = .primary) {
        
        self.theme = theme
        super.init(frame: .zero)
        
        button.setTitle(title.uppercased(), for: .normal)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
    
}

extension JujuButton: ViewCoding {
    
    func addSubViews() {
        addSubview(button)
    }
    
    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() {
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 48, bottom: 12, right: 48)
        
        button.backgroundColor = theme.backgroundColor
        button.setTitleColor(theme.textColor, for: .normal)
    }
    
}

extension JujuButton {
    
    @objc
    private func buttonAction() {
        onTapAction?()
    }
}

extension JujuButton {
    
    enum Theme {
        
        case primary
        case secondary
        
        var textColor: UIColor {
            switch self {
            case .primary:
                return Resources.Colors.pink
            case .secondary:
                return Resources.Colors.white
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return Resources.Colors.white
            case .secondary:
                return Resources.Colors.pink
            }
        }
    }
}
