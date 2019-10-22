//
//  DayViewSection.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

final class DayViewSection: UIView {

    // MARK: Views
    private let headerLabel = DaySummaryHeaderView()

    private let containerStack: UIStackView = {

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
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

extension DayViewSection: ViewCoding {

    func addSubViews() {

        self.addSubview(self.headerLabel)
        self.addSubview(self.containerStack)
    }

    func setupConstraints() {

        self.headerLabel.snp.makeConstraints { make in

            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
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

extension DayViewSection: ViewConfiguration {

    enum States {

        case build(title: String, items: [DayItemViewConfiguration])
    }

    func configure(with state: DayViewSection.States) {

        switch state {

        case .build(let configs):

            self.headerLabel.configure(with: .build(title: configs.title))

            configs.items.forEach { config in

                let item = DayItemView()
                item.configure(with: .build(config))
                self.containerStack.addArrangedSubview(item)
            }
        }
    }
}
