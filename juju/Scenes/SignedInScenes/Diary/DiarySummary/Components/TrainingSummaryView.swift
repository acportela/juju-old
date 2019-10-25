//
//  TrainingSummaryView.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol TrainingSummaryViewDelegate: AnyObject {

    func trainingSummaryViewWasTappedOutsideContentView(_ view: TrainingSummaryView)
}

final class TrainingSummaryView: UIView {

    // MARK: Views

    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.fourteen)
        return label
    }()

    private let slowSection = MetricSectionView()
    private let fastSection = MetricSectionView()

    private let containerView = UIView()

    weak var delegate: TrainingSummaryViewDelegate?

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

        self.addSubview(self.containerView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.slowSection)
        self.containerView.addSubview(self.fastSection)
    }

    func setupConstraints() {

        self.containerView.snp.makeConstraints { make in
            
            make.width.equalTo(Constants.viewWidth)
            make.height.equalTo(Constants.viewHeight)
            make.center.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Styling.Spacing.twentyfour)
        }

        self.slowSection.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Styling.Spacing.twentyfour)
        }

        self.fastSection.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.slowSection.snp.bottom).offset(Styling.Spacing.twentyfour)
        }
    }

    func configureViews() {

        self.containerView.layer.cornerRadius = 4

        self.backgroundColor = Styling.Colors.greyishBrown.withAlphaComponent(Constants.backgroundAlpha)
        self.containerView.backgroundColor = Styling.Colors.white

        self.addTapGesture()
    }
}

extension TrainingSummaryView: ViewConfiguration {

    enum States {

        case build(TrainingSummaryViewConfiguration)
    }

    func configure(with state: TrainingSummaryView.States) {

        switch state {

        case .build(let config):

            self.slowSection.configure(with: .build(title: "Treino Lento",
                                                    items: config.slowConfiguration))
            self.fastSection.configure(with: .build(title: "Treino Rápido",
                                                    items: config.fastConfiguration))
            self.titleLabel.text = config.title
            
        }
    }
}

extension TrainingSummaryView: UIGestureRecognizerDelegate {

    private func addTapGesture() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.wasTapped))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    @objc
    private func wasTapped() {

        self.delegate?.trainingSummaryViewWasTappedOutsideContentView(self)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {

        return (touch.view === self)
    }
}

extension TrainingSummaryView {

    struct Constants {

        static let viewWidth = 268
        static let viewHeight = 335
        static let backgroundAlpha: CGFloat = 0.32
    }
}
