//
//  DateFormatters.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

public enum DateFormatters { }

// MARK: - Network encoding/decoding date formats
extension DateFormatters {
    
    public enum Format: String {
        case iso8601UTC
        case iso8601LocalTime
        case yyyyMMddHHmmss
        case yyyyMMdd
        case ddMMyyyy
    }
    
    public static func dateFormatter(withFormat format: Format) -> DateFormatter {
        
        let formatter = DateFormatter()
        
        switch format {
        case .iso8601UTC, .iso8601LocalTime:
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
        case .yyyyMMddHHmmss:
            formatter.dateFormat = "yyyyMMddHHmmss"
        case .yyyyMMdd:
            formatter.dateFormat = "yyyyMMdd"
        case .ddMMyyyy:
            formatter.dateFormat = "ddMMyyyy"
        }
        
        return formatter
        
    }
    
}
