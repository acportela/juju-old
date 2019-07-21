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
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Resources.Fonts.Gilroy.bold(ofSize: 18)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 48, bottom: 12, right: 48)
        button.backgroundColor = theme.backgroundColor
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var onTapAction: (() -> Void)?
    
    private let theme: Theme
    
    init(title: String, theme: Theme = .primary, frame: CGRect = .zero) {
        self.theme = theme
        super.init(frame: frame)
        button.setTitle(title.uppercasedFirst,
                        withColor: theme.textColor,
                        andFont: Resources.Fonts.Gilroy.bold(ofSize: 16))
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
    
    func configureViews() { }
    
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

extension JujuButton: ViewConfiguration {
    
    enum Configuration {
        case toggleState(enabled: Bool)
    }
    
    func configure(with state: Configuration) {
        switch state {
        case .toggleState(let enabled):
            button.isEnabled = enabled
            let background = theme.backgroundColor
            button.backgroundColor = enabled ? background : background.withAlphaComponent(0.3)
        }
    }
}
