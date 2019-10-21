//
//  DateUtils.swift
//  juju
//
//  Created by Antonio Rodrigues on 06/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DateUtils {

    // TODO: Implement localization first and change this to .autoupdatingCurrent
    static let defaultCalendar: Calendar = {
        var cal = Calendar(identifier: .iso8601)
        cal.locale = Locale(identifier: "pt-br")
        return cal
    }()
    
    func calculateDateFrom(_ start: Date, to end: Date) -> DateComponents {
        
        return DateUtils.defaultCalendar.dateComponents([.year, .month, .day], from: start, to: end)
    }

    func getStartOf(_ component: Calendar.Component) -> Date {

        DateUtils.defaultCalendar.dateInterval(of: component, for: Date())!.start
    }

    func getStartOfNext(_ component: Calendar.Component) -> Date {

        DateUtils.defaultCalendar.dateInterval(of: component, for: Date())!.end
    }

    func oneYearBehind() -> Date {
        let components = DateComponents(year: -1)
        return Calendar.current.date(byAdding: components,
                                     to: Date())!
    }

    func oneYearFromNow() -> Date {
        let components = DateComponents(year: 1)
        return Calendar.current.date(byAdding: components,
                                     to: Date())!
    }

    func dateFromString(_ dateString: String,
                        withFormat format: DateFormatters.Format) -> Date? {
        
        let formatter = DateFormatters.dateFormatter(withFormat: format)
        return formatter.date(from: dateString)
    }
    
    func stringFromDate(_ date: Date,
                        withFormat format: DateFormatters.Format) -> String {
        
        let formatter = DateFormatters.dateFormatter(withFormat: format)

        return formatter.string(from: date)
    }
}
