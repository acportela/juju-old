//
//  TrainingSummaryView.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class TrainingSummaryView: UIView {

    // MARK: Views

    private let slowSection = MetricSectionView()
    private let fastSection = MetricSectionView()

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

extension TrainingSummaryView: ViewCoding {

    func addSubViews() {

        self.addSubview(self.slowSection)
        self.addSubview(self.fastSection)
    }

    func setupConstraints() {

        self.slowSection.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }

        self.fastSection.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.slowSection.snp.bottom).offset(Styling.Spacing.twentyfour)
        }
    }

    func configureViews() {

    }
}

extension TrainingSummaryView: ViewConfiguration {

    enum States {

        case build(TrainingSummaryViewConfiguration)
    }

    func configure(with state: TrainingSummaryView.States) {

        switch state {

        case .build(let config):

            let slow = MetricSectionViewConfiguration(title: "Treino Lento",
                                                      items: config.slowConfiguration)

            let fast = MetricSectionViewConfiguration(title: "Treino Rápido",
                                                      items: config.fastConfiguration)

            self.slowSection.configure(with: .build(slow))
            self.fastSection.configure(with: .build(fast))
        }
    }
}

extension TrainingSummaryView {

    struct Constants {

        static let viewWidth = 268
        static let viewHeight = 335
        static let backgroundAlpha: CGFloat = 0.32
    }
}
