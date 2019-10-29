//
//  RadioButtonGroupView.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class RadioButtonGroupView: UIView {

    // MARK: Views
    private let containerStack: UIStackView = {

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Styling.Spacing.eight
        stack.distribution = .equalCentering
        return stack
    }()

    // MARK: Properties
    private (set) var selectedIndex: Int? {
        didSet {
            guard let validIndex = self.selectedIndex else { return }
            self.manageRadioSelectionForSelected(validIndex)
        }
    }

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }
}

extension RadioButtonGroupView: ViewCoding {

    func addSubViews() {

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

extension RadioButtonGroupView: ViewConfiguration {

    enum States {

        case build(RadioButtonGroupConfiguration)
    }

    func configure(with state: RadioButtonGroupView.States) {

        switch state {

        case .build(let config):

            for title in config.titles.enumerated() {

                let radioItem = RadioButtonView()
                radioItem.delegate = self
                radioItem.configure(with: .build(title: title.element, index: title.offset))
                self.containerStack.addArrangedSubview(radioItem)
            }

            self.selectedIndex = config.selectedIndex
        }
    }
}

extension RadioButtonGroupView {

    private func manageRadioSelectionForSelected(_ selectedIndex: Int) {

        for arrangedView in self.containerStack.arrangedSubviews.enumerated() {

            guard let button = arrangedView.element as? RadioButtonView else { continue }

            button.contextIndex == selectedIndex ? button.configure(with: .selected)
                                                 : button.configure(with: .unselected)
        }
    }
}

extension RadioButtonGroupView: RadioButtonViewDelegate {

    func radioButtonViewWasTapped(_ view: RadioButtonView, withContextIndex index: Int?) {

        self.selectedIndex = index
    }
}
