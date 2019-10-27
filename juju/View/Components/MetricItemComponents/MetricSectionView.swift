//
//  MetricSectionView.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

final class MetricSectionView: UIView {

    // MARK: Views
    private let headerLabel = MetricHeaderView()

    private let containerStack: UIStackView = {

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Styling.Spacing.eight
        stack.distribution = .fillEqually
        return stack
    }()

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }
}

extension MetricSectionView: ViewCoding {

    func addSubViews() {

        self.addSubview(self.headerLabel)
        self.addSubview(self.containerStack)
    }

    func setupConstraints() {

        self.headerLabel.snp.makeConstraints { make in

            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.headerHeight)
            make.width.equalTo(Constants.headerWidth)
        }

        self.containerStack.snp.makeConstraints { make in

            make.top.equalTo(self.headerLabel.snp.bottom).offset(Styling.Spacing.ten)
            make.bottom.right.equalToSuperview()
            make.left.equalTo(self.headerLabel.snp.left).offset(-Styling.Spacing.sixteen)
        }
    }

    func configureViews() {

        self.backgroundColor = Styling.Colors.white
    }
}

extension MetricSectionView: ViewConfiguration {

    enum States {

        case build(MetricSectionViewConfiguration)
    }

    func configure(with state: MetricSectionView.States) {

        switch state {

        case .build(let config):

            self.headerLabel.configure(with: .build(title: config.title))

            config.items.forEach { configItem in

                let item = MetricItemView()
                item.configure(with: .build(configItem))
                self.containerStack.addArrangedSubview(item)
            }
        }
    }
}

extension MetricSectionView {

    private enum Constants {

        static let headerWidth = 144
        static let headerHeight = 20
    }
}
