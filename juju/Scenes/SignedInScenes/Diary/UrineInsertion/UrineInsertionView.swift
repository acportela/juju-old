//
//  UrineInsertionView.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol UrineInsertionViewDelegate: AnyObject {

    func urineInsertionViewDidTapBack(_ view: UrineInsertionView)
    func urineInsertionViewDidChoose(_ view: UrineInsertionView, index: Int)
}

final class UrineInsertionView: PopoverView {

    // MARK: Views
    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.twenty)
        return label
    }()

    private let radioGroupView = RadioButtonGroupView()
    private let dualButtons = DualActionButtons()

    // MARK: Properties
    weak var delegate: UrineInsertionViewDelegate?
    
    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }

    override func addSubViews() {

        super.addSubViews()
        self.popoverContentView.addSubview(self.titleLabel)
        self.popoverContentView.addSubview(self.radioGroupView)
        self.popoverContentView.addSubview(self.dualButtons)
    }

    override func setupConstraints() {

        super.setupConstraints()

        self.titleLabel.snp.makeConstraints { make in

            make.top.equalToSuperview().offset(Styling.Spacing.sixteen)
            make.left.equalToSuperview().offset(Styling.Spacing.twentyeight)
            make.right.equalToSuperview().offset(-Styling.Spacing.twentyeight)
            make.width.equalTo(Constants.titleWidth)
        }

        self.radioGroupView.snp.makeConstraints { make in

            make.left.equalTo(self.titleLabel.snp.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Styling.Spacing.twentyeight)
        }

        self.dualButtons.snp.makeConstraints { make in

            make.top.equalTo(self.radioGroupView.snp.bottom).offset(Styling.Spacing.thirtytwo)
            make.bottom.equalToSuperview().offset(-Styling.Spacing.twentyfour)
            make.right.equalToSuperview().offset(-Styling.Spacing.twentyfour)
        }
    }

    override func configureViews() {

        super.configureViews()
        self.dualButtons.delegate = self
    }
}

extension UrineInsertionView: ViewConfiguration {

    enum States {

        case build(UrineInsertionViewConfiguration)
    }

    func configure(with state: UrineInsertionView.States) {

        switch state {
        case .build(let config):

            self.titleLabel.text = config.title

            self.dualButtons.configure(with: .build(config.actionButtons))
            self.radioGroupView.configure(with: .build(config.radioGroup))
        }
    }
}

extension UrineInsertionView: DualActionButtonsDelegate {

    func dualActionButtonsDidTapSecondaryAction(_ view: DualActionButtons) {

        self.delegate?.urineInsertionViewDidTapBack(self)
    }

    func dualActionButtonsDidTapPrimaryAction(_ view: DualActionButtons) {

        guard let validIndex = self.radioGroupView.selectedIndex else { return }
        self.delegate?.urineInsertionViewDidChoose(self, index: validIndex)
    }
}

extension UrineInsertionView {

    private enum Constants {

        static let titleWidth = 213
    }
}
