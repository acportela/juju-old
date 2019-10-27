//
//  DaySummaryViewConfiguration.swift
//  juju
//
//  Created by Antonio Rodrigues on 26/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DaySummaryViewConfiguration {

    let dateTitle: String
    let tabTitles: [String]
    let defaultTabIndex: Int
    let trainingSummaryConfiguration: TrainingSummaryViewConfiguration
    let urineConfiguration: MetricSectionViewConfiguration
}
