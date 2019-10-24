//
//  DateFormatters.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

public enum DateFormatters { }

extension DateFormatters {
    
    public enum Format: String {

        case iso8601UTCDash
        case iso8601LocalTimeDash
        case iso8601UTCBar
        case iso8601Long
    }
    
    public static func dateFormatter(withFormat format: Format) -> DateFormatter {
        
        let formatter = DateFormatter()
        
        switch format {

        case .iso8601UTCDash, .iso8601LocalTimeDash:

            formatter.dateFormat = "yyyy-MM-dd"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")

        case .iso8601UTCBar:

            formatter.dateFormat = "dd/MM/yyyy"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")

        case .iso8601Long:

            formatter.dateFormat = "dd 'de' MMMM yyyy"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "pt-br")

        }
        
        return formatter
    }
}
