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
        let tempConfig = DayItemViewConfiguration(title: "5 séries",
                                                    titleBoldTerm: "5",
                                                    description: "Nivel Médio",
                                                    descriptionBoldTerm: "Nivel Médio")

        let array = [tempConfig, tempConfig, tempConfig]

        let dayConfig = DaySummaryViewConfiguration(title: "23 de outubro 2019",
                                                    slowConfiguration: array,
                                                    fastConfiguration: array)
        self.daySummaryView.configure(with: .build(dayConfig))
    }
}

extension DateSummaryViewController: DaySummaryViewDelegate {

    func daySummaryViewWasTappedOutsideContentView(_ view: DaySummaryView) {

        self.dismiss(animated: true, completion: nil)
    }
}
