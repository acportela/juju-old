//
//  DiaryViewItem.swift
//  juju
//
//  Created by Antonio Rodrigues on 20/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class DiaryViewItem: UIView {

    // MARK: Views
    private let countLabel: UILabel = {

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
        stack.distribution = .fillProportionally
        return stack
    }()

    // MARK: Properties

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }
}

extension DiaryViewItem: ViewCoding {

    func addSubViews() {

    }

    func setupConstraints() {

    }

    func configureViews() {

    }
}

extension DiaryViewItem: ViewConfiguration {

    enum States {

    }

    func configure(with state: DiaryViewItem.States) {

    }
}

extension DiaryViewItem {

    struct Constants {

        static let dotSides: CGFloat = 8
    }
}
