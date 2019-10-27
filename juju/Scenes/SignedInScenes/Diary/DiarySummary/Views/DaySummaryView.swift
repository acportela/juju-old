//
//  DaySummaryView.swift
//  juju
//
//  Created by Antonio Rodrigues on 26/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class DaySummaryView: PopoverView {

    // MARK: Views
    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.fourteen)
        return label
    }()

    private let tabView = TabView()
    private let trainingSummaryView = TrainingSummaryView()
    private let urineSummaryView = MetricSectionView()

    // MARK: Lifecycle
    override init(frame: CGRect = .zero) {

        super.init(frame: frame)
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("Initialize with view code")
    }

    override func addSubViews() {

        super.addSubViews()

        self.popoverContentView.addSubview(self.tabView)
        self.popoverContentView.addSubview(self.titleLabel)
        self.popoverContentView.addSubview(self.trainingSummaryView)
        self.popoverContentView.addSubview(self.urineSummaryView)
    }

    override func setupConstraints() {

        self.popoverContentView.snp.makeConstraints { make in

            make.center.equalToSuperview()
            make.width.equalTo(Constants.popoverWidth)
            make.height.equalTo(Constants.popoverHeight)
        }

        self.tabView.snp.makeConstraints { make in

            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.tabHeight)
            make.width.equalTo(Constants.tabWidth)
            make.top.equalToSuperview().offset(Styling.Spacing.sixteen)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tabView.snp.bottom).offset(Styling.Spacing.twentyfour)
        }

        self.trainingSummaryView.snp.makeConstraints { make in

            make.top.equalTo(self.titleLabel.snp.bottom).offset(Styling.Spacing.sixteen)
            make.centerX.equalToSuperview()
        }

        self.urineSummaryView.snp.makeConstraints { make in

            make.top.equalTo(self.titleLabel.snp.bottom).offset(Styling.Spacing.sixteen)
            make.centerX.equalToSuperview()
        }
    }

    override func configureViews() {

        super.configureViews()

        self.tabView.delegate = self
        self.trainingSummaryView.isHidden = true
        self.urineSummaryView.isHidden = true
    }
}

extension DaySummaryView: ViewConfiguration {

    enum States {

        case build(DaySummaryViewConfiguration)
    }

    func configure(with state: DaySummaryView.States) {

        switch state {

        case .build(let config):

            if config.defaultTabIndex == 0 {
                self.trainingSummaryView.isHidden = false
            }

            if config.defaultTabIndex == 1 {
                self.urineSummaryView.isHidden = false
            }

            self.titleLabel.text = config.dateTitle
            self.tabView.configure(with: .build(config.tabTitles, config.defaultTabIndex))
            self.trainingSummaryView.configure(with: .build(config.trainingSummaryConfiguration))
            self.urineSummaryView.configure(with: .build(config.urineConfiguration))
        }
    }
}

extension DaySummaryView: TabViewDelegate {

    func tabView(_ view: TabView, didSelectTabAt index: Int) {

        UIView.animate(withDuration: Constants.trainAndUrineTransitionDuration) {

            if index == 0 {

                self.urineSummaryView.isHidden = true
                self.trainingSummaryView.isHidden = false
                return
            }

            if index == 1 {

                self.trainingSummaryView.isHidden = true
                self.urineSummaryView.isHidden = false
                return
            }
        }
    }
}

extension DaySummaryView {

    struct Constants {

        static let popoverWidth = 268
        static let popoverHeight = 343
        static let tabWidth = 150
        static let tabHeight = 30
        static let trainAndUrineTransitionDuration: TimeInterval = 0.3
    }
}
