//
//  DaySummaryView.swift
//  juju
//
//  Created by Antonio Rodrigues on 26/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

protocol DaySummaryViewDelegate: AnyObject {

    func daySummaryViewWasTappedOutsideContentView(_ view: DaySummaryView)
}

final class DaySummaryView: UIView {

    // MARK: Views

    private let titleLabel: UILabel = {

        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Styling.Colors.charcoalGrey
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.fourteen)
        return label
    }()

    private let tabView = TabView()

    private let externalView = UIView()

    private let trainingSummaryView = TrainingSummaryView()
    private let urineSummaryView = MetricSectionView()

    weak var delegate: DaySummaryViewDelegate?

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

extension DaySummaryView: ViewCoding {

    func addSubViews() {

        self.addSubview(self.externalView)
        self.externalView.addSubview(self.tabView)
        self.externalView.addSubview(self.titleLabel)
        self.externalView.addSubview(self.trainingSummaryView)
        self.externalView.addSubview(self.urineSummaryView)
    }

    func setupConstraints() {

        self.externalView.snp.makeConstraints { make in

            make.width.equalTo(Constants.viewWidth)
            make.height.equalTo(Constants.viewHeight)
            make.center.equalToSuperview()
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

    func configureViews() {

        self.externalView.layer.cornerRadius = 4
        self.externalView.backgroundColor = Styling.Colors.white
        self.backgroundColor = Styling.Colors.greyishBrown.withAlphaComponent(Constants.backgroundAlpha)

        self.tabView.delegate = self
        self.addTapGesture()

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

extension DaySummaryView: UIGestureRecognizerDelegate {

    private func addTapGesture() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.wasTapped))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    @objc
    private func wasTapped() {

        self.delegate?.daySummaryViewWasTappedOutsideContentView(self)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {

        return (touch.view === self)
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

        static let viewWidth = 268
        static let viewHeight = 343
        static let tabWidth = 150
        static let tabHeight = 30
        static let trainAndUrineTransitionDuration: TimeInterval = 0.3
        static let backgroundAlpha: CGFloat = 0.32
    }
}
