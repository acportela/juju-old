//
//  DaySummaryHeaderView.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class DaySummaryHeaderView: UIView {

    // MARK: Views
    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.slateGrey
        label.font = Resources.Fonts.Rubik.medium(ofSize: Styling.FontSize.fourteen)
        return label
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

extension DaySummaryHeaderView: ViewCoding {

    func addSubViews() {

        self.addSubview(self.titleLabel)
    }

    func setupConstraints() {

        self.titleLabel.snp.makeConstraints { make in

            make.center.equalToSuperview()
        }
    }

    func configureViews() {

        self.backgroundColor = Styling.Colors.paleBlue
        self.layer.cornerRadius = 2
    }
}

extension DaySummaryHeaderView: ViewConfiguration {

    enum States {

        case build(title: String)
    }

    func configure(with state: DaySummaryHeaderView.States) {

        switch state {

        case .build(let title):

            self.titleLabel.text = title.capitalized
        }
    }
}
