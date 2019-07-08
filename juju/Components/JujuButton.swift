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
        button.backgroundColor = Resources.Colors.white
        button.setTitleColor(Resources.Colors.pink, for: .normal)
        button.titleLabel?.font = Resources.Fonts.Gilroy.bold(ofSize: 16)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    var onTapAction: (() -> Void)?
    
    init(title: String) {
        super.init(frame: .zero)
        button.setTitle(title.uppercased(), for: .normal)
        setupViewConfiguration()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
}

extension JujuButton {
    
    @objc
    private func buttonAction() {
        onTapAction?()
    }
}
