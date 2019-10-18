//
//  JujuUnderlinedButton.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

struct JujuUnderlinedButtonConfiguration {
    
    let title: String
    let font: UIFont
    let color: UIColor
}

final class JujuUnderlinedButton: UIView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: Styling.Spacing.eight,
                                                left: Styling.Spacing.eight,
                                                bottom: Styling.Spacing.eight,
                                                right: Styling.Spacing.eight)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var onTapAction: (() -> Void)?
    
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
}

extension JujuUnderlinedButton: ViewCoding {
    
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

extension JujuUnderlinedButton: ViewConfiguration {
    
    enum States {
        
        case build(JujuUnderlinedButtonConfiguration)
    }
    
    func configure(with state: States) {
        
        switch state {
            
        case .build(let config):
            
            button.setTitle(config.title.lowercased(),
                            withColor: config.color,
                            andFont: config.font,
                            underlined: true)
        }
    }
}

extension JujuUnderlinedButton {
    
    @objc
    private func buttonAction() {
        
        onTapAction?()
    }
}
