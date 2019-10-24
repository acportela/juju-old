//
//  DateSummaryViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

final class DateSummaryViewController: UIViewController {

    public static let title = ""
    private let daySummaryView = DaySummaryView()
    private let diary: DiaryProgress

    init(diary: DiaryProgress) {

        self.diary = diary
        super.init(nibName: nil, bundle: nil)
        self.daySummaryView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {

        self.view = self.daySummaryView
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        let slowConfig = self.buildConfigurationForMode(.slow)
        let fastConfig = self.buildConfigurationForMode(.fast)

        let dateTitle = DateUtils().stringFromDate(self.diary.date,
                                                   withFormat: .iso8601Long)

        let dayConfig = DaySummaryViewConfiguration(title: dateTitle,
                                                    slowConfiguration: slowConfig,
                                                    fastConfiguration: fastConfig)
        
        self.daySummaryView.configure(with: .build(dayConfig))
    }

    private func buildConfigurationForMode(_ mode: TrainingMode) -> [DayItemViewConfiguration] {

        let easy = self.diary.getSeriesFor(mode: mode, andLevel: .easy) ?? .fallback
        let medium = self.diary.getSeriesFor(mode: mode, andLevel: .medium) ?? .fallback
        let hard = self.diary.getSeriesFor(mode: mode, andLevel: .hard) ?? .fallback

        let easyConfig = DayItemViewConfiguration(title: easy.description,
                                                  titleBoldTerm: easy.completed.description,
                                                  description: "Nível Fácil",
                                                  descriptionBoldTerm: "Nível Fácil")

        let mediumConfig = DayItemViewConfiguration(title: medium.description,
                                                    titleBoldTerm: medium.completed.description,
                                                    description: "Nível Médio",
                                                    descriptionBoldTerm: "Nível Médio")

        let hardConfig = DayItemViewConfiguration(title: hard.description,
                                                    titleBoldTerm: hard.completed.description,
                                                    description: "Nível Difícil",
                                                    descriptionBoldTerm: "Nível Difícil")

        return [easyConfig, mediumConfig, hardConfig]
    }
}

extension DateSummaryViewController: DaySummaryViewDelegate {

    func daySummaryViewWasTappedOutsideContentView(_ view: DaySummaryView) {

        self.dismiss(animated: false, completion: nil)
    }
}
