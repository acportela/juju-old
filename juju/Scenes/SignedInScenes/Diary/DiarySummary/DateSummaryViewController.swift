//
//  DateSummaryViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class DaySummaryViewController: UIViewController {

    public static let title = ""
    private let daySummaryView = DaySummaryView()
    private let diary: DiaryProgress

    init(diary: DiaryProgress) {

        self.diary = diary
        super.init(nibName: nil, bundle: nil)
        self.daySummaryView.popoverDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        self.view = self.daySummaryView
    }

    override func viewDidLoad() {

        super.viewDidLoad()
        self.setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {

        self.dismiss(animated: false, completion: nil)
        super.viewWillDisappear(animated)
    }
}

extension DaySummaryViewController {

    private func setupViews() {

        let slowConfig = self.buildConfigurationForMode(.slow)
        let fastConfig = self.buildConfigurationForMode(.fast)
        let trainingConfig = TrainingSummaryViewConfiguration(slowConfiguration: slowConfig,
                                                              fastConfiguration: fastConfig)

        let dateTitle = DateUtils().stringFromDate(self.diary.date,
                                                   withFormat: .iso8601Long)

        let urineSummaryConfig = self.buildUrineItemConfigurations()
        let dayConfig = DaySummaryViewConfiguration(dateTitle: dateTitle,
                                                    tabTitles: ["Séries", "Urina"],
                                                    defaultTabIndex: 0,
                                                    trainingSummaryConfiguration: trainingConfig,
                                                    urineConfiguration: urineSummaryConfig)

        self.daySummaryView.configure(with: .build(dayConfig))
    }

    private func buildConfigurationForMode(_ mode: TrainingMode) -> [MetricItemViewConfiguration] {

        let easy = self.diary.getSeriesFor(mode: mode, andLevel: .easy) ?? .fallback
        let medium = self.diary.getSeriesFor(mode: mode, andLevel: .medium) ?? .fallback
        let hard = self.diary.getSeriesFor(mode: mode, andLevel: .hard) ?? .fallback

        let dotColor = Styling.Colors.duskyPink

        let easyConfig = MetricItemViewConfiguration(title: easy.description,
                                                     titleBoldTerm: easy.completed.description,
                                                     description: "Nível Fácil",
                                                     descriptionBoldTerm: "Nível Fácil",
                                                     dotColor: dotColor)

        let mediumConfig = MetricItemViewConfiguration(title: medium.description,
                                                       titleBoldTerm: medium.completed.description,
                                                       description: "Nível Médio",
                                                       descriptionBoldTerm: "Nível Médio",
                                                       dotColor: dotColor)

        let hardConfig = MetricItemViewConfiguration(title: hard.description,
                                                     titleBoldTerm: hard.completed.description,
                                                     description: "Nível Difícil",
                                                     descriptionBoldTerm: "Nível Difícil",
                                                     dotColor: dotColor)

        return [easyConfig, mediumConfig, hardConfig]
    }

    private func buildUrineItemConfigurations() -> MetricSectionViewConfiguration {

        let configs = self.diary.urineLosses.map { loss in

            return MetricItemViewConfiguration(title: "Perda de urina",
                                               titleBoldTerm: .empty,
                                               description: loss.destription,
                                               descriptionBoldTerm: loss.destription,
                                               dotColor: Styling.Colors.wheat)
        }

        let title = "Perdas Hoje: \(self.diary.urineLosses.count)"
        return MetricSectionViewConfiguration(title: title, items: configs)
    }
}

extension DaySummaryViewController: PopoverViewDelegate {

    func popoverViewWasTappedOutsideContentView(_ view: PopoverView) {

        self.dismiss(animated: false, completion: nil)
    }
}
