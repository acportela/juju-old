//
//  DualActionButtons.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol DualActionButtonsDelegate: AnyObject {

    func dualActionButtonsDidTapSecondaryAction(_ view: DualActionButtons)
    func dualActionButtonsDidTapPrimaryAction(_ view: DualActionButtons)
}

final class DualActionButtons: UIView {

    // MARK: Views
    private let containerStack: UIStackView = {

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Styling.Spacing.sixteen
        stack.distribution = .fillProportionally
        return stack
    }()

    private lazy var primaryActionButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: Styling.Spacing.eight,
                                                left: Styling.Spacing.eight,
                                                bottom: Styling.Spacing.eight,
                                                right: Styling.Spacing.eight)

        button.addTarget(self, action: #selector(primaryAction), for: .touchUpInside)
        return button
    }()

    private lazy var secondaryActionButton: UIButton = {
        let button = UIButton()
        button.contentEdgeInsets = UIEdgeInsets(top: Styling.Spacing.eight,
                                                left: Styling.Spacing.eight,
                                                bottom: Styling.Spacing.eight,
                                                right: Styling.Spacing.eight)

        button.addTarget(self, action: #selector(secondaryAction), for: .touchUpInside)
        return button
    }()

    // MARK: Properties
    weak var delegate: DualActionButtonsDelegate?

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }
}

extension DualActionButtons: ViewCoding {

    func addSubViews() {

        self.containerStack.addArrangedSubview(self.secondaryActionButton)
        self.containerStack.addArrangedSubview(self.primaryActionButton)
        self.addSubview(self.containerStack)
    }

    func setupConstraints() {

        self.containerStack.snp.makeConstraints { make in

            make.edges.equalToSuperview()
        }
    }

    func configureViews() {

        self.backgroundColor = .clear
    }
}

extension DualActionButtons: ViewConfiguration {

    enum States {

        case build(DualActionButtonsConfiguration)
    }

    func configure(with state: DualActionButtons.States) {

        switch state {

        case .build(let config):

            let primaryFont = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.fourteen)
            self.primaryActionButton.setTitle(config.primaryTitle.uppercased(),
                                              withColor: Styling.Colors.charcoalGrey,
                                              andFont: primaryFont,
                                              underlined: false)

            let secondaryFont = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.fourteen)
            self.secondaryActionButton.setTitle(config.secondaryTitle.uppercased(),
                                                withColor: Styling.Colors.charcoalGrey,
                                                andFont: secondaryFont,
                                                underlined: false)
        }
    }
}

extension DualActionButtons {

    @objc
    private func primaryAction() {

        self.delegate?.dualActionButtonsDidTapPrimaryAction(self)
    }

    @objc
    private func secondaryAction() {

        self.delegate?.dualActionButtonsDidTapSecondaryAction(self)
    }
}
