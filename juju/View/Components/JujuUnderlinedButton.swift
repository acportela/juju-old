//
//  JujuUnderlinedButton.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class JujuUnderlinedButton: UIView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var onTapAction: (() -> Void)?
    
    init(title: String, frame: CGRect = .zero) {

        super.init(frame: frame)
        
        button.setTitle(title.lowercased(),
                        withColor: Resources.Colors.white,
                        andFont: Resources.Fonts.Gilroy.bold(ofSize: 18),
                        underlined: true)
        
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

extension JujuUnderlinedButton {
    
    @objc
    private func buttonAction() {
        onTapAction?()
    }
}
