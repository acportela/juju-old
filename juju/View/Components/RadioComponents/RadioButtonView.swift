//
//  RadioButtonView.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

protocol RadioButtonViewDelegate: AnyObject {

    func radioButtonViewWasTapped(_ view: RadioButtonView, withContextIndex index: Int?)
}

final class RadioButtonView: UIView {

    // MARK: Views
    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.sixteen)
        return label
    }()

    private let radioImage: UIImageView = {

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let containerStack: UIStackView = {

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Styling.Spacing.fourteen
        stack.distribution = .fillProportionally
        return stack
    }()

    // MARK: Properties
    var contextIndex: Int?

    weak var delegate: RadioButtonViewDelegate?

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }
}

extension RadioButtonView: ViewCoding {

    func addSubViews() {

        self.containerStack.addArrangedSubview(self.radioImage)
        self.containerStack.addArrangedSubview(self.titleLabel)
        self.addSubview(self.containerStack)
    }

    func setupConstraints() {

        self.containerStack.snp.makeConstraints { make in

            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(Styling.Spacing.eight)
            make.bottom.equalToSuperview().offset(-Styling.Spacing.eight)
        }

        self.radioImage.snp.makeConstraints { make in

            make.height.width.equalTo(Constants.radioButtonSides)
        }
    }

    func configureViews() {

        self.backgroundColor = .clear
        self.addTapGesture()
    }
}

extension RadioButtonView: ViewConfiguration {

    enum States {

        case build(title: String, index: Int?)
        case selected
        case unselected
    }

    func configure(with state: RadioButtonView.States) {

        switch state {

        case .build(let title, let index):

            self.titleLabel.text = title.capitalized
            self.contextIndex = index

        case .selected:

            self.radioImage.image = Resources.Images.radioChecked

        case .unselected:

            self.radioImage.image = Resources.Images.radioUnchecked

        }
    }
}

extension RadioButtonView {

    private func addTapGesture() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        self.addGestureRecognizer(tapGesture)
    }

    @objc
    private func viewWasTapped() {

        self.delegate?.radioButtonViewWasTapped(self, withContextIndex: self.contextIndex)
    }
}

extension RadioButtonView {

    private enum Constants {

        static let radioButtonSides = 20
    }
}
