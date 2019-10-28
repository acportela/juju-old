//
//  Array.swift
//  juju
//
//  Created by Antonio Rodrigues on 27/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

extension Array where Element == DiaryProgress {

    func getElementFromDate(_ date: Date) -> (diary: DiaryProgress, index: Int)? {

        let calendar = DateUtils.defaultCalendar

        for diary in self.enumerated()
        where calendar.isDate(date, inSameDayAs: diary.element.date) {

            return (diary: diary.element, index: diary.offset)
        }

        return nil
    }
}

extension Array where Element == UrineLoss {

    var urineRawValues: [Int] {

        return self.map { $0.rawValue }
    }
}
