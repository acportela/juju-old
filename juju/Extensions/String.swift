//
//  String.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

extension String {
    
    public static let empty = ""
    
    public var first: String {
        
        return String(self.prefix(1))
    }
    
    public var uppercasedFirst: String {
        
        return first.uppercased() + String(self.dropFirst())
    }
    
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
