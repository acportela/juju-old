//
//  DateUtils.swift
//  juju
//
//  Created by Antonio Rodrigues on 06/08/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DateUtils {
    
    static let defaultCalendar = Calendar.current
    
    func calculateDateFrom(_ start: Date, to end: Date) -> DateComponents {
        
        return DateUtils.defaultCalendar.dateComponents([.year, .month, .day], from: start, to: end)
    }
    
    func dateFromString(_ dateString: String,
                        withFormat format: DateFormatters.Format = .iso8601UTC,
                        andStyle style: DateFormatter.Style = .short) -> Date? {
        
        let formatter = DateFormatters.dateFormatter(withFormat: format)
        formatter.dateStyle = style
        return formatter.date(from: dateString)
    }
    
    func stringFromDate(_ date: Date,
                        withFormat format: DateFormatters.Format = .iso8601UTC,
                        andStyle style: DateFormatter.Style = .short) -> String {
        
        let formatter = DateFormatters.dateFormatter(withFormat: format)
        formatter.dateStyle = style
        
        return formatter.string(from: date)
    }
}
