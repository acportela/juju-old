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
        button.titleLabel?.font = Resources.Fonts.Montserrat.medium(ofSize: 16)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    var onTapAction: (() -> Void)?
    
    init(title: String) {
        let frame = CGRect(x: 0, y: 0, width: 155, height: 42)
        super.init(frame: frame)
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
    }
    
}

extension JujuButton {
    
    @objc
    private func buttonAction() {
        onTapAction?()
    }
}
