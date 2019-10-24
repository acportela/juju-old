//
//  DayItemView.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class DayItemView: UIView {

    // MARK: Views
    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.fourteen)
        return label
    }()

    private let descriptionLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let dot: UIImageView = {

        let imageView = UIImageView()
        imageView.image = Resources.Images.dot
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let containerStack: UIStackView = {

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Styling.Spacing.eight
        stack.distribution = .fillProportionally
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

extension DayItemView: ViewCoding {

    func addSubViews() {

        self.containerStack.addArrangedSubview(self.dot)
        self.containerStack.addArrangedSubview(self.titleLabel)
        self.containerStack.addArrangedSubview(self.descriptionLabel)
        self.addSubview(self.containerStack)
    }

    func setupConstraints() {

        self.containerStack.snp.makeConstraints { make in

            make.edges.equalToSuperview()
        }

        self.dot.snp.makeConstraints { make in

            make.width.height.equalTo(Constants.dotSides)
        }
    }

    func configureViews() {

        self.backgroundColor = Styling.Colors.white
    }
}

extension DayItemView: ViewConfiguration {

    enum States {

        case build(DayItemViewConfiguration)
    }

    func configure(with state: DayItemView.States) {

        switch state {

        case .build(let config):

            self.titleLabel
                .setPartuallyUnderlined(title: config.title,
                                        term: config.titleBoldTerm,
                                        color: Styling.Colors.charcoalGrey,
                                        regularFont: Resources.Fonts.Rubik
                                                    .regular(ofSize: Styling.FontSize.fourteen),
                                        termFont: Resources.Fonts.Rubik
                                                    .medium(ofSize: Styling.FontSize.fourteen))

            self.descriptionLabel
                .setPartuallyUnderlined(title: config.description,
                                        term: config.descriptionBoldTerm,
                                        color: Styling.Colors.charcoalGrey,
                                        regularFont: Resources.Fonts.Rubik
                                            .regular(ofSize: Styling.FontSize.fourteen),
                                        termFont: Resources.Fonts.Rubik
                                            .medium(ofSize: Styling.FontSize.fourteen))
        }
    }
}

extension DayItemView {

    struct Constants {

        static let dotSides: CGFloat = 8
    }
}
